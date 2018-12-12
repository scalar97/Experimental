<?php
	include "../connect.php";

	if ($_SERVER['REQUEST_METHOD'] === 'POST')
	{
		reserve_and_cancel($_POST['username'],$_POST['isbn'],$_POST['date'],$_POST['reserve'], $_POST['book_title']);
	}


	function reserve_and_cancel($user, $isbn,$date, $option, $book_title)
	{		
		session_start();
		$result="Sorry, book already reserved";

		# no one has reversed the book. not even the user
		# this means the current user can reserve this book
		if ($option == 'Reserve')
		{

			$reserve = mysqli_query($GLOBALS['database'], "INSERT into `reservation` (`isbn`, `username`, `reservation_date`) values ('" .$isbn. "', '". $user. "','".$date."')"); 


			$update_book = mysqli_query($GLOBALS['database'], "UPDATE book set reserved ='Y' where isbn=" . "'" .$isbn. "'"); 

			# On sucess the current user will have the book reserved on his/her name, else. an error occured
			$result =( mysqli_query($GLOBALS['database'], $reserve)  		&&
					   mysqli_query($GLOBALS['database'], $update_book) ) == false	? true:
					   "An error occured when reserving ". $book_title ." :(";
		}
		else if ($option == 'Cancel')
		{
			$delete = mysqli_query($GLOBALS['database'], "DELETE from `reservation` where username=".
					  "'" .$user. "' and isbn=". "'" .$isbn ."'"); 
			$update_book = mysqli_query($GLOBALS['database'], "UPDATE book set reserved ='N' where isbn=" . "'" .$isbn. "'"); 

			$result =( mysqli_query($GLOBALS['database'], $delete)  		&&
					   mysqli_query($GLOBALS['database'], $update_book) ) == false	? true:
					   "An error occured when cancelling the reservation ". $book_title ." :(" ;
		}

		mysqli_close($GLOBALS['database']);
		if($result === true)
		{
			header('Location: ../find.php?for=refresh&question='. $_SESSION['last_question']);
		}
		else
		{
			header('Location: ../rect.php?var=search&search_error='.$result);
		}
	}
?>