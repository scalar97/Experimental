
<?php

	$functions = 'functions.php';
	include_once ($functions);

	# redict pages 
	$index_page_rect = "/library/home/index.html";
	$login_page_rect = "/library/login/";
	$signup_page_rect = "/library/signup/";
	$myaccount = "/library/login/";
	$user = "/library/user/";
	$user_logout ="/library/user/logout.php";
	$quote = "The master has failed more than the beginner can ever immagine. -Learn";


	# global common headers
	$header= '../header.php';
	$footer= '../footer.php';
	$head = '../head.php';


	# user
	$user_header = './user_header.php';
	$user_page_css= "/library/user/css/user.css";
	$footer_user = './user_footer.php';

	$reserve_rect = '/library/user/reserve.php';
	$reserve_form = "../user/reserve_form.php";

	# signup 
	$signup_css = "/library/signup/css/signup.css";
	$signup_view = './signup_view.php';

	$search ="/library/find.php";
	$search_options ="../search/index.php";

	# login css
	$login_view = './login_view.php';
	$login_post = "/library/login/login_check.php";
	$login_footer = "../signup/login_footer.php ";

	#home login
	$home_page_css= "/library/home/css/index.css";
	$home_title="home";

	# advanced 
	$advanced_css = "/library/home/css/advanced.css";
	$advanced_title="Advanced Search";
	$advanced_view = '../advanced_search.php';
	$advanced_search ='../home/advanced_search.html';


	if (isset($_GET['var']))
	{
		if ($_GET["var"] == 'home')
			header('Location: '. $index_page_rect);
		else if ($_GET["var"] == 'login' && isset($_GET['error']))
		{
			$error = "Error: ". $_GET['error'];
			header('Location: '.$login_page_rect.'?error='.$error);
		}
		else if ($_GET["var"] == 'login')
		{
			header('Location: '.$login_page_rect);
		}
		else if ($_GET['var'] == "check_login")
		{
			header('Location: '.$login_post.'?username='.$_GET['username'].'&password='.$_GET['password']);
		}
		else if ($_GET["var"] == "user" && isset($_GET['logout']))
		{
			header('Location: '.$user_logout.'?username='.$_GET['username']);
		}
		else if ($_GET["var"] == "user" && isset($_GET['username']))
		{
			header('Location: '.$user.'?username='.$_GET['username']);
		}

		else if ($_GET["var"] == 'signup_failure' && isset($_GET['errors']))
		{
			header('Location: '.$signup_page_rect.'?'.http_build_query(array('errors' => $_GET['errors'])));
		}
		else if ($_GET["var"] == 'signup')
		{
			header('Location: '. $signup_page_rect);
		}
		else if ($_GET["var"] == 'myaccount')
		{
			header('Location: '.$login_page_rect);
		}
		else if ($_GET['var'] == 'search' && isset($_GET['search_error']))
		{
			header('Location: '.$user.'?search_error='.$_GET['search_error']);
		}
		else if ($_GET['var'] == 'search' && isset($_GET['result']))
		{
			header('Location: '.$user.'?&row='.$_GET['row'].'&col='.$_GET['col']. '&question='.$_GET['question'].'&'.http_build_query(array('result' => $_GET['result'])));
		}
	}

?>