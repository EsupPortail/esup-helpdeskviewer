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

package org.esupportail.helpdeskviewer.domain;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.apache.cxf.endpoint.Client;
import org.apache.cxf.frontend.ClientProxy;



import org.apache.log4j.Logger;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Service;
import org.esupportail.helpdesk.services.remote.ArrayOfSimpleTicketView;
import org.esupportail.helpdesk.services.remote.ArrayOfString;
import org.esupportail.helpdesk.services.remote.Helpdesk;
import org.esupportail.helpdesk.services.remote.HelpdeskPortType;
import org.esupportail.helpdeskviewer.ws.EsupResponseHandleInterceptor;


@Service("domainService")
public class DomainServiceImpl implements DomainService, InitializingBean {

	private static final long serialVersionUID = 5562208937407153456L;

	private final Logger logger = Logger.getLogger(this.getClass());
	
	Map<String, HelpdeskPortType> helpdesks = new HashMap<String, HelpdeskPortType>();
	
	@Override
	public void afterPropertiesSet() throws Exception {
		// TODO Auto-generated method stub
	}

	@Override
	public ArrayOfSimpleTicketView getLastTickets(String wsdlLocation,
			String uid, int maxTickets, String selectedTicketFilterId,
			boolean userViewBool) {
		HelpdeskPortType helpdesk = getHelpdeskWS(wsdlLocation);
		logger.debug("Call of WS : helpdesk.getLastTickets(" +
				uid + ", " +   
				maxTickets + ", " +
				selectedTicketFilterId + ", " +
				userViewBool + ")" );
		ArrayOfSimpleTicketView tickets = helpdesk.getLastTickets(uid, maxTickets, selectedTicketFilterId, userViewBool);
		logger.debug("Retrieved " +  tickets.getSimpleTicketView().size() + " tickets");
		return tickets;
	}

	@Override
	public ArrayOfString getInvolvementFilters(String wsdlLocation, boolean userViewBool) {
		HelpdeskPortType helpdesk = getHelpdeskWS(wsdlLocation);
		if (userViewBool)
			return helpdesk.getUserInvolvementFilters();
		else
			return helpdesk.getManagerInvolvementFilters();
	}

	protected HelpdeskPortType getHelpdeskWS(String wsdlLocation) {
		HelpdeskPortType helpdesk = helpdesks.get(wsdlLocation);
		if(helpdesk == null) {
			try {
				helpdesk = new Helpdesk(new URL(wsdlLocation)).getHelpdeskHttpPort();
				
				Client cxfClient = ClientProxy.getClient(helpdesk);
				cxfClient.getInInterceptors().add(new EsupResponseHandleInterceptor());
				
				helpdesks.put(wsdlLocation, helpdesk);
				logger.info("HelpdeskPortType with wsdlLocation[" + wsdlLocation + "] is created" );
			} catch (MalformedURLException e) {
				logger.info("pb retieving ws from " + wsdlLocation, e);
			}
		}
		return helpdesk;
	}
	@Override
	public boolean isDepartmentManager (String wsdlLocation, String uid){
		HelpdeskPortType helpdesk = getHelpdeskWS(wsdlLocation);
		return helpdesk.isDepartmentManager(uid);
	}
	
	@Override
	public String getVersion(String wsdlLocation){
		HelpdeskPortType helpdesk = helpdesks.get(wsdlLocation);
		return helpdesk.getVersion();
	}

}
