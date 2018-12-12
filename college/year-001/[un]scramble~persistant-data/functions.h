/*
Program Description : header file with function definition of the scramble
and unscramble utilities

Date           : 22/04/2017
Group Members  : Daniel Orange, Tatiana Zihindula

Implemented by : Tatiana Zihindula

*/


#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

/* macro definition */
#define FILE_ARG 2 /* file arg f_type = 2  */
#define FLAG 1
#define ARG_MAX 3  /* Must provide 2 args */
#define FNAME_SIZE 64


/* enumerated constants */
enum status {SUCCESS, NOTHING, SCRAMBLE, UNSCRAMBLE};

/* function prototype */
int check_args(int, char*[]);
long int get_file_size(FILE *, long int*);
char* new_file_name(char[], char);
int check_file_state(char[], char [],int , char);
int swap_bytes (FILE *, FILE *, long int);

int scramble(char [], FILE *, long int, char);
int unscramble(char [], FILE *, long int);

void display_help(char *);




/* evaluate the arguments passed and makes sure they conform to
   the program's purpose */
int check_args(int arg_c, char *arg_v[])
{
	bool correct  = ( (arg_c == ARG_MAX) &&
	                  ( (strcmp(arg_v[FLAG], "scramble")) == 0  ||
	                    (strcmp(arg_v[FLAG], "unscramble")) == 0 ) )
	                ? true : false;

	if (correct == true)
		return SUCCESS;

	fprintf(stderr, "\nError: Invalid arguments entered.\n");
	display_help(arg_v[0]);
	return NOTHING;
}

/* This file size file has less than 2 byte we won't even bother
   doing any operation on it 

   This size will be used by the swap_bytes() function*/
long int get_file_size(FILE* my_file, long int *fsize_ptr)
{
	if ( ((fseek(my_file, 0, SEEK_SET)) == 0) &&
	        ((fseek(my_file, 0, SEEK_END)) == 0) )
	{
		*fsize_ptr = ftell(my_file);

		/* No operation if the size of the file is < 2 bytes */
		if  (*fsize_ptr == 0 || (*fsize_ptr == 1)) return EOF;
		else return (*fsize_ptr);
	}
	return EOF;
}

char* new_file_name(char old_name[], char flag)
{
	char f_type[] = ".sbl";
	char *new_name, *new_name_ptr;
	int size = 0;
	int typ_index = strlen(old_name) - strlen(f_type);

	/* If the user chose to scamble a scrambled file */
	if ( (strcmp(&old_name[typ_index], f_type)) == 0 && (flag == 'u'))
	{
		size = strlen(old_name) + 1;
		/* copying the file into a new name*/
		new_name = (char*) calloc(size, sizeof(char)); 

		if (new_name == NULL) return NULL;
		strcpy(new_name, old_name);
		/* clearing file extension*/
		strcpy(&new_name[typ_index], "\0\0\0\0"); 
	}
	else if ( (strcmp(&old_name[typ_index], f_type)) != 0 && (flag == 's'))
	{
		/* else the user chose to unscramble, thus, add the extension */
		/* Allocate memory to accomodate the 4 bytes of the .sbl */

		size = strlen(old_name) + strlen(f_type) + 1;
		new_name = (char*) calloc(size, sizeof(char));

		if (new_name == NULL) return NULL;
		strcpy(new_name, old_name);
		strcat(new_name, f_type);
	}
	else
	{
		/* Else, the user chose to scramble a scrambled file,
		   or to unscramble an unscrambled file */

		check_file_state(old_name, f_type,typ_index,flag);
		return NULL;
	}

	new_name_ptr = new_name;
	/* free(new_name); this pointer is freed by the caller. */
	return new_name_ptr;
}

/* setting the errors of scrambling an unscrambled 
   file or unscrambling a scrambled file accordingly */
