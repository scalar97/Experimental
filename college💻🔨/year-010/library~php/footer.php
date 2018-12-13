<?php
include_once('functions.php');

$footer_headings = array("Contact us" => array("Telephone" => array("0877948474","0879484745"), 
											   "Email" => "chomu@library.ie"),
						"Search and Find" => "Advanced Search", 
						"About Chomu" => "Learn more", 
						"Library and Archive" => "Find a Library",
						"Quick Links" => array("Log in", "Sign up", "Reserve a book"));


$languages = array("English", "Irish", "Swahili", "体中文", "Other");
$footer_class="footer_link";
$lang_id ="lang";

echo "\n\n<footer>";

# priting all the links
foreach ($footer_headings as $key => $value) 
{
	echo "\n\t<section class=" . $footer_class .">\n";
	echo "\t\t<ul>\n";

	# This is a heading link
	echo "\t\t\t<li><h3>". $key. "</h3></li> \n"; 
	if (is_array($value) and is_assoc($value))
		foreach ($value as $k => $val2)
		{
			# This is a second heading link
			echo "\t\t\t<li><h4>". $k . "</h4></li> \n"; 
			if (is_array($val2))
				foreach ($val2 as $a)
					echo "\t\t\t<li>". $a ."</li> \n";
			else
				echo "\t\t\t<li>". $val2 ."</li> \n";
		}
	# Normal array as associative have been checked above
	else if (is_array($value))
		foreach ($value as $val)
			echo "\t\t\t<li>". $val ."</li> \n";

	# else it is a normal list item
	else
		echo "\t\t\t<li>". $value ."</li> \n";

	echo "\t\t<ul>\n";
	echo "\t</section>";
}

# printing the languages
echo "\n\t<div id=". $lang_id .'>';
foreach ($languages as $lang)
{
	echo $lang;
	if($lang != $languages[count($languages) -1])
		echo' | ';
}
echo "\n</footer>";

# Checks wether an array is associative before prining the content

?>
