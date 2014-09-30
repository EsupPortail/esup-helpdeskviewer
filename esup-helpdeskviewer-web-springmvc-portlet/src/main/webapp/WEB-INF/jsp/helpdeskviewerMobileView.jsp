<%--

    Copyright (C) 2011-2012 Esup Portail http://www.esup-portail.org
    Copyright (C) 2011-2012 UNR RUNN http://www.unr-runn.fr
    @Author (C) 2011-2012 Jean-Pierre Tran <Jean-Pierre.Tran@univ-rouen.fr>
    @Contributor (C) 2011-2012 Vincent Bonamy <Vincent.Bonamy@univ-rouen.fr>

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

<%@ include file="/WEB-INF/jsp/include.jsp"%>

<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/css/jquery.mobile.structure-1.1.1.min.css" media="screen, projection"/>
<%-- 
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-1.8.1.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.mobile-1.1.1.min.js"></script>
<link rel="stylesheet"  type="text/css" href="<%=request.getContextPath()%>/css/mhelpdeskviewer.css"/>
--%>

<fmt:setLocale value="${messageFile}" />
<c:choose>
	<c:when test="${target eq 'null'}"> 
	  <c:set var="targetValue"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="targetValue">target='${target}'</c:set>
	</c:otherwise>
</c:choose>
<div  class="esup-helpdeskviewer" >
  <div data-role="content">
	<div data-role="navbar" class="ui-body-a">
	   <ul>
	   	<li><a href="${urlHelpdesk}" target="_blank" data-icon="home"><spring:message code="link.home"/></a></li>
        <c:if test="${isManagerViewAble eq 'true'}"> 
  			<portlet:actionURL var="modifyUserViewUrl">
  				<portlet:param name="action" value="modifyUserView"/>
  				<portlet:param name="userView" value="user"/>
			<portlet:param name="filter" value="${defaultFilterUser}"/>
  			</portlet:actionURL>
  			<li><a ${ (userView eq 'user') ? "class='bold'" : ''} href="${modifyUserViewUrl}"   data-icon="helpdesk-user">
             <spring:message code="view.user"/></a></li>
  		 	<portlet:actionURL var="modifyUserViewUrl">
  		 		<portlet:param name="action" value="modifyUserView"/>
  		 		<portlet:param name="userView" value="manager"/>
		    <portlet:param name="filter" value="${defaultFilterManager}"/>
  		 	</portlet:actionURL>
   			<li><a ${ (userView eq 'manager') ? "class='bold'" : ''} href="${modifyUserViewUrl}"    data-icon="helpdesk-manager">
           	  <spring:message code="view.manager"/></a></li>       	             
  	   </c:if>  
  	  </ul>
 	</div>	 
 	 	   
     <portlet:actionURL var="modifyUserViewUrl">
     <portlet:param name="action" value="modifyUserView" />
     <portlet:param name="userView" value="${userView}" />
        </portlet:actionURL>
	 <form action="${modifyUserViewUrl}" method="POST">
		<select name="filter" onchange="javascript:this.form.submit();" data-mini="true" data-theme="b" >
			<c:forEach var="filterItem" items="${tabTickets}">
			  <c:set var="selected" value="" />
                   <c:if test="${filterItem == filter}">
                       <c:set var="selected" value='selected="selected"' />
                   </c:if>
                   <option value="${filterItem}" ${selected} /><spring:message code="tab.${fn:toLowerCase(filterItem)}"/></option>  
			</c:forEach>
		<select>
		<input type="submit" value="<spring:message code="form.submit" />" data-role="none"/>
	 </form>     	
			 	
	<div data-role="collapsible" data-collapsed="false" data-theme="b" data-content-theme="c">
		<c:choose>
			<c:when test="${noTicketsMsg eq '1'}">
				<a href="${urlHelpdesk}" target="_blank"  data-role="button" data-mini="true" data-icon="alert" data-theme="e" class="alert"><spring:message code="view.noticket"/></a>
			</c:when>
			<c:otherwise>
				<c:forEach var="ticket" items="${tickets}">
				 <c:set var="className">${ticket.viewed.value eq 'false' ? 'helpdeskviewer-read-ticket' : 'helpdeskviewer-unread-ticket'}</c:set> 
				  <div data-role="collapsible"> 
				  	<h3 class="${className}">${ticket.label.value}</h3>	
					<ul id="details-tickets">
						<li><a target="blank" href='${ticket.deepLink.value}' data-role="button" data-mini="true" data-inline="true" data-icon="forward"><spring:message code="link.see" /></a></li>
						<li><span><spring:message code="tab.thead.category" />
								:</span> ${ticket.category.value}</li>
						<li><span><spring:message code="tab.thead.department" />
								:</span> ${ticket.department.value}</li>
						<li><span><spring:message code="tab.thead.creation" />
								:</span> <c:set var="date"
								value="${fn:split(ticket.creation.value, ' ')}" /> <c:out
								value="${date[0]} ${date[1]} ${date[2]}" /> <c:set var="hour"
								value="${fn:split(date[3], ':')}" /> <c:out
								value="${hour[0]}:${hour[1]}" />
						</li>
						<li><span><spring:message code="tab.thead.status" />
								:</span>
								<spring:message code="ticket.status.${fn:toLowerCase(ticket.status.value)}" />
						</li>
						<li><span><spring:message code="tab.thead.owner" />
								:</span> ${ticket.owner.value}</li>
						<div data-role="collapsible">
			            	<c:set var="msgs" value="${ticket.actions.value.simpleActionView}"/>
							<c:set var="msgsLength" value="${fn:length(msgs)}"/>
							<c:set var="totalCount"  value="0"/>
							<c:forEach items="${msgs}" varStatus="status">					
								<c:if test="${msgs[msgsLength - status.count].message.nil  eq false }">
									<c:set var="lastComment"  value="${msgs[msgsLength - status.count].message.value}"/>						           
							        <c:set var="totalCount" value="${totalCount + 1}" />						           
								</c:if>
								
								<c:if test="${totalCount <= maxComments and  msgs[msgsLength - status.count].message.nil  eq false}">
								<c:choose>
									<c:when test="${totalCount == 1}" >
										<h3><spring:message code="ticket.lastMessage"/>: </h3>
									</c:when>
									<c:otherwise>
										<hr /><br />
									</c:otherwise>
								</c:choose>
									${lastComment}
								</c:if>
							</c:forEach>  				 
			              	<p><a target="blank" href='${ticket.deepLink.value}' data-role="button" data-mini="true" data-inline="true" data-icon="forward"><spring:message code="ticket.see" /></a></p>
						</div>		
					  </div>					
					</ul>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
  </div>
</div>

