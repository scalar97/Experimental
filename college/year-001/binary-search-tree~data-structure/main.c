/*
  Program to insert, search and print student records loaded from three 
  differenta file, into a binary search tree.
  Complexiety : (O) log n for insert, search and print
                (1) To locate the apropriate file using a simplified Hash Map
  
  Author : Tatiana Zihindula
  Date : 28 April 2017
*/


#include "student.h"


int main(int argc, char *argv[])
{
	STUDENT *root_nodes[MAX_ROOTS];

	char file [MAX_ROOTS][INPUT_SIZE]= { "funded_eu.csv", \
										 "non_funded_eu.csv",\
										 "international_students.csv"};
	char *arg_surname=NULL;

	/* validating passed commands */
	char option = check_args(argc, argv, &arg_surname);

	if (option == NOTHING)
	{
		return 1; /* incorrect arguments */
	}
	else if ( option == 'a' || option == 's' || option == 'S')
	{
		/* initialising root nodes */
		for (register int i = 0; i < MAX_ROOTS; i++) 
			root_nodes[i] = NULL;

		/* loading, allocating and inserting data in root nodes */
		for (register int i = 0; i < MAX_ROOTS; i++)
		{
			int success=load_from_file(&root_nodes[i], file[i]);
			
			/* case of inexistent file or unknow error, exit. */
			if (success==NOTHING) 
			{
				if(arg_surname != NULL) free(arg_surname); 
				return 1;
			}
		}
		printf("\nSurname\t   Firstname\t Student Id\t Country "
		       "\n-------\t   ---------\t ----------\t -------\n");

		switch(option)
		{
			/* 's' case sensitivity disabled, 'S' case sensitive */
			case 's': tree_print_one(root_nodes, arg_surname); break;
			case 'S': tree_print_one(root_nodes, argv[SNAME]); break;

			/* 'a' finds and print all student by tags.this evaluates
		 	the first letter of the 3rd argument*/
			case 'a': hash_mapping(argv[SNAME][0],root_nodes); break;
		}

		/* free_all_nodes(), releases the memory recursively */
		for (register int i = 0; i < MAX_ROOTS; i++)
			free_all_nodes(root_nodes[i]);
	}
	else
	{
		/* In case of incorrect arguments on the command line */
		display_help(argv[0]);
	}

	/* free case sensitivity string holder */
	if(arg_surname != NULL) free(arg_surname); 
	return 0;
}
