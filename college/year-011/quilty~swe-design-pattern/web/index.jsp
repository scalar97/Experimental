<%--
  Created by IntelliJ IDEA.
  User: tati
  Date: 07/12/2018
  Time: 19:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Login</title>
	<link rel="stylesheet" type="text/css" href="style.css">
  </head>
  <body>
  <br>
  <p>Login to procrastinate or view fiends's procrastinations</p><br>
	<form action="FrontController" method="post">
		<input type="text" name="username" placeholder="username"><br>
		<input type="password" name="password" placeholder="password">
		<input type="submit" value="login">
		<input type="hidden" name="action" value="LoginUser" />
	</form>
  </body>
</html>
