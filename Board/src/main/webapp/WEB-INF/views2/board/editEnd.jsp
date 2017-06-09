<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

	<script type="text/javascript">
		<c:if test="${n == 1}">
			alert("글 수정 성공!!");
			location.href="<%= request.getContextPath() %>/view.action?seq=${seq}";       
			// 수정된 자신의 글을 보여주는 페이지로 이동
		</c:if>
		
		<c:if test="${n != 1}">
			alert("글 수정 실패!!");
			javascript:history.back();
			// 이전 페이지로 이동
		</c:if>
	</script>




