<?php
	include_once('../connect.php');


	$user_metadate= array("username", "password","full_name", "address", "city", "telephone", "mobile");
	$add_to_insert = array();
	$add_to_error = array();

	foreach ($user_metadate as $meta)
	{
		switch ($meta)
		{
			case 'username':
				# first check if the username is already in the database.
				if (isset($_POST['username']) && strlen($_POST['username']) >=2)
				{
					if(check_user($_POST['username']))
						$add_to_error["username"] = "Username taken";
					else
						array_push($add_to_insert, str_replace(' ', '', $_POST['username']));
				}
				else
					$add_to_error['username'] = "Invalid username.";
				break;
			case 'password':
				if (isset($_POST['password']) && isset($_POST['confirm']))
				{
					if ($_POST['password'] !== $_POST['confirm'])
						$add_to_error['password'] = "Password Mismatch";

					if (strlen($_POST['confirm']) <6)
						$add_to_error['confirm'] = "Must confirm password";

					if (strlen($_POST['password']) >=6)
						array_push($add_to_insert, $_POST['password']);
					else
						$add_to_error['password'] = "Password of at least 6 digits required";
				}
				else
				{
					$add_to_error['password'] = "Password required";
					$add_to_error['confirm'] = "Comfirm password";
				}

				break;

			case 'full_name':
				if (isset($_POST['full_name']) &&  !empty([$_POST['full_name']]))
				{
					$name= explode(" ", $_POST['full_name']);

					if(count($name)==2)
						array_push($add_to_insert, $name[0], $name[1]);
					else
						$add_to_error["full_name"] ="Enter Name and surname";
				}
				else
					$add_to_error["full_name"] ="Full name required";
				break;

			case 'address':
				if (isset($_POST['address']) && strlen($_POST['address'])> 2)
				{
					array_push($add_to_insert, $_POST['address']);
				}
				else
					$add_to_error["address"] = "Invalid address";
				break;

			case 'city':
				if (isset($_POST['city']) && !empty($_POST['address']))
				{
					array_push($add_to_insert, str_replace(' ', '', $_POST['city']));
				}
				else $add_to_error["city"] = "Invalid city";
				break;

			case 'telephone':
				if (isset($_POST['telephone']) && strlen((string)$_POST['telephone']) == 7)
				{
					array_push($add_to_insert, str_replace(' ', '', $_POST['telephone']));
				}
				else $add_to_error["telephone"] ="Landline of 7 characters";
				break;

			case 'mobile':
				if (isset($_POST['mobile']) && strlen((string)$_POST['mobile']) == 10)
				{
					array_push($add_to_insert, (string) $_POST['mobile']);
				}
				else $add_to_error["mobile"] = "Phone of 10 digits.";
				break;
		}
	}
	if (count($add_to_error) == 0)
	{
		# all good, no errors. Insert the user in the database

		$user_data = "'" . implode("','", $add_to_insert) . "'";
		$sql = "INSERT INTO `user` (`username`,`password`,`firstname`,`surname`,`address`,`city`,`telephone`,`mobile_phone`) VALUES (". $user_data .")";
		
		if(mysqli_query($GLOBALS['database'], $sql))
		{
			mysqli_close($GLOBALS['database']);
			header('Location: ../rect.php?var=check_login&username='.$_POST['username'].'&password='.$_POST['password']);
			exit();
		}
		else
		{
			mysqli_close($GLOBALS['database']);
			echo "Error: ". $user_data . "<br>" . mysqli_error($GLOBALS['database']);
		}
		
	}
	else
	{
		
		header('Location: ../rect.php?var=signup_failure&'.http_build_query(array('errors' => $add_to_error)));
	}


	function check_user($user_post)
	{

		$query = mysqli_query($GLOBALS['database'],"SELECT firstname FROM  user WHERE  username='$user_post'");
		
		if (mysqli_num_rows($query)!=0)
			return true;
		return false;
	}

?>