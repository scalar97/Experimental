<?php
include_once "../rect.php";
echo '
<!DOCTYPE html>
<html>
	';
		session_start();
		$page_title = $_SESSION['username'];
		$page_css = $user_page_css;
		include $head;
	
		echo '<body>';
		include ($user_header);
		echo '<div id="container">';
echo '
		</div>';	
		if(isset($_GET['row']) or isset($_GET['search_error']))
		{
			echo '<div id="result_table">';
			if(!isset($_GET['page']))
			{
				include_once($search_options);
			}
			else 
			{
				include_once ($search_options. "?page=" . $_GET['page']);
				echo $_GET['page']; exit();
			}
			echo '</div>';
		}

		include ($footer_user);
echo'</body>
</html>
';
?>