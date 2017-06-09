<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style type="text/css">
	table, th, td, input, textarea {border: solid gray 1px;}
	
	#table {border-collapse: collapse;
	 		width: 600px;
	 		}
	#table th, #table td{padding: 5px;}
	#table th{width: 120px; background-color: #DDDDDD;}
	#table td{width: 480px;}
	.long {width: 470px;}
	.short {width: 120px;} 		

</style>

<script type="text/javascript">
	function goWrite() {
		// 유효성 검사는 생략 하겠음.
		var writeFrm = document.writeFrm;
		writeFrm.action = "/board/addEnd.action";
		writeFrm.method = "post";
		writeFrm.submit();
	}
</script>

<div style="padding-left: 10%; border: solid 0px red;">
	<h1>글쓰기</h1>
	
<%-- 	<form name="writeFrm" action="<%= request.getContextPath() %>/addEnd.action" method="post">  --%>
	
	<%--	#.132. 파일 첨부하기 --%>
	<%-- 		★★★ enctype="multipart/form-data" 를 해주어야만 파일 첨부가 된다! ★★★ --%>
	<form name="writeFrm" enctype="multipart/form-data" > 
	
	
		<table id="table">
			<tr>
				<th>성명</th>
				<td>
				    <input type="hidden" name="userid" value="${sessionScope.loginuser.userid}" readonly />
					<input type="text" name="name" value="${sessionScope.loginuser.name}" class="short" readonly />
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td><input type="text" name="subject" class="long" /></td>
			</tr>
			<tr>
            	<th>내용</th>
            	<td><textarea name="content" class="long" style="height: 200px;"></textarea></td>
         	</tr>
         	
         	<%-- 		파일 첨부하기! 
         		#133. 파일 첨부 타입 추가하기	--%>
         	<tr>
         		<th>파일첨부</th>
         		<td><input type="file" name="attach" /></td>
         	</tr>
         	
         	<tr>
				<th>암호</th>
				<td><input type="password" name="pw" class="short" /></td>
			</tr>
		</table>
		<br/>
		
<%--	==== #120. 답변 글 쓰기인 경우, 부모글의 seq 값인 fk_seq 값과
					부모글의 groupno 값, 부모글의 depthno 값을 hidden type으로 갖고가야 한다.  --%>
					
			<input type="hidden" value = "${fk_seq}" name = "fk_seq">
			<input type="hidden" value = "${groupno}" name = "groupno">
			<input type="hidden" value = "${depthno}" name = "depthno">
		
		

		<button type="button" onClick="goWrite();">쓰기</button>
		<button type="button" onClick="javascript:history.back();">취소</button>
	</form>

</div>	