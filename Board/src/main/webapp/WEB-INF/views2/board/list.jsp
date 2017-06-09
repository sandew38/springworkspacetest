<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<style type="text/css">
	table, th, td {border: solid gray 1px;}
	#table {border-collapse: collapse; width: 820px;} 
	#table th, #table td {padding: 5px;}
	#table th {background-color: #DDDDDD;}
	
	a{text-decoration: none;} 
	    
</style>

 
<script type="text/javascript">
	$(document).ready(function(){
		
		searchKeep();

<%--	====	#147. Ajax로, 검색어 입력시 자동글 완성하기 ②	====	 --%>
		$("#displayList").hide();
		
		$("#search").keyup(function(){
			
			var form_data = { colname : $("#colname").val(),		// key 값 : value 값
							   search : $("#search").val()	};
			
			$.ajax({
						url : "/board/wordSearchShow.action",
						type : "GET",
						data : form_data, // url 요청 페이지로 보내는 ajax 요청데이터
						dataType : "JSON",
						success : function(data)
						{
							
					//	====	#152. Ajax로 검색어 입력시 자동글 완성하기 ⑦	====
						
							if (data.length > 0)	// if(data != null) 로 하면 안된다 ★★★
							{	//	검색된 데이터가 있는 경우
								
								var resultHTML = "";
							
								$.each(data, function(entryIndex, entry){	//  객체의 인덱스, 하나의 객체 
									
									var wordstr = entry.RESULTDATA.trim();
									// 검색어 : 영주
									// 결과물 : 영주사과 
									//		  : 김영주 바둑기사
									//		  : 김영주 프로그래머 
									
									var index = wordstr.toLowerCase().indexOf( $("#search").val().toLowerCase() );
									// 검색한 단어가 몇 번째부터 나오는지 확인하기 위함이다.
									
									var len = $("#search").val().length; // 입력한 글자의 길이 
									
									var result = "";
									
									result = "<span class='first' style = 'color : blue;'>" + wordstr.substr(0,index) + "</span>" 
										   + "<span class='second' style = 'color : red; font-weight : bold;'>" + wordstr.substr(index, len) + "</span>" 
										   + "<span class='third' style = 'color : blue;'>" + wordstr.substr(index+len,wordstr.length-(index+len) ) + "</span>";
									
									resultHTML += "<span style = 'cursor : pointer;'>" + result + "</span><br/>";
									
								});
								
								$("#displayList").html(resultHTML);
								$("#displayList").show();
								
							}
							else					// if(data == null) 로 하면 안된다 ★★★
							{	// 검색된 데이터가 없는 경우 
								$("#displayList").hide();
							}
							
							
						} // end of success : function ----
						, error : function()
						{
							// 실패한경우	
								  alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error); 
							// request.status ==> 200 이라면 success
							//				  ==> 404 이라면 파일이 없는 상태
							//				  ==> 500 이라면 error
							
						
						} // end of error : function ----
						
					}); // end of $.ajax ----
			
		}); // end of $("#search").keyup(function() ----
				
				
//		====	#153. Ajax로 검색어 입력시 자동글 완성하기 ⑧	====
		$("#displayList").click(function(event){
			var word = "";
			var $target = $(event.target);
			
			if($target.is(".first"))
			{
				word = $target.text() + $target.next().text() + $target.next().next().text();
		//		alert(word);
		
				$("#displayList").hide();
				
			}
			else if($target.is(".second"))
			{
				word = $target.prev().text() + $target.text() + $target.next().text();
		//		alert(word);
		
				$("#displayList").hide();
			}
			else if($target.is(".third"))
			{
				word = $target.prev().prev().text() + $target.prev().text() + $target.text();
		//		alert(word);
		
				$("#displayList").hide();
			}
			
			$("#search").val(word); // 텍스트박스에, 검색된 결과의 문자열을 입력해준다.
		
			$("#display").hide();
			
		}); // end of $("#displayList").click(function() ----

	});// end of $(document).ready()----------------------
	
	
	function searchKeep()
	{
		<c:if test="${not empty colname && not empty search}">
			$("#colname").val("${colname}");
			$("#search").val("${search}");
		</c:if>
	}
	
	
	function goSearch()
	{
		searchForm = document.searchForm;
		var search = $("#search").val();
		
		if (search.trim() == "")
		{
			alert("검색어를 입력하세요!");
		}
		else
		{
			searchForm.action = "/board/list.action";
			searchForm.method = "get";
			searchForm.submit();
		}
	}

