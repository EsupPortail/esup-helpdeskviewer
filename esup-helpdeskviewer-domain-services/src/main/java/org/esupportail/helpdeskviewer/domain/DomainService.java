/**
 * ESUP-Portail Blank Application - Copyright (c) 2010 ESUP-Portail consortium.
 */
package org.esupportail.helpdeskviewer.domain;

import java.io.Serializable;

import org.esupportail.helpdesk.services.remote.ArrayOfSimpleTicketView;
import org.esupportail.helpdesk.services.remote.ArrayOfString;


public interface DomainService extends Serializable {

	ArrayOfSimpleTicketView getLastTickets(String wsdlLocation, String uid,
			int maxTickets, String selectedTicketFilterId,
			boolean userViewBool);
	
	ArrayOfString getInvolvementFilters(String wsdlLocation, boolean userViewBool);

}
