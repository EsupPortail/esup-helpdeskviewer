<%--

    Copyright (C) 2011 Esup Portail http://www.esup-portail.org
    Copyright (C) 2011 UNR RUNN http://www.unr-runn.fr
    @Author (C) 2011 Jean-Pierre Tran <Jean-Pierre.Tran@univ-rouen.fr>
    @Contributor (C) 2011 Vincent Bonamy <Vincent.Bonamy@univ-rouen.fr>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
            http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

--%>

<%@ include file="/WEB-INF/jsp/include.jsp" %>

<%--
<link rel="stylesheet"  type="text/css" href="<%=request.getContextPath()%>/css/helpdeskviewer.css"/>
--%>
<c:choose>
	<c:when test="${target eq 'null'}"> 
	  <c:set var="targetValue"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="targetValue">target='${target}'</c:set>
	</c:otherwise>
</c:choose>
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
					<c:choose>
						<c:when test="${(display_anyTab eq 'false') and (display_allTab eq 'false')}">	
						  <portlet:param name="filter" value="OWNER"/>
						</c:when>
						<c:otherwise> 
						  <portlet:param name="filter" value="ANY"/>
						</c:otherwise>
					</c:choose>
	   			</portlet:actionURL>
	   			<a ${ (userView eq 'user') ? "class='bold'" : ''} href="${modifyUserViewUrl}">
	              <spring:message code="view.user"/></a><span>/</span>
	         </li>
	   		 <li>
	   		 	<portlet:actionURL var="modifyUserViewUrl">
	   		 		<portlet:param name="action" value="modifyUserView"/>
	   		 		<portlet:param name="userView" value="manager"/>
					<c:choose>
						<c:when test="${(display_anyTab eq 'false') and (display_allTab eq 'false')}">	
						  <portlet:param name="filter" value="MANAGED"/>
						</c:when>
						<c:otherwise> 
						  <portlet:param name="filter" value="ANY"/>
						</c:otherwise>
					</c:choose>
	   		 	</portlet:actionURL>
	    		<img src="<%=request.getContextPath()%>/images/manager.png" />
	    		<a ${ (userView eq 'manager') ? "class='bold'" : ''} href="${modifyUserViewUrl}">
	            <spring:message code="view.manager"/></a>
	         </li>
 	  </c:if>  
	  		<li id="home" >
	  			<img src="<%=request.getContextPath()%>/images/welcome.png" />
	  			<a ${targetValue} href="${linkHome}"><spring:message code="link.home"/></a><span>|</span>
	  		</li>
	  		<li>
	  			<img src="<%=request.getContextPath()%>/images/add.png" />
	  			<a ${targetValue} href="${linkAddTicket}"><spring:message code="link.question"/></a><span>|</span>
	  		</li>
	  		<li>
	  			<img src="<%=request.getContextPath()%>/images/faq-container.png" />
	  			<a ${targetValue} href="${linkFaq}"><spring:message code="link.faq"/></a>
	  		</li>  	
	  	</ul>
	</div>  
	<%--  Tab list of available tickets views --%>

  <div class="helpdeskviewer-messages">
      <ul class="fl-tabs fl-tabs-left">
        <c:forEach var="filterItem" items="${filters}">
		  <c:choose>
		  <c:when test="${(display_anyTab eq 'true') and (display_allTab eq 'false')}">	 
		  	 <c:if test="${(filterItem eq 'ANY') || (filterItem eq 'OWNER')||(filterItem eq 'MANAGED')}"> 
			 <li class=${ (filterItem eq filter) ? 'fl-activeTab' : ''}>
		          <portlet:actionURL var="modifyUserViewUrl">
		          	<portlet:param name="action" value="modifyUserView"/>
		          	<portlet:param name="userView" value="${userView}"/>   
		            <portlet:param name="filter" value="${filterItem}"/>         
		          </portlet:actionURL>
		          <a href="${modifyUserViewUrl}"><spring:message code="tab.${fn:toLowerCase(filterItem)}"/></a>
		      </li>
		     </c:if>
		  </c:when>
		  <c:when test="${display_allTab eq 'true'}">	 
			 <li class=${ (filterItem eq filter) ? 'fl-activeTab' : ''}>
		          <portlet:actionURL var="modifyUserViewUrl">
		          	<portlet:param name="action" value="modifyUserView"/>
		          	<portlet:param name="userView" value="${userView}"/>   
		            <portlet:param name="filter" value="${filterItem}"/>         
		          </portlet:actionURL>
		          <a href="${modifyUserViewUrl}">
		            <spring:message code="tab.${fn:toLowerCase(filterItem)}"/>
		          </a>
		      </li>
		  </c:when>
		  <c:otherwise>    
		  	  <c:if test="${(filterItem eq 'OWNER')||(filterItem eq 'MANAGED')}"> 
		          <li class="fl-activeTab">
		          <portlet:actionURL var="modifyUserViewUrl">
		          	<portlet:param name="action" value="modifyUserView"/>
		          	<portlet:param name="userView" value="${userView}"/>   
		            <portlet:param name="filter" value="${filterItem}"/>         
		          </portlet:actionURL>
		          <a href="${modifyUserViewUrl}"><spring:message code="tab.${fn:toLowerCase(filterItem)}"/></a>
		        </li>
		      </c:if>
		  </c:otherwise>
		</c:choose>
      </c:forEach>
    </ul>
  </div>
  <c:choose>
  <c:when test="${noTicketsMsg eq '1'}">
		<p class="alarm"><a href="${urlHelpdesk}" ${targetValue}>${helpdeskMessage}</a></p>
  </c:when>
  <c:otherwise>
  <div class="fl-tab-content" role="tabpanel">
    <table class="helpdeskviewer-messages-table">
      <tbody>
	      <thead>
	        <tr>
	         <th><spring:message code="tab.thead.subject"/></th>
	         <th><spring:message code="tab.thead.category"/></th>
	         <th><spring:message code="tab.thead.department"/></th>
	         <th><spring:message code="tab.thead.creation"/></th>
	         <th><spring:message code="tab.thead.status"/></th>
	         <th><spring:message code="tab.thead.owner"/></th>
	        </tr>
	      </thead>
	        <c:forEach var="ticket" items="${tickets}" varStatus="counter">
	        <c:set var="className">${ (counter.index % 2 == 0) ? 'portlet-section-body' : 'portlet-section-alternate'} ${ticket.viewed.value eq 'false' ? 'helpdeskviewer-read-ticket' : 'helpdeskviewer-unread-ticket'}</c:set>         
	          <tr class="${className} helpdeskviewer-messages-table-cell-flags">
	            <td>
	              <a ${targetValue} href='${ticket.deepLink.value}' >
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
	                <spring:message code="ticket.status.${fn:toLowerCase(ticket.status.value)}"/>
	            </td>
	            <td>
	              ${ticket.owner.value}
	            </td>
	          </tr>
	        </c:forEach>	    
      </tbody>
    </table>
  </div>
 
    </c:otherwise>
  </c:choose>
</div>
</div>
