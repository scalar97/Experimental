<?php
	include_once('../connect.php');

	# get the username and password posted
	if ($_SERVER['REQUEST_METHOD'] === 'POST')
	{
		$user_data = array('username' => $_POST['username'], 
						   'password' => $_POST['password']);
	}
	else if ($_SERVER['REQUEST_METHOD'] === 'GET')
	{
		$user_data = array('username' => $_GET['username'], 
						   'password' => $_GET['password']);
	}

	# my_sql injection protection
	foreach ($user_data as $key => $val)
	{
		stripslashes($val);
		mysqli_real_escape_string($GLOBALS['database'],$val);
	}

	$query = mysqli_query($GLOBALS['database'],"SELECT username, firstname, surname,city FROM  user WHERE  username="."'".$user_data['username'] ."'" . " and password=". "'".$user_data['password'] ."'");

	if (mysqli_num_rows($query) == 1)
	{
		# get save user data inside the session
		$row = mysqli_fetch_assoc($query);

		session_start();
		# saving the rows from the table inside the current session
    	$_SESSION = $row;
		$_SESSION['loggedin'] = true;

    	header('Location: ../rect.php?var=user&username='.$_SESSION['username']);
	}
	else
	{
		header('Location: ../rect.php?var=login&error="Invalid username or password"');
	
	}

?>