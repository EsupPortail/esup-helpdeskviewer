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

<%@ include file="/WEB-INF/jsp/include.jsp" %>
 <c:set var="n">
         <portlet:namespace />
 </c:set>
<%--
<link rel="stylesheet"  type="text/css" href="<%=request.getContextPath()%>/css/helpdeskviewer.css"/>
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
<div class="esup-helpdeskviewer">
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
						<portlet:param name="filter" value="${defaultFilterUser}"/>
		   			</portlet:actionURL>
		   			<a ${ (userView eq 'user') ? "class='bold'" : ''} href="${modifyUserViewUrl}">
		              <spring:message code="view.user"/></a><span>/</span>
		         </li>
		   		 <li>
		   		 	<portlet:actionURL var="modifyUserViewUrl">
		   		 		<portlet:param name="action" value="modifyUserView"/>
		   		 		<portlet:param name="userView" value="manager"/>
					    <portlet:param name="filter" value="${defaultFilterManager}"/>
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
		  			<a ${targetValue} href="${linkAddTicket}"><spring:message code="link.addticket"/></a><span>|</span>
		  		</li>
		  		<li>
		  			<img src="<%=request.getContextPath()%>/images/faq-container.png" />
		  			<a ${targetValue} href="${linkFaq}"><spring:message code="link.faq"/></a><span>|</span>
		  		</li>  	
		  		<li>
		  			<img src="<%=request.getContextPath()%>/images/control-panel.png" />
		  			<a ${targetValue} href="${linkControlPanel}"><spring:message code="link.control-panel"/></a>
		  		</li>  		  		
		  	</ul>
		</div>  
		<%--  Tab list of available tickets views --%>
	
	  <div class="helpdeskviewer-messages">
	      <ul class="fl-tabs fl-tabs-left">
	        <c:forEach var="filterItem" items="${tabTickets}">
				 <li class=${ (filterItem eq filter) ? 'fl-activeTab' : ''}>
			          <portlet:actionURL var="modifyUserViewUrl">
			          	<portlet:param name="action" value="modifyUserView"/>
			          	<portlet:param name="userView" value="${userView}"/>   
			            <portlet:param name="filter" value="${filterItem}"/>         
			          </portlet:actionURL>
			          <a href="${modifyUserViewUrl}"><spring:message code="tab.${fn:toLowerCase(filterItem)}"/></a>
			      </li>
	      </c:forEach>
	    </ul>
	  </div>
	  <c:choose>
	  <c:when test="${noTicketsMsg eq '1'}">
			<p class="alarm"><a href="${urlHelpdesk}" ${targetValue}><spring:message code="view.noticket"/></a></p>
	  </c:when>
	  <c:otherwise>
	  <div class="fl-tab-content" role="tabpanel">
	    <table class="${n}helpdeskviewer-messages-table">
	      <tbody>
		      <thead>
		        <tr>
		         <th><spring:message code="tab.thead.lastMessage"/></th>
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
		            <td><span class="togglePoint"><a href="#"><img src="<%=request.getContextPath()%>/images/bullet_toggle_plus.png" /></a></span></td>
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
		          <tr class="toggleable" >
			         <td>  
			            <div class="msgTicket">		 
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
							<br />
		              		<a ${targetValue} href='${ticket.deepLink.value}'>
		                		<spring:message code="ticket.see"/> 
		             		</a> 
			           	</div>   	   
			     </c:forEach>
		        <tr><td><a ${targetValue} href="${linkHome}" class="more"><b>...</b></a></td></tr> 
	      </tbody>
	    </table>
	  </div>
	 
	    </c:otherwise>
	  </c:choose>
	</div>
	</div>
</div>
<script type="text/javascript">
(function ($) {
	if(typeof $('.${n}helpdeskviewer-messages-table').find('tr')[0] != "undefined"){
		$('.${n}helpdeskviewer-messages-table span.togglePoint a:nth-child(2)').hide();
		$('.${n}helpdeskviewer-messages-table tr.toggleable').hide();
		var numCol= $('.${n}helpdeskviewer-messages-table').find('tr')[0].cells.length;	
		$(".${n}helpdeskviewer-messages-table tr.toggleable td").attr("colspan", numCol);
		$(".${n}helpdeskviewer-messages-table .msgTicket").css("display","block").css("background-color","#F9F9EA")
		.css("font-size","13px").css("padding","5px").css("color","black");
		$(".${n}helpdeskviewer-messages-table h3").css("color","red").css("margin","5px 0 10px 0").css("text-decoration","underline");
	}
	$('.${n}helpdeskviewer-messages-table .togglePoint').click(function(event){
		event.preventDefault();
		$(this).parent().parent().next('tr').animate({
            height: "toggle",
            opacity: "toggle"
        }, "medium",function(){
    		var status=$(this).is(":hidden");

    		var index = $(this).prev("tr").index();
    		if(status==false){
    			$(this).parent().parent().next('tr').removeClass("toggleable");   			
    			console.log(index);
    			$(this).prev("tr").children().children().children().addClass("open" + index);
    			$(".open"  + index).html("<img src=\"<%=request.getContextPath()%>/images/bullet_toggle_minus.png\" />");
    		}
    		else{
    			$(".open"  + index).html("<img src=\"<%=request.getContextPath()%>/images/bullet_toggle_plus.png\" />");	
    		}   		
        }
       );  
	});
})(up.jQuery);
</script>