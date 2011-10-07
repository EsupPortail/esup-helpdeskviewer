<%@ include file="/WEB-INF/jsp/include.jsp"%>

<link rel="stylesheet"  type="text/css" href="<%=request.getContextPath()%>/css/mhelpdeskviewer.css"/>

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
			<select name="filter" onchange="submit();">
				<c:forEach var="filterItem" items="${filters}">
				    <c:set var="selected" value="" />
                    <c:if test="${filterItem == filter}">
                        <c:set var="selected" value='selected="selected"' />
                    </c:if>
                    <option value="${filterItem}" ${selected}><spring:message code="view.tab.${fn:toLowerCase(filterItem)}" /></option>				
				</c:forEach>
			<select>
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
								:</span> <!-- traduction --> <c:choose>
								<c:when test="${ticket.status.value=='FREE'}">
									<spring:message code="view.ticket.status.free" />
								</c:when>
								<c:when test="${ticket.status.value=='CANCELLED'}">
									<spring:message code="view.ticket.status.cancelled" />
								</c:when>
								<c:when test="${ticket.status.value=='INCOMPLETE'}">
									<spring:message code="view.ticket.status.incomplete" />
								</c:when>
								<c:when test="${ticket.status.value=='POSTPONED'}">
									<spring:message code="view.ticket.status.postponed" />
								</c:when>
								<c:when test="${ticket.status.value=='INPROGRESS'}">
									<spring:message code="view.ticket.status.inprogress" />
								</c:when>
								<c:when test="${ticket.status.value=='APPROVED'}">
									<spring:message code="view.ticket.status.approved" />
								</c:when>
								<c:when test="${ticket.status.value=='CLOSED'}">
									<spring:message code="view.ticket.status.closed" />
								</c:when>
								<c:when test="${ticket.status.value=='EXPIRED'}">
									<spring:message code="view.ticket.status.expired" />
								</c:when>
								<c:when test="${ticket.status.value=='REFUSED'}">
									<spring:message code="view.ticket.status.refused" />
								</c:when>
							</c:choose></li>
						<li><span><spring:message code="view.thead.owner" />
								:</span> ${ticket.owner.value}</li>
					</ul>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
</div>

