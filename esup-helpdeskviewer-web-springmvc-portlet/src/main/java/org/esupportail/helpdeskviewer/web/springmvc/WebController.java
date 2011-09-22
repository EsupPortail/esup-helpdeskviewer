package org.esupportail.helpdeskviewer.web.springmvc;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.esupportail.helpdesk.services.remote.ArrayOfSimpleTicketView;
import org.esupportail.helpdesk.services.remote.ArrayOfString;
import org.esupportail.helpdeskviewer.domain.DomainService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
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

	@RequestMapping("VIEW")
	public ModelAndView renderView(RenderRequest request,
			RenderResponse response) throws Exception {
		
		Map<String, Object> model = new HashMap<String, Object>();

		final PortletPreferences prefs = request.getPreferences();
		String wsdlLocation = prefs.getValue(PREF_WSDL_LOCATION, null);
		String maxTickets = prefs.getValue(PREF_MAX_TICKETS, null);
		String userUidAttr = prefs.getValue(PREF_USER_UID_ATTR, "uid");

		
		try {
			Map userInfo = (Map) request.getAttribute(PortletRequest.USER_INFO);
			String uid = (String) userInfo.get(userUidAttr);
			
			String[] splitWsdlLocation = wsdlLocation.split("xfire");
			String	urlHelpdesk = splitWsdlLocation[0];

			boolean userViewBool = true;

			String selectedTicketFilterId = "ANY";

			// Interface gestionnaire / utilisateur
			String userViewBoolString = request.getParameter("userView");

			if (userViewBoolString != null)
				userViewBool = new Boolean(userViewBoolString).booleanValue();

			if (request.getParameter("selectedTicketFilter") != null)
				selectedTicketFilterId = request
						.getParameter("selectedTicketFilter");

			log.debug("selectedTicketFilterId=" + selectedTicketFilterId);

			// Nombre de tickets visible par défaut : 10
			ArrayOfSimpleTicketView tickets = domainService.getLastTickets(wsdlLocation, uid,
					Integer.parseInt(maxTickets), selectedTicketFilterId,
					userViewBool);

			ArrayOfString filters = domainService.getInvolvementFilters(wsdlLocation, userViewBool);

			// Message si aucun ticket
			if (tickets.getSimpleTicketView().isEmpty())
				model.put("noTicketsMsg", "1");

			model.put("tickets", tickets.getSimpleTicketView());
			model.put("filters", filters.getString());
			model.put("userViewBool", userViewBool);
			model.put("urlHelpdesk", urlHelpdesk);
			model.put("selectedTicketFilterId", selectedTicketFilterId);
			return new ModelAndView(viewSelector
					.getHelpdeskviewerViewName(request), model);
		} catch (Exception e) {
		    log.error("Error during renderView portlet:", e);
		    return new ModelAndView("error", model);
		}
	}

}
