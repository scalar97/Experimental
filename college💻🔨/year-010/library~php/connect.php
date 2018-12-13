<?php

$GLOBALS['database'] = mysqli_connect('localhost', 'root','') or die ("Failed to connect to database");
	mysqli_select_db($GLOBALS['database'], "libary") or die ("Library database selection failure");

?>