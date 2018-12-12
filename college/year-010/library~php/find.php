<?php
	include_once('rect.php');
	include_once('connect.php');
	$all_good = false;
	$query ="";
	$table_name ="";
	$category_selected ="";
	$default_cols= array('isbn', 'book_title as BOOK', 'author_name as AUTHOR', 'year as YEAR', "edition as EDITION", "reserved as STATUS");
	$reserved_by_user = false;

	session_start();

	if ($_SERVER['REQUEST_METHOD'] === 'POST')
	{
		$to_search = $_POST['search'];
		$keyword = $_POST['keyword'];
		$category = $_POST['category'];
		$username = $_POST['username'];

		# post search using the search bar
		post_search($to_search, $keyword, $category, $default_cols, $username);
	}
	else
	{
		# the user asked to view the whole catalogue. thus, 
		# display all the books in the database
		if (isset($_GET['for']) && $_GET['for']== 'catalog') 
		{
			array_push($default_cols,'category_description as CATEGORY');
			$query = query_builder("book",$default_cols,
								array(array("JOIN", "category","category_id"),
								array("JOIN", "author", "author_id")),null, null);

		}
		else if (isset($_GET['for']) && $_GET['for']== 'reserved')
		{
			# the user only wants to view books that he/she has reserved
			$query = query_builder("reservation",array("user.username as USERNAME","isbn as ISBN",
													"book_title as BOOK",
													"author_name as AUTHOR",
													"reservation_date as \"RESERVATION DATE\"",
													"category_description as CATEGORY",
													"reserved as STATUS"), 

									array(array("JOIN", "book","isbn"),
										  array("JOIN", "author", "author_id"),
										  array("JOIN", "category", "category_id")),null,null);

			$query .= " JOIN user on (reservation.username = user.username)".
					  " WHERE reservation.username=". "'".$_SESSION['username']."'";
		}
		else if (isset($_GET['for']) && $_GET['for']== 'refresh')
		{
			# asked to be refreshed externally.
			find_in_database(true, $_SESSION['last_query'], $_SESSION['last_question'], $_SESSION['username'], false);
			exit();
		}

		find_in_database(true, $query, $_GET['for'], $_SESSION['username'], true);
		mysqli_close($GLOBALS['database']);
	}

	function post_search($to_search, $keyword, $category, $default_cols, $username)
	{
		if(strlen($to_search))
		{
			$all_good = true;
			$search_for = strtoupper($to_search);
		
			switch ($keyword)
			{
				case 'author'; $table_name= $keyword; break;
				default: $table_name = 'book';
			}
			switch ($category) 
			{
				case '0': $category_selected = null; break;
				default: $category_selected = $category;
			}

			if ($category_selected == null)
			{
				# search by either book and/or author
				if($table_name == 'book')
					$query = query_builder("book", 
											$default_cols,
											array(array("JOIN","author","author_id")), 
											array("upper(book_title)", "LIKE", "%".strtoupper($to_search)."%"), null);
				else
					$query = query_builder("book", 
											$default_cols,
											array(array("JOIN","author","author_id")), 
											array("upper(author_name)", "LIKE", "%".strtoupper($to_search)."%"), null);
			}
			else
			{

				if($table_name == 'book')
					$query = query_builder("book", 
											$default_cols,
											array(array("JOIN", "category","category_id")), 
											array("category_id", "=", $category),
											array(array("AND", "upper(book_title)", "LIKE",strtoupper($to_search))));
				else if ($table_name == 'author')
					array_push($default_cols,'category_description as CATEGORY');
					$query = query_builder("book",
											$default_cols, 
											array(array("JOIN", "category","category_id"),
												  array("JOIN", "author", "author_id")),
											array("category_id", "=", $category), 
										    array(array("AND", "upper(author_name)", "LIKE",strtoupper($to_search))));
			} 
		}
		else if (! $category == 0)
		{	# no book specified, display all the categories and their books
			$all_good = true;

				# by category and author
				array_push($default_cols,'category_description as CATEGORY');
				$query = query_builder("book",$default_cols,
										array(  array("JOIN", "category","category_id"),
										array("JOIN", "author", "author_id")),array("category_id", "LIKE", $category), null);
		}
		else
		{
			$all_good = false;
		}

		find_in_database($all_good, $query, $to_search, $username, false);
		mysqli_close($GLOBALS['database']);
	}
	
	function find_in_database($all_good, $query,$to_search, $user, $bool_get_method)
	{
		if($all_good)
		{
			$result = mysqli_query($GLOBALS['database'], $query);
			$rows = mysqli_num_rows($result);
			$columns = mysqli_num_fields($result);

			if ($rows > 0)
			{
				# save the current querry for next use
				$_SESSION['last_query'] = $query;
				$_SESSION['last_question'] = $to_search;

				$response = array();
				# unpacking the rows recieved from the database
				while($row=mysqli_fetch_assoc($result))
				{
					# check if the user has reserved the current book so that he/she can cancel the
					# reservation
					if (reserved_by_user($row['isbn'], $user) or reserved_by_user($row['ISBN'], $user))
						$row['STATUS'] = 'C'; # the user can choose to cancel
					array_push($response, $row);
				}

				# save the previous seach for the next search after updates and cancels
	
				if($bool_get_method) # refresh the page with last search
				{
					# call the last search recursively to refesh the page, then set the get methid to false to stop the recursion
					find_in_database(true, $_SESSION['last_query'], null, $_SESSION['username'], false);
					exit();
				}
				else # new search
					header('Location: rect.php?var=search&row='.$rows.'&col='.$columns.
					   '&question='.$to_search.'&'.http_build_query(array('result' => $response)));
			}
			else
			{
				if(empty($to_search))
					$search_error = "No results found :(";
				else
					$search_error = "No results found for '". $to_search. "' :(";

				if($to_search == 'reserved')
					$search_error = "You currently have no books reserved!";

				header('Location: rect.php?var=search&search_error='.$search_error);	
			}
		}
		else	
		{
				$search_error = "Nothing to search!";
				header('Location: rect.php?var=search&search_error='.$search_error);	
		}

	}
	

	function query_builder($table_name, $colum_name, $joins, $wheres, $and_or)
	{
		$join_builder= array();
		$where_builder = array();
		$and_or_builder = array();

		# building the joins
		if(count($joins) > 0)
			foreach ($joins as $build) 
				array_push($join_builder, " ". $build[0]." " . $build[1]." USING(".$build[2].") ");

		# building the where clauses
		if(count($wheres) > 0)
				array_push($where_builder, " WHERE ". $wheres[0]." " . $wheres[1]." '".$wheres[2]."' ");

		if(count($and_or) > 0)
			foreach($and_or as $cond)
				array_push($and_or_builder, $cond[0]." " . $cond[1]." ".$cond[2]." '".$cond[3]."'" );


		$query ="SELECT  ". implode(", ", $colum_name).
						 " FROM ". $table_name . implode(" ", $join_builder).
						 implode(" ", $where_builder). implode(",", $and_or_builder);

		return $query; 
	}


	function reserved_by_user($isbn, $user)
	{
		$reserved_by_this_user = mysqli_query($GLOBALS['database'],"SELECT username FROM  reservation WHERE  username='$user' AND isbn='$isbn'");
		# the current user has reserved the current book
		if (mysqli_num_rows($reserved_by_this_user) == 1)
			return true;
		# the current book has not reserved this book.
		return false;
	}
?>