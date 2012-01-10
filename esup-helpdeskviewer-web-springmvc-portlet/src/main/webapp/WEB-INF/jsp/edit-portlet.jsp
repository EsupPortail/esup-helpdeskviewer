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

<div class="portlet-title">
	<h2>
		<spring:message code="edit.title" />
	</h2>
</div>
<c:if test="${roViewMode eq 'true'}">
	<span><spring:message code="edit.message"/></span>
</c:if>
<div class="portlet-section">
	<div class="portlet-section-body">
	  <div class="helpdeskviewer-edit">	
	  <portlet:actionURL var="updatePreferencesUrl">
    	<portlet:param name="action" value="updatePreferences"/>
  	  </portlet:actionURL>
	
	  <form id="${n}updatePreferences" class="updatePreferences" action="${updatePreferencesUrl}" method="post">
			<c:if test="${roViewMode eq 'true'}">
				<fieldset>
					<legend><spring:message code="edit.mode.user"/></legend>
					<ul>
						<c:forEach var="userTab" items="${userTabPrefs}">				
							<li>
								<input type="checkbox" name="viewUserBox" value="${ fn:substringBefore(userTab, '.') }"  
								<c:if test="${fn:contains(userTab, 'check')}"> checked="checked"</c:if> /><spring:message code="tab.${ fn:substringBefore(userTab, '.') }"/>
							</li>	
						</c:forEach>			
					</ul>
				</fieldset>
		   <c:if test="${isManagerViewAble eq 'true'}">
				<fieldset>
					<legend><spring:message code="edit.mode.manager"/></legend>
					<ul>
						<c:forEach var="managerTab" items="${managerTabPrefs}">				
							<li>
								<input type="checkbox" name="viewManagerBox" value="${ fn:substringBefore(managerTab, '.') }"  
								<c:if test="${fn:contains(managerTab, 'check')}"> checked="checked"</c:if> /><spring:message code="tab.${ fn:substringBefore(managerTab, '.') }"/>
							</li>
						</c:forEach>
					</ul>
				</fieldset>	
			</c:if>			
				<input type="hidden" name="viewMode" value="enable" />
			</c:if>
			<c:if test="${roViewMode eq 'false'}">
				<p></p><spring:message code="edit.viewMode.disable"/></p>
				<input type="hidden" name="viewMode" value="disable" />
			</c:if>
			<input type="submit" value="<spring:message code="edit.done"/>" class="portlet-form-button"/>
		</form>
	</div>
  </div>
</div>
