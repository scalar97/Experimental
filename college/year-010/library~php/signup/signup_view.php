<?php

include_once "../rect.php";

$parse_user= array( array("username", "text", "Create username"),
					array("full_name", "text", "Full name"),
                    array("password", "password", "Password"),
                    array("confirm", "password", "Confirm Password"),
					array("address", "text", "Adress: Line1 , Line2.."),
					array("city", "text", "City"),
					array("telephone", "text", "Telephone"),
					array("mobile", "text", "Mobile phone"));

$validate = "sign_up_insert.php";

echo'
<div id="sign_up">
	<div id="logo_login">
		<a href="'; echo $index_page; echo'"><img scr="'. $logo.'" alt="home"></a>
	</div>

	<div id="sign_up_div" class="login_form">
<p>New user? <b>Create an account</b></p>
		<form action="'. $validate .'" method="post">' ."\n";

			if (isset($_GET['errors']) && count($_GET['errors']) >0)
			{
				print_form_log_in($parse_user,$_GET['errors']);
			}
			else
			{
				print_form_log_in($parse_user,array());
			}

echo'<button id="" class="btn">Sign Up</button><b>
<br><br><p>Already have an account?<a href="'. $login_page .'"><b> Log-in</b></a></p><br>
		</form>
	</div>
</div> ';

?>
