<?php
include_once "../rect.php";

if (isset($_GET["username"]))
{
	$username = $_GET["username"];
}
else if (isset($_SESSION["username"]))
{
	$username = $_SESSION["username"];
}
else
{
	header('Location : '. $login_page);
	exit();
}

$nav_elm = array("../find.php?for=catalog" =>"Catalogue",
				"../find.php?for=reserved&user=".$_SESSION['username'] =>"View reserved",
				"../rect.php?var=user&logout=true" =>"Logout");
echo '
			<header id="userheader">
					<div id="logo_bar">
						<a id="logo" href="'; echo $index_page; echo'"><img src="'; echo $logo; echo'" alt="home"></a>
						<p id="usename">'. $username .'</p>
						<div class="clear"></div>
					</div>	
					<div id="bar_header">	
						<ul>';
								print_nav($nav_elm);
					echo'</ul>
					</div>';

					include_once $search_form;
					
echo '</header>';
			
?>