int check_file_state(char old_name[], char f_type[],int typ_index, char flag)
{
	if ( (strcmp(&old_name[typ_index], f_type)) == 0 && (flag == 's') )
	{
		printf("%s is scrambled\n", old_name);
		return NOTHING;
	}
	else if ( (strcmp(&old_name[typ_index], f_type)) != 0 && (flag == 'u'))
	{
		printf("\n%s must be scrumbled first.\n", old_name);
		return NOTHING;
	}
	return SUCCESS;
}


int scramble(char my_file[FNAME_SIZE], FILE *f1ptr, long int f1size, char flag)
{
	FILE *f2ptr;
	/* creating new file names from specified flag:'u'/'s' see main() */
	char *new_name = new_file_name(my_file, flag);

	/* creating a binary stream from the returned name if not NULL */
	if (new_name != NULL && (f2ptr = fopen(new_name, "wb")) != NULL)
	{
		/* swaping bytes from original file to created binary file */
		if ((swap_bytes(f1ptr, f2ptr, f1size)) == SUCCESS)
		{
			fclose(f1ptr); 		//closing the main stream
			fclose(f2ptr);		//closing created stream
			remove(my_file);	//delinting original file
			free(new_name);		//freeing heap memory from calloc()
			return SUCCESS;		//Yeah!
		}
	}
	return NOTHING;
}

/* The flag 'u' is the only different 
between this utility, and scramble() */
int unscramble(char my_file[FNAME_SIZE], FILE *f1ptr, long int f1size)
{
	char flag = 'u';
	return scramble(my_file, f1ptr, f1size, flag);
}


int swap_bytes (FILE *f1ptr, FILE *f2ptr, long int f1size)
{
	char bytes[2];
	long int current_pos = 0, size = 0;

	/* get the file size to scramble all even bytes first */
	if (f1size % 2 == 0)  size = f1size;
	else  size = f1size - 1;

	/* seeking at the start of each file */
	if ((fseek(f1ptr, 0, SEEK_SET)) == 0 &&
	        (fseek(f1ptr, 0, SEEK_SET)) == 0)
	{
		/* size has been calculated above and it is always even. */
		while (current_pos != size )
		{
			/* read from file 1 */
			fread(&bytes[0], sizeof(char), 1, f1ptr);
			fread(&bytes[1], sizeof(char), 1, f1ptr);
			current_pos = ftell(f1ptr);

			/* swaping the bytes in file 2 as we go by writting the
			   second bytes read before the first */
			fwrite(&bytes[1], sizeof(char), 1, f2ptr);
			fwrite(&bytes[0], sizeof(char), 1, f2ptr);
		}

		/* Appending the last byte on its own at the end of the new 
		   stream if the size of the main file size was odd */

		if ((fseek(f1ptr, -1, SEEK_END)) == 0 &&
		   (fseek(f2ptr, 0, SEEK_END)) == 0 && (f1size % 2 == 1))
		{
			fread(&bytes[0], sizeof(char), 1, f1ptr);
			fwrite(&bytes[0], sizeof(char), 1, f2ptr);
			current_pos++;
		}
	}
	if (current_pos == size || current_pos == (size + 1))
		return SUCCESS;
	return NOTHING;
}


void display_help(char *prog_name)
{
	/*The 'char *prog_name' above, is the name of the executable.
	  This program uses one executable to perform 2 utilities.
	  The commands scramble or unscramble must be given as
	  FIRST arguments to this executable, folowed by ANY FILE TYPE */

	printf ("\n\nPROGRAM NAME: %s\n"
	        "DESCRIPTION: scrambles and/or unscrambles files"
	        "\nUSAGE\n"
	        "	- The first argument must be "
	        "'scramble' or 'unscramble'\n"
	        "	- The second argument must be "
	        "the file to scramble or to unscramble.\n"
	        "EXAMPLES\n"
	        "	0. C:> executable_name  scramble  \"audio file with spaces.wav\"\n"
	        "	1. C:> %s  scramble  try_me.docx\n"
	        "	2. C:> %s  unscramble  nerd_cat.png.sbl\n\n",
	        prog_name, prog_name, prog_name);
}
