

package org.esupportail.helpdeskviewer.web.springmvc;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletMode;
import javax.portlet.PortletPreferences;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.apache.log4j.Logger;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.portlet.ModelAndView;

@Controller
@Scope("request")
public class WebControllerEdit {

	protected Logger log = Logger.getLogger(WebControllerEdit.class);
	public final String MINE_VIEW = "mine";
	public final String ANY_VIEW = "any";
	public final String ALL_VIEW = "all";
	
    @RequestMapping("EDIT")
	public ModelAndView renderEditView(RenderRequest request, RenderResponse response) throws Exception {
        	
		ModelMap model = new ModelMap();
		final PortletPreferences prefs = request.getPreferences();
		String recupPrefDisplay_anyTab = prefs.getValue(WebController.PREF_TAB_ANY, "false");
		String recupPrefDisplay_allTab = prefs.getValue(WebController.PREF_TAB_ALL, "false");
		String viewMode = ALL_VIEW;
		boolean roViewMode = true;
		
		if ((recupPrefDisplay_anyTab.equalsIgnoreCase("false"))&& (recupPrefDisplay_allTab.equalsIgnoreCase("false"))){
			viewMode = MINE_VIEW;
		}
		if(recupPrefDisplay_anyTab.equalsIgnoreCase("true")){
			viewMode = ANY_VIEW;
		}
		model.put("viewMode", viewMode);
		
		
		if ((prefs.isReadOnly(WebController.PREF_TAB_ANY))||(prefs.isReadOnly(WebController.PREF_TAB_ALL))){
			roViewMode=false;
		}
		
		model.put("roViewMode", roViewMode);
		
		return new ModelAndView("edit-portlet", model);
    }

    @RequestMapping(value = {"EDIT"}, params = {"action=updatePreferences"})
	public void updatePreferences(ActionRequest request, ActionResponse response, 
			@RequestParam(required=false) String viewMode) throws Exception {
    	
    	final PortletPreferences prefs = request.getPreferences();
    	if(!viewMode.equalsIgnoreCase("disable")){
	    	if(viewMode.equalsIgnoreCase(MINE_VIEW)){
	    		prefs.setValue(WebController.PREF_TAB_ANY, "false");
	    		prefs.setValue(WebController.PREF_TAB_ALL, "false");    		
	    	}
	    	if(viewMode.equalsIgnoreCase(ANY_VIEW)){
	    		prefs.setValue(WebController.PREF_TAB_ANY, "true");
	    		prefs.setValue(WebController.PREF_TAB_ALL, "false");     		
	    	}
	    	if(viewMode.equalsIgnoreCase(ALL_VIEW)){
	    		prefs.setValue(WebController.PREF_TAB_ANY, "false");
	    		prefs.setValue(WebController.PREF_TAB_ALL, "true");     		
	    	}    	
	    	prefs.store();	
    	}

    	response.setPortletMode(PortletMode.VIEW);
	}
}