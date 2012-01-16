/**
 * Copyright (C) 2011-2012 Esup Portail http://www.esup-portail.org
 * Copyright (C) 2011-2012 UNR RUNN http://www.unr-runn.fr
 * @Author (C) 2011-2012 Jean-Pierre Tran <Jean-Pierre.Tran@univ-rouen.fr>
 * @Contributor (C) 2011-2012 Vincent Bonamy <Vincent.Bonamy@univ-rouen.fr>
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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

import javax.annotation.Resource;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletMode;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletSession;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.apache.log4j.Logger;
import org.esupportail.helpdesk.services.remote.ArrayOfString;
import org.esupportail.helpdeskviewer.domain.DomainService;
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
	protected @Resource
	DomainService domainService;
	
    @RequestMapping("EDIT")
	public ModelAndView renderEditView(RenderRequest request, RenderResponse response) throws Exception {
        	
		ModelMap model = new ModelMap();
		final PortletPreferences prefs = request.getPreferences();
		String []recupPrefDisplay_userTabs = prefs.getValues(WebController.PREF_TAB_USER, null);
		String []recupPrefDisplay_managerTabs = prefs.getValues(WebController.PREF_TAB_MANAGER, null);
		String messageFile = prefs.getValue(WebController.PREF_MESSAGE_FILE, "_fr");
		
		ArrayOfString managerFilters = domainService.getInvolvementFilters((prefs.getValue(WebController.PREF_WSDL_LOCATION, null)), false);
		ArrayOfString userFilters = domainService.getInvolvementFilters((prefs.getValue(WebController.PREF_WSDL_LOCATION, null)), true);
		
		ArrayList<String> userTabPrefs = new ArrayList<String>();	
		ArrayList<String> managerTabPrefs = new ArrayList<String>();
		int i=0;
		for (String userFilter : userFilters.getString()){
				if(Arrays.asList(recupPrefDisplay_userTabs).contains(userFilter.toLowerCase())){
					i++;
					userTabPrefs.add(String.valueOf(i).concat(".").concat(userFilter).toLowerCase());					
				}
				else{
					userTabPrefs.add(userFilter.toLowerCase());				
				}			
		}
		Collections.sort(userTabPrefs);
		i=0;
		for (String managerFilter : managerFilters.getString()){			
			if(Arrays.asList(recupPrefDisplay_managerTabs).contains(managerFilter.toLowerCase())){
				i++;
				managerTabPrefs.add(String.valueOf(i).concat(".").concat(managerFilter).toLowerCase());					
			}
			else{
				managerTabPrefs.add(managerFilter.toLowerCase());				
			}
		}
		Collections.sort(managerTabPrefs);
		boolean userViewMode = true;
		boolean managerViewMode = false;
		String isManagerViewAble="false";
		if (prefs.isReadOnly(WebController.PREF_TAB_USER)){
			userViewMode=false;
		}
		PortletSession session = request.getPortletSession();
		if (session!=null){
			isManagerViewAble=session.getAttribute("isManagerViewAble").toString();
		}
		if ((isManagerViewAble.equalsIgnoreCase("true"))&&(!prefs.isReadOnly(WebController.PREF_TAB_MANAGER))){	
			managerViewMode=true;			
		}
		
		model.put("messageFile",messageFile);
		model.put("managerTabPrefs",managerTabPrefs);
		model.put("userTabPrefs",userTabPrefs);
		model.put("userViewMode", userViewMode);
		model.put("managerViewMode", managerViewMode);		
		model.put("isManagerViewAble", isManagerViewAble);
		return new ModelAndView("edit-portlet", model);
    }

    @RequestMapping(value = {"EDIT"}, params = {"action=updatePreferences"})
	public void updatePreferences(ActionRequest request, ActionResponse response, 
			@RequestParam(value = "viewUserBox", required = false) String[] viewUserBox,
			@RequestParam(value = "viewManagerBox", required = false) String[] viewManagerBox,
			@RequestParam(value = "userViewMode", required = false) String userViewMode,
			@RequestParam(value = "managerViewMode", required = false) String managerViewMode) throws Exception {
    	
    	final PortletPreferences prefs = request.getPreferences();
    	
    	if(userViewMode.equalsIgnoreCase("enable")){  		
    		if(viewUserBox==null) {
    			String[] defUserValues = {"owner"};
    			prefs.setValues(WebController.PREF_TAB_USER, defUserValues);
    		}
    		else{
    			prefs.setValues(WebController.PREF_TAB_USER, viewUserBox);
    		}
    		prefs.store();
    	}
    	if(managerViewMode.equalsIgnoreCase("enable")){ 
    		if(viewManagerBox==null) {
    			String[] defManagerValues = {"managed"};
    			prefs.setValues(WebController.PREF_TAB_MANAGER, defManagerValues);
    		}   		
    		else{    	
		    	prefs.setValues(WebController.PREF_TAB_MANAGER, viewManagerBox);
    		}
    		prefs.store(); 	
    	} 	
    	response.setPortletMode(PortletMode.VIEW);
	}
}