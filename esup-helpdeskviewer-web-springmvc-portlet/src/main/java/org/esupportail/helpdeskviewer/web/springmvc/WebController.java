/**
 * Copyright (C) 2011 Esup Portail http://www.esup-portail.org
 * Copyright (C) 2011 UNR RUNN http://www.unr-runn.fr
 * @Author (C) 2011 Jean-Pierre Tran <Jean-Pierre.Tran@univ-rouen.fr>
 * @Contributor (C) 2011 Vincent Bonamy <Vincent.Bonamy@univ-rouen.fr>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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


@Controller
public class WebController {

	@Resource
	protected DomainService domainService;
	
	@Resource
	protected ViewSelectorDefault viewSelector;

	private Log log = LogFactory.getLog(getClass());

	public static final String PREF_WSDL_LOCATION = "wsdlLocation";
	public static final String PREF_MAX_TICKETS = "maxTickets";
	public static final String PREF_USER_UID_ATTR = "userUidAttr";	
	public static final String PREF_DEFAULT_USERVIEW = "defaultUserView";
	public static final String PREF_DEFAULT_FILTER = "defaultFilter";	
	public static final String PREF_PORTLET_FNAME = "portletFname";
	public static final String PREF_TARGET = "target";
	public static final String PREF_TAB_ANY = "display_anyTab";	
	public static final String PREF_TAB_ALL = "display_allTab";
	public static final String PREF_HELPDESK_MESSAGE = "helpdeskMessage";
	public static final String PREF_AUTH_URL = "authUrl";
	
	private static final String URL_PORTLET_HOME = "uPortal/render.userLayoutRootNode.uP";	
	
	@RequestMapping("VIEW")
	public ModelAndView renderView(@RequestParam(required=false) String userView, 
   		 	@RequestParam(required=false) String filter,
   		 	RenderRequest request, RenderResponse response) throws ReadOnlyException {
		
		Map<String, Object> model = new HashMap<String, Object>();

		final PortletPreferences prefs = request.getPreferences();
		
		String wsdlLocation = prefs.getValue(PREF_WSDL_LOCATION, null);
		String maxTickets = prefs.getValue(PREF_MAX_TICKETS, null);
		String userUidAttr = prefs.getValue(PREF_USER_UID_ATTR, "uid");
		String portletFname = prefs.getValue(PREF_PORTLET_FNAME, null);
		String target = prefs.getValue(PREF_TARGET, "_blank");	
		String display_anyTab = prefs.getValue(PREF_TAB_ANY, "false");		
		String display_allTab = prefs.getValue(PREF_TAB_ALL, "false");		
		String helpdeskMessage = prefs.getValue(PREF_HELPDESK_MESSAGE, null);	
		String authUrl = prefs.getValue(PREF_AUTH_URL, null);
		
		log.info("prefs -> wsdlLocation : "+ wsdlLocation + " maxTickets: " 
				+ maxTickets + " userUidAttr: " + userUidAttr + " portletFname: " + portletFname + " target: " + target
				 + "display_anyTab: " + display_anyTab + "display_allTab: " + display_allTab + "helpdeskMessage" + helpdeskMessage + "authUrl" +authUrl);

		if(userView == null) {
			userView = prefs.getValue(PREF_DEFAULT_USERVIEW, "user");
		}
		if(filter == null) { 
			filter = prefs.getValue(PREF_DEFAULT_FILTER, "ANY");	
		}
		if ((display_anyTab.equalsIgnoreCase("false"))&& (display_allTab.equalsIgnoreCase("false"))){
			if(userView.equalsIgnoreCase("manager")){
				filter = "MANAGED";
			}
			if(userView.equalsIgnoreCase("user")){
				filter = "OWNER";
			}		
		}
		
		log.info("Prefs+Request -> userView : "+ userView + " filter: " + filter);
		boolean userViewBool = "user".equals(userView) ? true : false;
		
		Map userInfo = (Map) request.getAttribute(PortletRequest.USER_INFO);
		String uid = (String) userInfo.get(userUidAttr);
		if(uid == null){
			log.error("Can't get uid of user !");
		}
		log.debug("Get uid from USER_INFO[" + userUidAttr + "] : " + uid);
				
		
		// Test if user can see manager interface. Work only with future official version of esup-helpdesk!!!!..(Patched for us)
		boolean isManagerViewAble= domainService.isDepartmentManager(wsdlLocation, uid);

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

		// Message if no ticket
		if (tickets.getSimpleTicketView().isEmpty())
			model.put("noTicketsMsg", "1");
		
		log.info("Number of retrieved Tickets: "+ tickets.getSimpleTicketView().size());
		
		//Liens menu
		String linkHome,linkAddTicket,linkFaq;
		if(portletFname.isEmpty()){	
			 linkHome = authUrl.concat("?args=page=welcome");
			 linkAddTicket = authUrl.concat("?args=page=addTicket");
			 linkFaq = authUrl.concat("?args=page=faq");		 		 
		}
		else{
			linkHome = "/".concat(URL_PORTLET_HOME).concat("?uP_fname=").concat(portletFname).concat("&uP_args=page=welcome");
			linkAddTicket = "/".concat(URL_PORTLET_HOME).concat("?uP_fname=").concat(portletFname).concat("&uP_args=page=addTicket");
			linkFaq = "/".concat(URL_PORTLET_HOME).concat("?uP_fname=").concat(portletFname).concat("&uP_args=page=faq");
		}
		
		model.put("linkHome",linkHome);
		model.put("linkAddTicket",linkAddTicket);
		model.put("linkFaq",linkFaq);
		model.put("tickets", tickets.getSimpleTicketView());
		model.put("filters", filters.getString());
		model.put("isManagerViewAble", isManagerViewAble);
		model.put("userView", userView);
		model.put("filter", filter);
		model.put("urlHelpdesk", linkHome);
		model.put("target", target);
		model.put("display_anyTab", display_anyTab);
		model.put("display_allTab", display_allTab);
		model.put("helpdeskMessage",helpdeskMessage);
		
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
				//filter = "ANY";
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
			
			// so that it works even if prefs are readonly, we send userView and filter like renderParameter to the view
			response.setRenderParameter("userView", userView);
			response.setRenderParameter("filter", filter);

	 }
}
