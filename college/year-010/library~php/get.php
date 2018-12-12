<form method="get">
	Google search:<input type="text" name="q">
</form>
<?php
if(isset($_GET["q"]))
{
;
	header('Location: https://www.google.ie/search?q=' . implode(" ", explode(" ",$_GET["q"])) . '&aqs=chrome..69i57j0l5.4738j0j4&sourceid=chrome&ie=UTF-8');
}
?>
