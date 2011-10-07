package org.esupportail.helpdeskviewer.web.springmvc;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;
import javax.portlet.ReadOnlyException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ValidatorException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.esupportail.helpdesk.services.remote.ArrayOfSimpleTicketView;
import org.esupportail.helpdesk.services.remote.ArrayOfString;
import org.esupportail.helpdeskviewer.domain.DomainService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.portlet.ModelAndView;


/**
 * Spring controller which implements the Controller interface.
 */
@Controller
public class WebController {

	@Resource
	protected DomainService domainService;
	
	@Resource
	protected ViewSelectorDefault viewSelector;

	private Log log = LogFactory.getLog(getClass());

	private static final String PREF_WSDL_LOCATION = "wsdlLocation";
	private static final String PREF_MAX_TICKETS = "maxTickets";
	private static final String PREF_USER_UID_ATTR = "userUidAttr";	
	private static final String PREF_DEFAULT_USERVIEW = "defaultUserView";
	private static final String PREF_DEFAULT_FILTER = "defaultFilter";	
	private static final String PREF_PORTLET_FNAME = "portletFname";
	
	private static final String URL_SERVLET_HOME = "stylesheets/welcome.faces";	
	private static final String URL_PORTLET_HOME = "uPortal/render.userLayoutRootNode.uP";	
	
	@RequestMapping("VIEW")
	public ModelAndView renderView(@RequestParam(required=false) String userView, 
   		 	@RequestParam(required=false) String filter,
   		 	RenderRequest request, RenderResponse response) {
		
		Map<String, Object> model = new HashMap<String, Object>();

		final PortletPreferences prefs = request.getPreferences();
		
		String wsdlLocation = prefs.getValue(PREF_WSDL_LOCATION, null);
		String maxTickets = prefs.getValue(PREF_MAX_TICKETS, null);
		String userUidAttr = prefs.getValue(PREF_USER_UID_ATTR, "uid");
		String portletFname = prefs.getValue(PREF_PORTLET_FNAME, null);
		log.info("Préférences -> wsdlLocation : "+ wsdlLocation + " maxTickets: " + maxTickets + " userUidAttr: " + userUidAttr);
		
		String defaultUserView = prefs.getValue(PREF_DEFAULT_USERVIEW, "user");
		String defaultFilter = prefs.getValue(PREF_DEFAULT_FILTER, "ANY");	
		log.debug("Préférences -> defaultUserView : "+ defaultUserView + " defaultFilter: " + defaultFilter);

		if(userView == null) 
			userView = defaultUserView;
		if(filter == null) 
			filter = defaultFilter;
		log.info("Préférences+Request -> userView : "+ userView + " filter: " + filter);
		boolean userViewBool = "user".equals(userView) ? true : false;
		
		Map userInfo = (Map) request.getAttribute(PortletRequest.USER_INFO);
		String uid = (String) userInfo.get(userUidAttr);
		if(uid == null){
			log.error("Can't get uid of user !");
		}
		log.debug("Get uid from USER_INFO[" + userUidAttr + "] : " + uid);
				
		String[] splitWsdlLocation = wsdlLocation.split("xfire");
		String	urlHelpdesk = splitWsdlLocation[0];
		
		// Test if user can see manager interface
		// TODO: get user capacities from esup-helpdesk WS
		boolean isManagerViewAble = !userViewBool;
		if (!isManagerViewAble && !domainService.getLastTickets(wsdlLocation, uid,	1, "ANY",false).getSimpleTicketView().isEmpty()){
			isManagerViewAble = new Boolean("true").booleanValue();
		}
		if(log.isDebugEnabled()) {
			if(!isManagerViewAble)
				log.debug("We don't show manager view possibility because there is no viewable last tickets for this user in helpdesk " +
					"and his default view in portal pref is not the manager view ... " +
					"TODO: make this better with additional methods in EsupHelpdesk WS");
		}
		
		ArrayOfSimpleTicketView tickets = domainService.getLastTickets(wsdlLocation, uid,
				Integer.parseInt(maxTickets), filter,
				userViewBool);
		

		ArrayOfString filters = domainService.getInvolvementFilters(wsdlLocation, userViewBool);

		// Message si aucun ticket
		if (tickets.getSimpleTicketView().isEmpty())
			model.put("noTicketsMsg", "1");
		
		log.info("Number of retrieved Tickets: "+ tickets.getSimpleTicketView().size());
		
		//Liens menu
		String linkHome,linkAddTicket,linkFaq;
		if(portletFname.isEmpty()){
			 linkHome=urlHelpdesk.concat(URL_SERVLET_HOME).concat("?args=page=welcome");
			 linkAddTicket=urlHelpdesk.concat(URL_SERVLET_HOME).concat("?args=page=addTicket");
			 linkFaq=urlHelpdesk.concat(URL_SERVLET_HOME).concat("?args=page=faq");
		}
		else{
			linkHome=urlHelpdesk.concat(URL_PORTLET_HOME).concat("?uP_fname=").concat(portletFname).concat("&uP_args=page=welcome");
			linkAddTicket=urlHelpdesk.concat(URL_PORTLET_HOME).concat("?uP_fname=").concat(portletFname).concat("&uP_args=page=addTicket");
			linkFaq=urlHelpdesk.concat(URL_PORTLET_HOME).concat("?uP_fname=").concat(portletFname).concat("&uP_args=page=faq");
		}
		
		model.put("linkHome",linkHome);
		model.put("linkAddTicket",linkAddTicket);
		model.put("linkFaq",linkFaq);
		model.put("tickets", tickets.getSimpleTicketView());
		model.put("filters", filters.getString());
		model.put("isManagerViewAble", isManagerViewAble);
		model.put("userView", userView);
		model.put("filter", filter);
		model.put("urlHelpdesk", urlHelpdesk);
		return new ModelAndView(viewSelector
				.getHelpdeskviewerViewName(request), model);
		
	}
	