</script>

<div style="padding-left: 10%; border: solid 0px red;">
	<h1>글목록</h1>
	
	<table id="table">
		<tr>
			<th style="width: 70px;" >글번호</th>
			<th style="width: 360px;" >제목</th>
			<th style="width: 70px;" >성명</th>
			<th style="width: 180px;" >날짜</th>
			<th style="width: 70px;" >조회수</th>
<%-- 	====	#141. 파일 첨부 여부를 보여준다!	 --%>
			<th style="width: 70px;" >파일</th>
		</tr>
		
		<c:forEach var="boardvo" items="${boardList}" varStatus="status"> 
			<tr>
				<td align="center">${boardvo.seq}</td>
				<td>
				<%-- #126. 답변글인경우 제목 앞에 공백(여백)과 함께 Re라는 글자를 붙인다. --%>
				
				<%-- 답변 글이 아닌 원래의 글인 경우 --%>
<c:if test="${boardvo.depthno == 0}">
		             <c:if test="${boardvo.commentCount > 0}">			
					 <a href="<%= request.getContextPath() %>/view.action?seq=${boardvo.seq}">${boardvo.subject}
					 <span style="color: red; font-weight: bold; font-style: italic; font-size: smaller; vertical-align: super; ">[${boardvo.commentCount}]</span></a> 
					 </c:if>
					 
					 <c:if test="${boardvo.commentCount == 0}">
					 <a href="<%= request.getContextPath() %>/view.action?seq=${boardvo.seq}">${boardvo.subject}</a>
					 </c:if>
	             </c:if>
	             
	             <!-- 답변글인 경우 --> 
	             <c:if test="${boardvo.depthno > 0}">
		             <c:if test="${boardvo.commentCount > 0}">			
					 <a href="<%= request.getContextPath() %>/view.action?seq=${boardvo.seq}">
						 <span style="color: red; font-style: italic; padding-left: ${boardvo.depthno * 20}px;">└＞Re : </span>${boardvo.subject}<span style="color: red; font-weight: bold; font-style: italic; font-size: smaller; vertical-align: super; ">[${boardvo.commentCount}]</span></a> 
					 </c:if>
					 
					 <c:if test="${boardvo.commentCount == 0}">
					 <a href="<%= request.getContextPath() %>/view.action?seq=${boardvo.seq}"><span style="color: red; font-style: italic; padding-left: ${boardvo.depthno * 20}px;">└＞Re : </span>${boardvo.subject}</a>
					 </c:if>
	             </c:if>
	             				
				</td>
				<td>${boardvo.name}</td>
				<td align="center">${boardvo.regDate}</td>
				<td align="center">${boardvo.readCount}</td>
				
<%--	====	#142. 첨부파일 여부 표시하기 ( 이미지로 표시 ) --%>
				<td align="center">
					<c:if test="${not empty boardvo.fileName}">
						<img src="<%=request.getContextPath()%>/resources/images/disk.gif">
					</c:if>
				</td>
				
			</tr>
		</c:forEach>
	</table>
	<br/>
	
	<!-- #115. 페이지 바 보여주기 -->
	<div align="center" style="width: 750px; margin-top: 1%; margin-bottom: 2%;">
		${pagebar }
	</div>
	
	<div style="margin-top: 20px;" align="center">
		<button type="button" onClick="javascript:location.href='<%= request.getContextPath() %>/list.action'">글목록</button>&nbsp;
		<button type="button" onClick="javascript:location.href='<%= request.getContextPath() %>/add.action'">글쓰기</button>
	</div>	

	
	
	<!-- #103. 글 검색 폼 추가하기 : 제목, 내용, 글쓴이로 검색할 수 있다. -->
	<form name = "searchForm" >
		<select name="colname" id = "colname" style="height: 26px; width: 70px;">
			<option value="subject">제목</option>
			<option value="content">내용</option> 
			<option value="name">글쓴이</option>
		</select>
		<input type="text" name = "search" id = "search" size = "40px"/>
		<button type="button" onclick="goSearch();" class = "btn btn-primary">검색</button>
	</form>


	
<%--	====	#146. Ajax로, 검색어 입력시 자동글 완성하기 ①	====	 --%>
	<div id = "displayList" style="width: 314px; margin-left: 75px; margin-bottom: 5px; border: 2px gold solid; border-top: 0px; ">

	</div>







