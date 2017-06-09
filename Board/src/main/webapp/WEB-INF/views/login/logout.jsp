<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<script type="text/javascript">
	<c:if test="${sessionScope.loginuser == null}">
		alert("로그아웃 되었습니다.");
		location.href="<%= request.getContextPath() %>/index.action"; 
	</c:if>
</script>
    