	 /**
	  * Goal of this modifyUserView is just to save the last selected filter and userView of the user
	  * so that on his next session, he recovers the same view ..
	  * 
	  * If preferences defaultUserView and defaultFilter preferences are set up to "readonly", we don't try to save its
	  * (and actually this method does nothing).
	  *   
	 * @param request
	 * @param response
	 * @param userView
	 * @param filter
	 * @throws ReadOnlyException
	 * @throws ValidatorException
	 * @throws IOException
	 */
	@RequestMapping(value = { "VIEW" }, params = { "action=modifyUserView" })
     public void modifyUserView(ActionRequest request, ActionResponse response,
    		 @RequestParam String userView, 
    		 @RequestParam String filter) throws ReadOnlyException, ValidatorException, IOException {

		 	log.debug("modifyUserView action called");
		 	boolean prefsMustBeSaved = false; 
			final PortletPreferences prefs = request.getPreferences();	

			if(!prefs.isReadOnly(PREF_DEFAULT_USERVIEW) && !userView.equals(prefs.getValue(PREF_DEFAULT_USERVIEW, null))) {
				prefs.setValue(PREF_DEFAULT_USERVIEW, userView);
				log.info("Set PREF_DEFAULT_USERVIEW for this user : " + userView);
				// we re-initialize defaultUserView to "ANY" ...
				filter = "ANY";
				prefsMustBeSaved = true;
			} 

			if(!prefs.isReadOnly(PREF_DEFAULT_FILTER) && !filter.equals(prefs.getValue(PREF_DEFAULT_FILTER, null))) {
				prefs.setValue(PREF_DEFAULT_FILTER, filter);
				log.info("Set PREF_DEFAULT_FILTER for this user : " + filter);
				prefsMustBeSaved = true;
			}
			
			if(prefsMustBeSaved) {
				prefs.store();
			}
			
			// so that it works even if prefs are readonly, we send defaultUserView and defaultFilter like renderParameter to the view
			response.setRenderParameter("userView", userView);
			response.setRenderParameter("filter", filter);

	 }
}
