<%--
  Created by IntelliJ IDEA.
  User: tati
  Date: 05/12/2018
  Time: 21:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<c:set var="friend" value="${sessionScope.last_friend_viewed}"/>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title><c:out value="${friend}"/>'s plans</title>
	<link rel="stylesheet" type="text/css" href="style.css">
</head>

<body>

<br/><br/>
<form action="FrontController" method="post">
	<!-- go back to my friends again-->
	<input name="action" type="hidden" value="ShowFriends" />
	<input type="submit" value="<< Return to friends"/>
</form>
<br/><br/>

<table>
	<tr>
		<th><c:out value="${friend}"/>'s procrastinations</th>
		<th>Likes</th>
	</tr>
	<c:forEach items="${sessionScope.theirStack}" var="task">
		<tr>
			<td>${task.todo}</td>
			<td>${task.likes}</td>
		</tr>
	</c:forEach>
</table>
</body>

</html>