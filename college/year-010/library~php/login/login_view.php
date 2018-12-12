<?php
include_once "../rect.php";

$parse_log_in = array( 	array("username", "text", "Username"),
						array("password", "password", "Password") );


echo'
<div id="sign_up">
	<div id="logo"><a href="'; echo $index_page;echo'"><img scr="';echo $logo; echo'" alt="home"></a>
	</div>
<div id="log_in_div clas="login_form">
		<form action="'.$login_post.'" method="post">';
           print_form_log_in($parse_log_in, array());
echo '	
<br><br><p>Don\'t have an account? <a href="'. $signup_page .'"><b>Sign-up</b></a></p>		
		<button id="" class="btn">Login</button>
		</form>
		</div>';
if(isset($_GET['error']))
{
	echo '	
	<br><div id="error">
				<p class="error">'. $_GET['error'].'</p><br>
				
			<script>
				setTimeout(function() {
				  $("#errors").fadeOut().empty();
				}, 1000);
	  		</script>
		</div>';
}
echo '</div>';

?>
