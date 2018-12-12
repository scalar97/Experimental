<?php
echo '				<form action="'.$search.'" method="post" id="search_form" >';
                	$search_by["0"] = "Keyword";
					print_selects($search_by, "keyword");
					print_selects($category, "category");
echo '
					<input type="text" name="search" placeholder="Enter Book-title or Author-name...">
					<input type="hidden" name="username" value="'. $_SESSION['username'].'">
					<button type="submit">Find</button>
	 				</form>	';
?>
