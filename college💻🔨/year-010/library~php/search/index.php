<?php

include_once "../rect.php";

if (isset($_GET['result']))
	print_result($_GET['question'], $_GET['result'], $_GET['row'], $_GET['col'],$reserve_book);
else
	print_result(null, null, null, null,null);



function print_reserve_form($reserve_book, $isbn, $class, $value_book, $book_title)
{
	echo '<td>
					<form action="'. $reserve_book.'" method="post">
					<input type="hidden" name="date" value="'. date("Y.m.d") .'">
					<input type="hidden" name="username" value="'.$_SESSION["username"]
					.'">
					<input type="hidden" name="book_title" value="'.$book_title .'">
					<input type="hidden" name="isbn" value="'.$isbn.'">
					<input class="'.$class.'" type="submit" name="reserve" value="'.$value_book ."\">
					</form>

		</td>\n";
}

function print_result($question, $result,$row_num,$col_num,$reserve_book)
{

	if(isset($_GET['search_error']))
	{
		echo '<p class="error">'.$_GET['search_error'].'</p>';
	}
	else if (isset($result))
	{
		# save the most recent search into the session so that the user chooses to cancel.
		# this is faster than opening the databe and updating the items from there


		if($question && $row_num >0)
			echo '<p>Result for <span>'. $question .'</span></p>';
		elseif ($row_num >0)
			echo '<p>Result</p>';

		$isbn="";
		$book_title="";


		# Pagination

		$max_row_per_page = 5;
		$total_pages = ceil($row_num / 5);


		if ($total_pages > 1)
		{
			for($page =0; $page < $total_pages ; $page++);
		}

		echo "\n 	<table>\n";

		# extracting the data from the database
		foreach ($result[0] as $key => $value)
		{
			if (ctype_upper($key[0]))
				echo '<th>'. $key. '</th>';
		}
		if(isset($_GET['page']))
		{
			$start = ($_GET['page'] * $max_row_per_page) - $max_row_per_page;
			$end = $_GET['page'] * $max_row_per_page;
		}
		else
		{
			$start = 0;
			$end = $row_num;
		}
		$search_options="index.php";
		for ($page=1;$page<=$total_pages;$page++) {
 			echo '<a href="'.$search_options .'?page=' . $page . '">' . $page . '</a>';
}

		#echo $start . "   ". $end;
		
			
		for($i = $start; $i < $end ; $i++) 
		{
			echo "		<tr>\n";
			foreach ($result[$i] as $key => $value)
			{
				if ($key === 'BOOK')
					$book_title = $value;
				
				if ($key === 'isbn' || $key === 'ISBN')
					$isbn = $value;
				
				elseif ($value == 'C')
				{
					$value_book = "Cancel";
					$class = "cancel";
					print_reserve_form($reserve_book, $isbn, $class, $value_book, $book_title);
				}
				else if($value === 'N')
				{
					$value_book = "Reserve";
					$class = "reserve";
					print_reserve_form($reserve_book, $isbn, $class, $value_book, $book_title);
				}
				else if ($value === 'Y')
				{
					$value_book = "Reserved";
					$class = "reserved";
					print_reserve_form($reserve_book, $isbn, $class, $value_book, $book_title);
				}
				else
				{
					echo "		<td>" . $value . "</td>\n";
				}
				if ($key == 'ISBN') echo "		<td>" . $value . "</td>\n";
			}
			echo "		</tr>\n";
		}
		echo "	</table>\n";
	}
}
?>