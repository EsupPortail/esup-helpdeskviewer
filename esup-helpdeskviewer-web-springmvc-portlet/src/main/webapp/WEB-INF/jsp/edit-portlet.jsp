<%--

    Copyright (C) 2011 Esup Portail http://www.esup-portail.org
    Copyright (C) 2011 UNR RUNN http://www.unr-runn.fr
    Copyright (C) 2011 RECIA http://www.recia.fr
    @Author (C) 2011 Vincent Bonamy <Vincent.Bonamy@univ-rouen.fr>
    @Contributor (C) 2011 Jean-Pierre Tran <Jean-Pierre.Tran@univ-rouen.fr>
    @Contributor (C) 2011 Julien Marchal <Julien.Marchal@univ-nancy2.fr>
    @Contributor (C) 2011 Julien Gribonvald <Julien.Gribonvald@recia.fr>
    @Contributor (C) 2011 David Clarke <david.clarke@anu.edu.au>
    @Contributor (C) 2011 BULL http://www.bull.fr

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

<span><spring:message code="edit.message"/></span>

<div class="portlet-section">

	<div class="portlet-section-body">
	  
	  <portlet:actionURL var="updatePreferencesUrl">
    	<portlet:param name="action" value="updatePreferences"/>
  	  </portlet:actionURL>
	
	  <form id="${n}updatePreferences" class="updatePreferences" action="${updatePreferencesUrl}" method="post">

			<c:if test="${roViewMode eq 'true'}">
				<fieldset>
					<legend><spring:message code="edit.mode"/></legend>
					<ul>
						<li>
							<input type="radio" name="viewMode" value="mine" ${viewMode == 'mine'? 'checked="checked"' : ''}/><spring:message code="edit.viewMode.mine"/>
						</li>
						<li>
							<input type="radio" name="viewMode" value="any" ${viewMode == 'any'? 'checked="checked"' : ''}/><spring:message code="edit.viewMode.any"/>
						</li>
						<li>
							<input type="radio" name="viewMode" value="all" ${viewMode == 'all'? 'checked="checked"' : ''}/><spring:message code="edit.viewMode.all"/>
						</li>									
					</ul>
				</fieldset>
			</c:if>
			<c:if test="${roViewMode eq 'false'}">
				<p></p><spring:message code="edit.viewMode.disable"/></p>
				<input type="hidden" name="viewMode" value="disable" />
			</c:if>
			<input type="submit" value="<spring:message code="edit.done"/>" class="portlet-form-button"/>
		</form>

	</div>

</div>
