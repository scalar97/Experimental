
//  Author : Tatiana Zihindula
//  Date : 28 April 2017

#include "student.h"


/* Printing all the children of a root node using inorder transversal 
   This algorithm uses the depht first with a recursive function call stack.

   Until a NULL pointer is reached on the way, do:

   step 1: Recursively call to print all nodes to the left till the end (NULL),

   step 2: if current node's middle pointer is null, print current node.
           else, it has similar surnames, therefore call to print them all 
           until the NULL is reached the end.
           
           Now, print them starting from the lowest to the current node.

   step 3: Go as right as possible, call to print all the nodes till NULL  */


void tree_print_all(STUDENT *root_node)
{
	if( root_node!= NULL)
	{
		tree_print_all(root_node->left);
		print_node(root_node);
		tree_print_all(root_node->right);
	}
}




/* Function : Map the first letter of the third argument to its root
   arguments: first letter, root nodes array
   return value: void */

void hash_mapping(char first_letter, STUDENT *root_nodes[])
{
	switch (first_letter)
	{
		case 'I': case 'i': tree_print_all(root_nodes[2]);
			break;

		case 'N': case 'n': tree_print_all(root_nodes[1]);
			break;

		case 'E': case 'e': tree_print_all(root_nodes[0]);
			break;
	}
}



/* Function to :Finding a child by surname inside 3 trees
   arguments: root nodes array to search into, surname to find
   return value: void */

void tree_print_one(STUDENT *root_nodes[], char* surname)
{
	STUDENT *node=NULL;
	int counter=0;

	for(register int i=0; i< MAX_ROOTS; i++)
	{
		/* searching for the same surname in all three roots */ 
		node= find(surname, root_nodes[i]); 
		if(node != NULL)
		{
			print_node(node); /* Print the node if found */
			counter++;
		}
	}
	if(counter > 0) return; /* Surname found as node was not NULL */

	printf("\nNo '%s' found.\n\n", surname); /* counter remained 0 */
}



/* Function to : Print a student's record along with those with a
				 similar surname if any.
   arguments: Parent node
   return value: void */

void print_node(STUDENT *node)
{
	if(node->middle!= NULL)
	{
		/* If there are duplicates, recursively call to print  
		   them all first, then print parent */

		print_node(node->middle);  
	}

	printf("%s\t     %s\t  %s\t %s\n", 
			node->surname, node->firstname, 
			node->student_id, node->country);
}



/* Function to : Search a surname in a binary search tree 
   arguments: surname to find, root nodes array
   return value: return address of node else, return NULL */

STUDENT* find(char *surname, STUDENT *root_node)
{
	if( root_node != NULL) /* current node points somewhere */
	{
		if ((strcmp(surname,root_node->surname)) ==0) /*same name*/
			return root_node;/*return this root (parent) node */ 

		else if ((strcmp(surname,root_node->surname)) <0) /* root is superior*/
			return find(surname, root_node->left);
		else 
			return find(surname, root_node->right); /* root is inferior*/
	}

	return NULL; /* If reached then key not found */
}
