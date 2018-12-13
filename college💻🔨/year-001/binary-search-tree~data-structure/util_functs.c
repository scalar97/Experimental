
//  Author : Tatiana Zihindula
//  Date : 28 April 2017


#include "student.h"

/* Function : validate the comand line arguments
   arguments: number of arg, argument variables, surname holder, 
   return value: an integer ascii value, or '\0' */

int check_args(int arg_c, char *arg_v[], char**arg_surname)
{
	if(arg_c == 3 && (strcmp(arg_v[OPTION], "find")) == 0) 
	{
		if((no_case_sensitive(arg_v,arg_surname)) =='s') return 's';
		else return 'S';
	}
	/* validating the remaining arguments*/
	else if ((arg_c == 2) && (strcmp(arg_v[OPTION], "--help")) == 0) 
		return 'h';
	else if ((arg_c == 3) && \
		 (strcmp(arg_v[OPTION], "find-all")) == 0 && \
	     ( (strcmp(arg_v[SNAME], "International")== 0)|| \
		   (strcmp(arg_v[SNAME], "international")== 0)|| \
		   (strcmp(arg_v[SNAME], "Eu")== 0)|| \
		   (strcmp(arg_v[SNAME], "eu")== 0)|| \
		   (strcmp(arg_v[SNAME], "Non-Eu")== 0)|| \
		   (strcmp(arg_v[SNAME], "non-eu")== 0)
		 )) return 'a';

	fprintf(stderr, "\nError: Invalid arguments.\n"); 
	return '\0';
}

/* Function : Removes the case sensitivity of the surname's
              1st letter, using 'int toupper()'from <ctype.h>
   arguments: argument variables, surname holder, 
   return value: SUCESS or NOTHING  */

char no_case_sensitive(char *arg_v[], char**arg_surname)
{
	*arg_surname= (char *) calloc(1,sizeof(arg_v[SNAME]));

	if(*arg_surname!=NULL)
	{
		/* copying surname from *argv[] to arg_surname*/
		strcpy(*arg_surname, arg_v[SNAME]); 

		/* converting surname's 1st letter to uppercase */
		*arg_surname[0]=toupper(*arg_surname[0]);
		return 's';
	} 
	return 'S'; /* case sensitivity remains */	
}


/* Function : Display help to stdout in case of incorrect args
   arguments: program_name aka argv[0] 
   return value: void  */

void display_help(char *prog_name)
{
	printf ("\n\nPROGRAM NAME: %s\n\n"
        "DESCRIPTION: finds students in a Binary"
        "Search Tree data structure"
        "\n\nUSAGE\n\n"
        "	- The first argument passed must be "
        "'find','find-all' or '--help'\n"
        "	- The second argument (if the first one was not --help)\n"
        "     	  must be the student surname to find,\n"
        "     	  or the student type(eu, non-eu,international) using 'find-all'\n\n"
        "EXAMPLES\n"
        "	0. C:> executable_name find* International\n"
        "	1. C:> %s find Smith\n"
        "	3. $ ./%s find-all non-eu\n"
        "	4. $ ./%s find-all Eu\n"
        "	5. $ ./%s find-all International\n"
        "	6. $ ./%s --help\n\n",

        prog_name,prog_name,prog_name,prog_name,prog_name, prog_name);
}
