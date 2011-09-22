<%@ include file="/WEB-INF/jsp/include.jsp" %>

<%--
<link rel="stylesheet"  type="text/css" href="<%=request.getContextPath()%>/css/mhelpdeskviewer.css"/>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-1.4.2.js"/>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/helpdeskviewer.js"/>
--%>

  <div class="helpdeskviewer-messages-mobile"> 
  <div id="nsHvrUserview">
    <a ${ (userViewBool eq 'true') ? "class='bold'" : ''} href="<portlet:renderURL portletMode="view"><portlet:param name="userView" value="True"/><portlet:param name="selectedTicketFilter" value="ANY"/></portlet:renderURL>">
              <img src="<%=request.getContextPath()%>/images/user.png" /> <spring:message code="view.userview.user"/></a> /
    <a ${ (userViewBool eq 'false') ? "class='bold'" : ''} href="<portlet:renderURL portletMode="view"><portlet:param name="userView" value="False"/><portlet:param name="selectedTicketFilter" value="ANY"/></portlet:renderURL>">
              <img src="<%=request.getContextPath()%>/images/manager.png" /> <spring:message code="view.userview.manager"/></a>
  </div>
  <div id="helpdeskviewer-main">
  	<c:forEach var="filter" items="${filters}">
 	<h3 class="trigger">
   		<portlet:renderURL var="viewSelectedTicket" portletMode="VIEW">
			<portlet:param name="selectedTicketFilter" value="${filter}"/>   
			<portlet:param name="userView" value="${userViewBool}"/> 
  		</portlet:renderURL> 	 
  		<a  ${ (filter eq selectedTicketFilterId) ? "class='focus'" : ''} href="${viewSelectedTicket}">
            <spring:message code="view.tab.${fn:toLowerCase(filter)}"/>
        </a>
    </h3>

	<c:if test="${filter eq selectedTicketFilterId}">
	  <c:choose>
	  		<c:when test="${noTicketsMsg eq '1'}">
				<p class="alarm"><spring:message code="view.ticket.message.alarm"/><br />
				<a href="${urlHelpdesk}" target="_blank"> => <spring:message code="view.ticket.message.url"/></a></p>
	  		</c:when>
	   <c:otherwise>     
         <c:forEach var="ticket" items="${tickets}">	
           <ul>  	
			 <li><span><spring:message code="view.thead.subject"/> :</span> <a class="helpdeskLink" target='blank' href='${ticket.deepLink.value}'>${ticket.label.value}</a></li>
			 <li><span><spring:message code="view.thead.category"/> :</span> ${ticket.category.value}</li>
			 <li><span><spring:message code="view.thead.department"/> :</span> ${ticket.department.value}</li>
			 <li><span><spring:message code="view.thead.creation"/> :</span>
				 <c:set var="date" value="${fn:split(ticket.creation.value, ' ')}" />   	                               
				 <c:out  value="${date[0]} ${date[1]} ${date[2]}" />
				 <c:set var="hour" value="${fn:split(date[3], ':')}" /> 
				 <c:out  value="${hour[0]}:${hour[1]}" /></li>
			 <li><span><spring:message code="view.thead.status"/> :</span>
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
			 </li>
			 <li><span><spring:message code="view.thead.owner"/> :</span> ${ticket.owner.value}</li>
	      </ul>		 
		 </c:forEach>
	   </c:otherwise>
	  </c:choose>
	</c:if>
   
  </c:forEach>
  </div>
  </div>

