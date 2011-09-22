<%@ include file="/WEB-INF/jsp/include.jsp" %>

<%--
<link rel="stylesheet"  type="text/css" href="<%=request.getContextPath()%>/css/helpdeskviewer.css"/>
--%>
 
<div class="portlet-section">
  <div class="portlet-section-body">
  	<div class="helpdeskviewer-menu">
  	 <ul>
	    <li><img src="<%=request.getContextPath()%>/images/user.png" /><a ${ (userViewBool eq 'true') ? "class='bold'" : ''} href="<portlet:renderURL portletMode="view"><portlet:param name="userView" value="True"/></portlet:renderURL>">
	              <spring:message code="view.userview.user"/></a><span>/</span></li>
	    <li><img src="<%=request.getContextPath()%>/images/manager.png" /><a ${ (userViewBool eq 'false') ? "class='bold'" : ''} href="<portlet:renderURL portletMode="view"><portlet:param name="userView" value="False"/><portlet:param name="selectedTicketFilter" value="ANY"/></portlet:renderURL>">
	              <spring:message code="view.userview.manager"/></a></li>
 	  	
	  		<li id="home"><img src="<%=request.getContextPath()%>/images/welcome.png" /><a target='blank' href="${linkHome}"><spring:message code="view.link.home"/></a><span>|</span></li>
	  		<li><img src="<%=request.getContextPath()%>/images/add.png" /><a target='blank' href="${linkAddTicket}"><spring:message code="view.link.question"/></a><span>|</span></li>
	  		<li><img src="<%=request.getContextPath()%>/images/faq-container.png" /><a target='blank' href="${linkFaq}"><spring:message code="view.link.faq"/></a></li>  	
	  	</ul>
	</div>  
	<%--  Tab list of available tickets views --%>
    <div class="fl-container-flex">
      <ul role="tablist" class="fl-tabs fl-tabs-left">
        <c:forEach var="filter" items="${filters}">
          <li role="tab" class=${ (filter eq selectedTicketFilterId) ? 'fl-activeTab' : ''}>
          <portlet:renderURL var="viewSelectedTicket" portletMode="VIEW">
            <portlet:param name="selectedTicketFilter" value="${filter}"/>   
            <portlet:param name="userView" value="${userViewBool}"/> 
          </portlet:renderURL>
          <a href="${viewSelectedTicket}">
            <spring:message code="view.tab.${fn:toLowerCase(filter)}"/>
          </a>
        </li>
      </c:forEach>
    </ul>
  </div>
  <c:choose>
  <c:when test="${noTicketsMsg eq '1'}">
		<p class="alarm"><spring:message code="view.ticket.message.alarm"/> => <a href="${urlHelpdesk}" target="_blank"><spring:message code="view.ticket.message.url"/></a></p>
  </c:when>
  <c:otherwise>
  <div class="fl-tab-content" role="tabpanel">
  <div class="helpdeskviewer-messages">
    <table class="helpdeskviewer-messages-table">
      <tbody>
	      <thead>
	        <tr>
	         <th><spring:message code="view.thead.subject"/></th>
	         <th><spring:message code="view.thead.category"/></th>
	         <th><spring:message code="view.thead.department"/></th>
	         <th><spring:message code="view.thead.creation"/></th>
	         <th><spring:message code="view.thead.status"/></th>
	         <th><spring:message code="view.thead.owner"/></th>
	        </tr>
	      </thead>
	        <c:forEach var="ticket" items="${tickets}" varStatus="counter">
	        <c:set var="className">${ (counter.index % 2 == 0) ? 'portlet-section-body' : 'portlet-section-alternate'} ${ticket.viewed.value eq 'false' ? 'helpdeskviewer-read-ticket' : 'helpdeskviewer-unread-ticket'}</c:set>         
	          <tr class="${className} helpdeskviewer-messages-table-cell-flags">
	            <td>
	              <a target='blank' href='${ticket.deepLink.value}'>
	                ${ticket.label.value}
	             </a>
	            </td>
	            <td>
	              ${ticket.category.value}
	            </td>
	            <td>
	              ${ticket.department.value}
	            </td>
	            <td>
	             <c:set var="date" value="${fn:split(ticket.creation.value, ' ')}" />   	                               
          		  <c:out  value="${date[0]} ${date[1]} ${date[2]}" />
	             <c:set var="hour" value="${fn:split(date[3], ':')}" /> 
	               <c:out  value="${hour[0]}:${hour[1]}" />
	            </td>	            
	            <td>
	              <!-- traduction -->
	              <c:choose>
	                <c:when test="${ticket.status.value=='FREE'}">
	                  <spring:message code="view.ticket.status.free"/>
	                </c:when>
	                <c:when test="${ticket.status.value=='CANCELLED'}">
	                  <spring:message code="view.ticket.status.cancelled"/>
	                </c:when>
	                <c:when test="${ticket.status.value=='INCOMPLETE'}">
	                  <spring:message code="view.ticket.status.incomplete"/>
	                </c:when>
	                <c:when test="${ticket.status.value=='POSTPONED'}">
	                  <spring:message code="view.ticket.status.postponed"/>
	                </c:when>
	                <c:when test="${ticket.status.value=='INPROGRESS'}">
	                  <spring:message code="view.ticket.status.inprogress"/>
	                </c:when>
	                <c:when test="${ticket.status.value=='APPROVED'}">
	                  <spring:message code="view.ticket.status.approved"/>
	                </c:when>
	                <c:when test="${ticket.status.value=='CLOSED'}">
	                  <spring:message code="view.ticket.status.closed"/>
	                </c:when>
	                <c:when test="${ticket.status.value=='EXPIRED'}">
	                  <spring:message code="view.ticket.status.expired"/>
	                </c:when>
	                <c:when test="${ticket.status.value=='REFUSED'}">
	                  <spring:message code="view.ticket.status.refused"/>
	                </c:when>
	              </c:choose>
	            </td>
	            <td>
	              ${ticket.owner.value}
	            </td>
	          </tr>
	        </c:forEach>	    
      </tbody>
    </table>
  </div>
  </div>
    </c:otherwise>
  </c:choose>
</div>
</div>
