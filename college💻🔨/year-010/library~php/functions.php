<?php
include_once "connect.php";

# global variables
$nav_class = "nav_li";

# category table
$cat = mysqli_query($GLOBALS['database'],"SELECT category_id, category_description FROM category");
$category= array('0' => 'Category'); 
while($row=mysqli_fetch_assoc($cat))
{
	$category[$row['category_id']] = $row['category_description'];
}

$logo_image="/library/home/media/image/library_logo.png"; 
$logo = "../home/media/image/logo.png";
$index_page = "/library/rect.php?var=home";
$login_page = "/library/rect.php?var=login";
$signup_page = "/library/rect.php?var=signup"; 
$search = "/library/search/find.php";
$reserve_book = "../user/reserve.php";
$search_form= "../search/search_form.php";

$search_by_expand_author =array("author_name" => "Author name", # this can be exploded at the space
						  "author_id"=>"Author id");

$search_by_expand_book =array("book_title" => "Book Title",
			      "isbn"=>"ISBN",
			      "edition" => "Edition");

$search_by_expand_all = array("contains" => "Contains",
			      "start_with" => "Start with");

$search_by = array( "0" =>"",
		    "book" => "Book Title",
		    "author"=>"Author");

$nav_elements = array(  "#"=>"Catalogue",
		        $login_page =>"Reserve",
			"#" =>"Blog",
			"##" =>"Event");

# global functions

function print_selects(array $arr, string $name)
{
    echo "<select name=".$name. " class=\"search_option\">\n";
	    foreach($arr as $key=> $val)
		    echo "<option value=\"".$key."\">".$val. "</option>\n";
	echo "</select>\n";
}

function print_form(array $arr)
{
    foreach($arr as $key =>$val)
    {    
        echo "<label>\n";
        echo "<span>" . $val . "</span>\n";
        echo "<input type=\"\" name=\"" .$key ."\"><br>\n";
        echo "</label>\n";
    }
}

function is_assoc(array $arr)
{
    if (array() === $arr) return false;
    return array_keys($arr) !== range(0, count($arr) - 1);
}


function print_form_log_in(array $placeholders, array $error_values)
{
	if (count($error_values) != 0)
	{	
		foreach($placeholders as $attr)
		{	
			if(array_key_exists($attr[0], $error_values))
			{
				$attr[2] = 	$error_values[$attr[0]];
				echo "<input class=\"input_errors\" name=\"". $attr[0] ."\" type=\"". $attr[1] ."\" placeholder=\"" . $attr[2]."\"><br>\n";
			}	
			else
			{
				echo "<input name=\"". $attr[0] ."\" type=\"". $attr[1] ."\" placeholder=\"" . $attr[2]."\"><br>\n";
			}
		}		
	}
	else
	{
		foreach($placeholders as $attr)
			echo "<input name=\"". $attr[0] ."\" type=\"". $attr[1] ."\" placeholder=\"" . $attr[2]."\"><br>\n";
	}
}

function print_nav($nav_elm)
{
	foreach($nav_elm as $action => $display)
	{
		echo '<li class="special"><a class="option" href="'. $action. '">'.$display .'</a></li>'."\n"; 
	}
}
?>	
