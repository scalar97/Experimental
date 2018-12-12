<?php
include_once('rect.php');
include_once ($search_options);

$top_header_links = array($login_page=>"My account" );

session_start();
echo '<header id="TOP">
		<div id="top_header">
				<ul> ';

if(isset($_SESSION['loggedin']))
{
	$back_to_user_page = $user.'?username='.$_SESSION['username'];
	# now the user is allowed to reserve a book
	
	unset($top_header_links[$login_page]);

	# overrriding the old value for login page
	$user_page = '../rect.php?var=user&username='.$_SESSION['username'];
	$signup_page = $user_page;
	$logout = '../rect.php?var=user&logout=true';
	

	$top_header_links[$logout]= "Log out";
			foreach($top_header_links as $key => $val)
				echo "<li><a href=\"".$key."\">". $val. "</a></li>\n";
	echo '
				<div class="clear"></div></ul>
		</div>
			<div id="log_in_bar">
				<a id="logo" href="'.$back_to_user_page.'"><img src="' . $logo_image .'" alt="library logo"/></a><ul>
		</div>
	<nav> <!--nav starts -->
			<ul>';
	$nav_elements[$back_to_user_page] = "Reserved";
	# the old login link is no longer needed
	$nav_elements = array_diff($nav_elements, [$nav_elements[$login_page]] );
		
	print_nav($nav_elements);

	echo '</ul></nav> ';
		echo '<a id="greetings" href="'.$back_to_user_page.'">Hi ' .$_SESSION['firstname']. '!</a><div calss="clear"></div>';

	# search bar form post to the result page that displays the tables  
	# include_once $search_form;

echo'	  <div id="adv"><a href="'.$advanced_search.'">Advanced search</a></div><br><br>' . "\n";

#echo '<p id ="quote">'.$quote .'</p>';
}
else 
{
foreach($top_header_links as $key => $val)
				echo "<li><a href=\"".$key."\">". $val. "</a></li>\n";	
echo'				<div class="clear"></ul>
	</div>
		<div id="log_in_bar">
			<a id="logo" href="index.html"><img src="' . $logo_image .'" alt="library logo"/></a><ul>
			<li>
				<a id="log_in" href="'; echo $login_page; echo'">Log-in</a></li><li>
				<a href="'; echo $signup_page; echo'">Sign-up</a></li>
			</ul>
		</div>
		<div id="navigation_bar">
		<nav>
<ul>';

print_nav($nav_elements);

echo '</ul></nav> ';

 # search bar form post to the result page that displays the tables  
$search = $login_page;
$_SESSION['username'] ="";
include_once $search_form;

echo '<div id="adv"><a href="'.$login_page.'">Advanced search</a></div><br><br>' . "\n";
}
?>
