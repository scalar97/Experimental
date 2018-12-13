<%--
  Created by IntelliJ IDEA.
  User: tati
  Date: 05/12/2018
  Time: 16:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<c:set var="user" value="${sessionScope.user}"/>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" type="text/css" href="style.css">
	<title>${user.username}</title>
</head>

<body>

<br/><br/>


<p>Oh hey <c:out value="${user.username}"/> !</p><br>
<p>have tasks but ain't feeling like doing em' now? Nooo Problem!...</p><br>
<p class="accent">Your friends are doing the same anyway!<p>
<p>click on their names to view their stack</p></b>
<br/><br/>
<c:forEach items="${sessionScope.myFriends}" var="dearFriend">
	<form action="FrontController" method="post">
		<!-- display the tasks of the selected user-->
		<input type="submit" name="friend_username" value="${dearFriend}"/>
		<input type="hidden" name="action" value="ListFriendsStack" />
	</form>
</c:forEach>
</body>

</html>