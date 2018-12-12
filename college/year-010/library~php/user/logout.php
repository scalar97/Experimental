<?php
	session_start();
	$_SESSION = array();
	session_destroy();

	include_once "../rect.php";
	header('Location: '. $index_page_rect);
?>