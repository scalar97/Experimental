<?php
	# this form is not meant to be accessed directly.
	# it is used in junction with /library/search/index.php
	# see the form above for more information
	# it to allow reserve, cancel and update of books being reserved

	echo '<td>
					<form action="'. $reserve_book.'" method="post">
					<input type="hidden" name="date" value="'. date("Y.m.d") .'">
					<input type="hidden" name="username" value="'.$_SESSION["username"]
					.'">
					<input type="hidden" name="isbn" value="'.$isbn.'">
					<input class="'.$class.'" type="submit" name="reserve" value="'.$value_book ."\">
					</form>

		</td>\n";
?>