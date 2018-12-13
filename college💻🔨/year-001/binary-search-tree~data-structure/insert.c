/* The following fuctions read the student records from a file 
   then insert the inside the binary search tree */

//   Author : Tatiana Zihindula
//   Date : 28 April 2017

#include "student.h"

/* 	load_from_file 
	parameter: Address of the root node in which values will be stored
	file_name : name of the file from which data will be loaded from.
*/

int load_from_file(STUDENT **root, char file_name[INPUT_SIZE*2])
{
	FILE *fp  = fopen(file_name, "r");
	STUDENT temp; /* temporary student */

	if (fp != NULL )
	{
		fseek(fp, 0, SEEK_SET);

		/* Reading data from .csv file using scannets */
		while ( (fscanf(fp, "%[^,],%[^,],%[^,],%[^\n]\n",
	                temp.firstname, temp.surname, 
	                temp.student_id, temp.country)) != EOF )
		{
			/* adding the student after each reading*/
			add_child(root, &temp); 
		}

		fclose(fp);
		return SUCCESS; /* after the wile loop has reached EOF */
	}
	perror("Error on the given files ");
	return NOTHING; 
}



/* 	Recursive function add_child: step 3 in the flowchart
	parameter: Address of the root node in which values will be stored
	the temp pointer holds the address of the  student to be added
	inside the tree
*/
void add_child(STUDENT **root_node, STUDENT *temp)
{
	if (*root_node == NULL)
	{
		/* exit is only when the appropriate empty spot is found */
		*root_node = add_value(root_node, temp);
	}
	else
	{
		/* root surname is alphabetically bigger */
		if ( (strcmp((*root_node)->surname, temp->surname)) > 0) 
		{
			add_child(&(*root_node)->left, temp);
		}
		else if ( (strcmp((*root_node)->surname, temp->surname)) < 0) 
		{
			/* root surname is alphabetically smaller */
			add_child(&(*root_node)->right, temp);
		}
		else /* root surname is alphabetically equal */
		{
			add_child(&(*root_node)->middle, temp);
		}
	}
}



/* Defining add_values as memory allocator 
   and inner nodes initialiser.

   This function takes the address to the pointer 
   in which the data will be stored 

   It also takes the temporary student in which data will
   sourced from */

STUDENT* add_value(STUDENT** node_ptr, STUDENT* temp)
{
	/* allocating space for 1 student */
	*node_ptr = (STUDENT*) malloc(sizeof(STUDENT)); 

	/* Copying temp this root address */
	**node_ptr=*temp;
	
	/* initialising inner pointers to NULL to for next checking */
	(*node_ptr)->left = NULL;
	(*node_ptr)->right = NULL;
	(*node_ptr)->middle = NULL;

	/* The the current parent node will point here */
	return *node_ptr;
}



/* Freeing all the nodes inside the tree Using Post Order Transversal Depth First

   -  Call to free all the nodes at the left,
   -  Then call to free all the nodes at the right,
   -  Free all the linked-lists duplicate in the middle if any
   -  Then free whatever is the current node  */

void free_all_nodes(STUDENT* root_node)
{
	if (root_node != NULL)
	{
		free_all_nodes(root_node->left);
		free_all_nodes(root_node->right);
		free_all_nodes(root_node->middle);

		free(root_node);
	}
}
