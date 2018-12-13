<?php
           # advanged search button
echo '    
          <div id="advanced">';
                	# div containing all the 3 searches tosearch with 
echo '				<div id="advanced_div" class="" > ';
					$search_by["0"] = "Search by";
                     print_selects($search_by, "advanced");
echo '				<br><br></div>
                	<div id="book_div">';
						print_form($search_by_expand_all);
						echo "<br>";
						print_form($search_by_expand_book);
						echo "<br></div>";
echo '
                	<div id="book_div">  ';
                    	print_form($search_by_expand_author);
echo '
               		 </div>
         </div>';
?>
