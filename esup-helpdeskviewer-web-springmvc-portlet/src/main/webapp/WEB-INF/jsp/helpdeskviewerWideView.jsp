<%@ include file="/WEB-INF/jsp/include.jsp" %>

<%--
<link rel="stylesheet"  type="text/css" href="<%=request.getContextPath()%>/css/helpdeskviewer.css"/>
--%>
 
<div class="portlet-section">
  <div class="portlet-section-body">
  	<div class="helpdeskviewer-menu">
  	 <ul>
          <c:if test="${isManagerViewAble eq 'true'}">
	   		 <li>
	   			<img src="<%=request.getContextPath()%>/images/user.png" />
	   			<portlet:actionURL var="modifyUserViewUrl">
	   				<portlet:param name="action" value="modifyUserView"/>
	   				<portlet:param name="userView" value="user"/>
	   				<portlet:param name="filter" value="ANY"/>
	   			</portlet:actionURL>
	   			<a ${ (userView eq 'user') ? "class='bold'" : ''} href="${modifyUserViewUrl}">
	              <spring:message code="view.userview.user"/></a><span>/</span>
	         </li>
	   		 <li>
	   		 	<portlet:actionURL var="modifyUserViewUrl">
	   		 		<portlet:param name="action" value="modifyUserView"/>
	   		 		<portlet:param name="userView" value="manager"/>
	   		 		<portlet:param name="filter" value="ANY"/>
	   		 	</portlet:actionURL>
	    		<img src="<%=request.getContextPath()%>/images/manager.png" />
	    		<a ${ (userView eq 'manager') ? "class='bold'" : ''} href="${modifyUserViewUrl}">
	            <spring:message code="view.userview.manager"/></a>
	         </li>
 	  </c:if>
	  		<li id="home">
	  			<img src="<%=request.getContextPath()%>/images/welcome.png" />
	  			<a target='blank' href="${linkHome}"><spring:message code="view.link.home"/></a><span>|</span>
	  		</li>
	  		<li>
	  			<img src="<%=request.getContextPath()%>/images/add.png" />
	  			<a target='blank' href="${linkAddTicket}"><spring:message code="view.link.question"/></a><span>|</span>
	  		</li>
	  		<li>
	  			<img src="<%=request.getContextPath()%>/images/faq-container.png" />
	  			<a target='blank' href="${linkFaq}"><spring:message code="view.link.faq"/></a>
	  		</li>  	
	  	</ul>
	</div>  
	<%--  Tab list of available tickets views --%>
    <div class="fl-container-flex">
      <ul role="tablist" class="fl-tabs fl-tabs-left">
        <c:forEach var="filterItem" items="${filters}">
          <li role="tab" class=${ (filterItem eq filter) ? 'fl-activeTab' : ''}>
          <portlet:actionURL var="modifyUserViewUrl">
          	<portlet:param name="action" value="modifyUserView"/>
          	<portlet:param name="userView" value="${userView}"/>   
            <portlet:param name="filter" value="${filterItem}"/>         
          </portlet:actionURL>
          <a href="${modifyUserViewUrl}">
            <spring:message code="view.tab.${fn:toLowerCase(filterItem)}"/>
          </a>
        </li>
      </c:forEach>
    </ul>
  </div>
  <c:choose>
  <c:when test="${noTicketsMsg eq '1'}">
		<p class="alarm">
			<spring:message code="view.ticket.message.alarm"/> => 
			<a href="${urlHelpdesk}" target="_blank"><spring:message code="view.ticket.message.url"/></a>
		</p>
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
	                <spring:message code="view.ticket.status.${fn:toLowerCase(ticket.status.value)}"/>
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
