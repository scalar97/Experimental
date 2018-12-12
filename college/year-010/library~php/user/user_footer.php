<?php
include_once "../rect.php";

$footer_user = array(	"Contact us" => "#", 
						"Advanced Search" => $advanced_search,
						"Category" =>"../find.php?for=category",
						"Find a Library"=> "#",
						"Quick Links" => "#");

function print_user_footer($footer_user)
{
	echo '<footer><div id="user_footer"><ul>';
	foreach ($footer_user as $key=> $value)
	{
		echo '		<li><a href="'.$value. '">'.$key. "</a></li>\n"; 
	}
	echo "\n</ul>
	</div></footer>\n";
}

print_user_footer($footer_user);
include_once("../signup/login_footer.php");
?>