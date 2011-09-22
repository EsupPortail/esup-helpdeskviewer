/**
 * ESUP-Portail Blank Application - Copyright (c) 2010 ESUP-Portail consortium.
 */
package org.esupportail.helpdeskviewer.domain;

import java.net.MalformedURLException;
import java.net.URL;

import org.esupportail.commons.exceptions.EsupException;
import org.esupportail.commons.services.logging.Logger;
import org.esupportail.commons.services.logging.LoggerImpl;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Service;

import org.esupportail.helpdesk.services.remote.ArrayOfSimpleTicketView;
import org.esupportail.helpdesk.services.remote.ArrayOfString;
import org.esupportail.helpdesk.services.remote.Helpdesk;
import org.esupportail.helpdesk.services.remote.HelpdeskPortType;

@Service("domainService")
public class DomainServiceImpl implements DomainService, InitializingBean {

	/**
	 * For Serialize.
	 */
	private static final long serialVersionUID = 5562208937407153456L;

	/**
	 * For Logging.
	 */
	private final Logger logger = new LoggerImpl(this.getClass());

	@Override
	public void afterPropertiesSet() throws Exception {
		// TODO Auto-generated method stub
	}

	@Override
	public ArrayOfSimpleTicketView getLastTickets(String wsdlLocation,
			String uid, int maxTickets, String selectedTicketFilterId,
			boolean userViewBool) {
		HelpdeskPortType helpdesk = getHelpdeskWS(wsdlLocation);
		return helpdesk.getLastTickets(uid, maxTickets, selectedTicketFilterId, userViewBool);
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
		HelpdeskPortType helpdesk;
		try {
			helpdesk = new Helpdesk(new URL(wsdlLocation)).getHelpdeskHttpPort();
		} catch (MalformedURLException e) {
			throw new EsupException("pb retieving ws from " + wsdlLocation, e) {
			};
		}
		return helpdesk;
	}

}
