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

<%@ include file="/WEB-INF/jsp/include.jsp"%>

<%--
<link rel="stylesheet"  type="text/css" href="<%=request.getContextPath()%>/css/mhelpdeskviewer.css"/>
--%>
<c:choose>
	<c:when test="${target eq 'null'}"> 
	  <c:set var="targetValue"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="targetValue">target='${target}'</c:set>
	</c:otherwise>
</c:choose>
<div class="helpdeskviewer-messages-mobile">
	<div class="helpdeskviewer-menu">
		<c:if test="${isManagerViewAble eq 'true'}">
			<ul>
				<li><img src="<%=request.getContextPath()%>/images/user.png" />
					<portlet:actionURL var="modifyUserViewUrl">
						<portlet:param name="action" value="modifyUserView" />
						<portlet:param name="userView" value="user" />
						<portlet:param name="filter" value="ANY" />
					</portlet:actionURL> <a ${ (userView eq 'user') ? "class='bold'
					" : ''} href="${modifyUserViewUrl}"> <spring:message
							code="view.userview.user" /> </a><span>/</span>
				</li>
				<li><img src="<%=request.getContextPath()%>/images/manager.png" />
					<portlet:actionURL var="modifyUserViewUrl">
						<portlet:param name="action" value="modifyUserView" />
						<portlet:param name="userView" value="manager" />
						<portlet:param name="filter" value="ANY" />
					</portlet:actionURL> <a ${ (userView eq 'manager') ? "class='bold'
					" : ''} href="${modifyUserViewUrl}"> <spring:message
							code="view.userview.manager" /> </a>
				</li>
			</ul>
		</c:if>

		<portlet:actionURL var="modifyUserViewUrl">
			<portlet:param name="action" value="modifyUserView" />
			<portlet:param name="userView" value="${userView}" />
		</portlet:actionURL>
		<form action="${modifyUserViewUrl}" method="POST">
			<select name="filter" onchange="javascript:this.form.submit();">
				<c:forEach var="filterItem" items="${filters}">
				    <c:set var="selected" value="" />
                    <c:if test="${filterItem == filter}">
                        <c:set var="selected" value='selected="selected"' />
                    </c:if>
                    <option value="${filterItem}" ${selected}><spring:message code="view.tab.${fn:toLowerCase(filterItem)}" /></option>				
				</c:forEach>
			<select>
			<input type="submit" value="<spring:message code="view.form.submit" />"/>
		</form>
	    <hr/>
	</div>
		
	<div id="helpdeskviewer-main">
	
		<c:choose>
			<c:when test="${noTicketsMsg eq '1'}">
				<p class="alarm">
					<spring:message code="view.ticket.message.alarm" />
				</p>
				<a class="alarm" href="${urlHelpdesk}" target="_blank"> => <spring:message
						code="view.ticket.message.url" /> </a>
			</c:when>
			<c:otherwise>
				<c:forEach var="ticket" items="${tickets}">
					<ul>
						<li><span><spring:message code="view.thead.subject" />
								:</span> <a class="helpdeskLink" target='blank'
							href='${ticket.deepLink.value}'>${ticket.label.value}</a>
						</li>
						<li><span><spring:message code="view.thead.category" />
								:</span> ${ticket.category.value}</li>
						<li><span><spring:message code="view.thead.department" />
								:</span> ${ticket.department.value}</li>
						<li><span><spring:message code="view.thead.creation" />
								:</span> <c:set var="date"
								value="${fn:split(ticket.creation.value, ' ')}" /> <c:out
								value="${date[0]} ${date[1]} ${date[2]}" /> <c:set var="hour"
								value="${fn:split(date[3], ':')}" /> <c:out
								value="${hour[0]}:${hour[1]}" />
						</li>
						<li><span><spring:message code="view.thead.status" />
								:</span>
								<spring:message code="view.ticket.status.${fn:toLowerCase(ticket.status.value)}" />
						</li>
						<li><span><spring:message code="view.thead.owner" />
								:</span> ${ticket.owner.value}</li>
					</ul>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
</div>

