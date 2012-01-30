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

<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ taglib prefix='portlet' uri="http://java.sun.com/portlet"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<portlet:defineObjects />

<c:set var="n">
	<portlet:namespace />
</c:set>
<fmt:setLocale value="${messageFile}" />
<div class="portlet-title">
	<h2>
		<spring:message code="edit.title" />
	</h2>
</div>
<c:if test="${(userViewMode eq 'false')&&(managerViewMode eq 'false')}">
	<span><spring:message code="edit.message"/></span>
</c:if>
<div class="portlet-section">
	<div class="portlet-section-body">
	  <div class="helpdeskviewer-edit">	
	  <portlet:actionURL var="updatePreferencesUrl">
    	<portlet:param name="action" value="updatePreferences"/>
  	  </portlet:actionURL>
	
	  <form id="${n}updatePreferences" class="updatePreferences" action="${updatePreferencesUrl}" method="post">
			<c:if test="${userViewMode eq 'true'}">
				<fieldset>
					<legend><spring:message code="edit.mode.user"/></legend>
					<ul>
						<c:forEach var="userTab" items="${userTabPrefs}">				
							<li>
							  <c:choose>
								<c:when test="${fn:contains(userTab, '.')}">
									<input type="checkbox" name="viewUserBox" value="${ fn:substringAfter(userTab, '.') }" checked="checked"/>
									<spring:message code="tab.${ fn:substringAfter(userTab, '.') }"/>
								</c:when>
								<c:otherwise>
									<input type="checkbox" name="viewUserBox" value="${userTab}" /><spring:message code="tab.${userTab}"/>
								</c:otherwise>
							  </c:choose>
							</li>	
						</c:forEach>			
					</ul>
				</fieldset>
				<input type="hidden" name="userViewMode" value="enable" />
		   </c:if>
		   <c:if test="${managerViewMode eq 'true'}">
				<fieldset>
					<legend><spring:message code="edit.mode.manager"/></legend>
					<ul>
						<c:forEach var="managerTab" items="${managerTabPrefs}">				
							<li>
							  <c:choose>
								<c:when test="${fn:contains(managerTab, '.')}">
									<input type="checkbox" name="viewManagerBox" value="${ fn:substringAfter(managerTab, '.') }" checked="checked"/>
									<spring:message code="tab.${ fn:substringAfter(managerTab, '.') }"/>
								</c:when>
								<c:otherwise>
									<input type="checkbox" name="viewManagerBox" value="${managerTab}" /><spring:message code="tab.${managerTab}"/>
								</c:otherwise>
							  </c:choose>							
							</li>
						</c:forEach>
					</ul>
				</fieldset>	
				<input type="hidden" name="managerViewMode" value="enable" />
			</c:if>							
			<c:if test="${(userViewMode eq 'false')&&(managerViewMode eq 'false')}">
				<p></p><spring:message code="edit.viewMode.disable"/></p>
			</c:if>
			<c:if test="${userViewMode eq 'false'}">
				<input type="hidden" name="userViewMode" value="disable" />
			</c:if>
			<c:if test="${managerViewMode eq 'false'}">
				<input type="hidden" name="managerViewMode" value="disable" />
			</c:if>
			<c:if test="${maxTicketsViewMode eq 'true'}">
				<fieldset>
					<legend><spring:message code="edit.mode.maxtickets"/></legend>
					<input type="text" name="viewMaxTickets"  size="3" maxlength="3" value="${nbMaxTickets}"/>
				</fieldset>	
			</c:if>
			<input type="submit" value="<spring:message code="edit.done"/>" class="portlet-form-button"/>
		</form>
	</div>
  </div>
</div>
