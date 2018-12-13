#include <stdio.h>
#include <string.h>

#ifndef MY_STRUCT_TEMPLATE
#define MY_STRUCT_TEMPLATE
#include "contact_struct_template.h"
#endif

#ifndef MY_SORT_FUNCTIONS
#define MY_SORT_FUNCTIONS
#include "sort_search.h"
#endif

#ifndef FILE_FUNCTIONS
#define FILE_FUNCTIONS
#include "file_handling.h"
#endif


#define MAX_CONTACT 8
#define CONFIRM 20


/* enumerated constants SUCCESS == 0*/
enum return_values {SUCCESS, NOTHING};


/* Primary functions' prototypes */
int add_contact(CONTACT []);
int delete_contact(CONTACT*, char []);
int edit_contact(CONTACT[],CONTACT*,char[]);
void search_contact(CONTACT*);
void sort_contacts(CONTACT[]);

/* functions from other headers */
extern void write_to_file(char*, CONTACT[]);
extern void load_from_file(char[],CONTACT []);
extern void merge_sort(CONTACT[], int, int);
extern void merge(CONTACT [], int , int , int );
extern int Bin_search(char [], CONTACT [], int , int );


/* secondary functions' prototypes */
char menu(void);
int get_data(CONTACT[], CONTACT *ptr);
int check_for_space(CONTACT *ptr);
void  clear_data(CONTACT *ptr, int);


/* error checking function prototypes */
int check_if_digits (char []);
int error_check_input(CONTACT [], CONTACT *);
int validate_email(CONTACT *);
void print_contact(CONTACT *, int);


/************   P R I M A R Y     F U N C T I O N S    ***********/

/* OPTION 1 ADD CONTACT */
int add_contact(CONTACT contacts[])
{
	int index = EOF; /* -1 */
	CONTACT *ptr = NULL;

	index = check_for_space(contacts);

	if ( index == EOF )
	{
		fprintf(stderr, "\nError: a maximum number of %d "
		        "contacts has been reached\n", MAX_CONTACT);
		return NOTHING;
	}

	/* pass the address of that empty spot */
	ptr = &contacts[index];

	if ((get_data(contacts, ptr)) == SUCCESS)
	{
		ptr->empty_spot = 0;
		printf("Sucessfully added\n");
		print_contact(ptr,1);
		return SUCCESS;
	}

	/*taking back the empty spot */
	fprintf(stderr,"\nError: Failed to add the contact\n");
	clear_data(ptr, 1);
	return NOTHING;

} /* end add_account() */



/* OPTION 2 DELETE CONTACT */
int delete_contact(CONTACT *ptr, char phone_num[])
{
	char confirm [CONFIRM];
	if((strcmp(ptr->phone_number, phone_num)) != 0)
	{
		fprintf(stderr, "Error:%s is not %s's phone number.\n",
						phone_num, ptr->name);
		fprintf(stderr,"%s's deletion failed.\n", ptr->name);
		return NOTHING;
	}

	printf("\n\nWARNING: %s will be deleted permanently.\n\n"
	       "do you wish to proceed? y/N\n>>", ptr->name);
	fgets(confirm, CONFIRM, stdin);
	confirm[strlen(confirm)-1]= '\0'; /*clearing the \n */

	if ( (strlen(confirm)) == 1 )
	{
		switch (confirm[0])
		{
		case 'y': case 'Y': 
			clear_data(ptr,1);
			printf("\n\nContact deleted!!!\n");
			break;

		case 'n': case 'N': 
			printf("Contact deletion canceled!\n");
			break;
		}
		return SUCCESS;
	}
	fprintf(stderr, "\nError: invalid option\n"
			                 "\nFailed to delete %s.\n", ptr->name);
	return NOTHING;
} /* end delete_contact() */



/* OPTION 3 EDIT CONTACT */
int edit_contact(CONTACT contacts[], CONTACT* ptr, char phone_num[])
{
	CONTACT person_backup = *ptr;
	if ( (strcmp(ptr->phone_number, phone_num)) != 0 )
	{
		fprintf(stderr, "\nError:%s is not %s's phone number.\n",
						ptr->phone_number, ptr->name);
		return NOTHING;
	}

	printf("\n\nEnter new details for %s:\n", ptr->name);

	if (get_data(contacts,ptr) == SUCCESS)
	{
		printf("\n\nThe edited values are:");
		print_contact(ptr,1);
		return SUCCESS;
	}
		
	*ptr = person_backup;
	printf("\n\n%s remains unchanged\n", ptr->name);
	return NOTHING;
}

/* OPTION 4 SEARCH CONTACT */
void search_contact(CONTACT *ptr)
{
	print_contact(ptr,1);
}

/* OPTION 5 SORT CONTACT */
void sort_contacts(CONTACT contacts[])
{
	merge_sort(contacts, 0, MAX_CONTACT-1);
	print_contact(contacts,MAX_CONTACT);
}


/**********   S E C O N D A R Y     F U N C T I O N S    ***********/

/* Implementing menu() */
char menu()
{
	/* size 10: user might enter unecessary long strings */
	char option_chosen [CONFIRM];

	printf("\n\n_______________________________________________\n\n"
	       " E N T E R   A N   O P T I O N \n"
	       "\n Select :\n"
	       "\t\'0\' To display all contacts\n"
	       "\t\'1\' To add a contact\n"
	       "\t\'2\' To delete a contact\n"
	       "\t\'3\' To edit a contact\n"
	       "\t\'4\' To search a contact\n"
	       "\t\'5\' To sort contacts\n"
	       "\t\'6\' To Exit\n\n"

	       "Enter an option\n>>>" );

	fgets(option_chosen, sizeof(option_chosen) - 2, stdin);
	option_chosen[strlen(option_chosen)-1]= '\0';

	/*strlen should == 1, unless more than 1 char was entered  */
	if (strlen(option_chosen) != 1)
	{
		fprintf(stderr, "\nError: Enter a single digit only.\n");
		menu(); /* recursive call until a valid option  */
	}
	else
		return (*option_chosen);

}/* end menu() */



/* implementing check_for_space() */
int check_for_space(CONTACT contacts[])
{
	for (register int i = 0; i < MAX_CONTACT; i++)
	{
		if ( contacts[i].empty_spot == EOF )
			return i;
	}
	return EOF;
} /* end chech_for_space() */



/* implementing get_data(); */

int get_data(CONTACT contacts[], CONTACT *ptr)
{
	/* Reading data from standard input */
	/* ptr->name[strlen(ptr->name)-1] clears the new line character */

	printf("\nEnter Name\n>>>" );
	fgets(ptr->name, sizeof(ptr->name) - 1, stdin);
	ptr->name[strlen(ptr->name)-1]= '\0'; 


	printf("\nEnter phone number\n>>>" );
	fgets(ptr->phone_number, sizeof(ptr->phone_number) - 1, stdin);
	ptr->phone_number[strlen(ptr->phone_number)-1]= '\0';

	printf("\nEnter Email\n>>>" );
	fgets(ptr->email, sizeof(ptr->email) - 1, stdin);
	ptr->email[strlen(ptr->email)-1]= '\0';

	if (error_check_input(contacts, ptr) == SUCCESS)
		return SUCCESS;

	return NOTHING;

} /* end get_data */



/* Implementing clear_data() */
void clear_data(CONTACT contacts[], int number)
{
	CONTACT *ptr;
	
	for(register int i=0; i< number; i++)
	{
		ptr=&contacts[i];
		/* when empt_spot == EOF, they will be overwritten*/
		ptr->empty_spot = EOF;
		strcpy(ptr->name, "");
		strcpy(ptr->phone_number, "");
		strcpy(ptr->email, "");
	}
} /* end clear_data */



/**********   T E R T I A R Y     F U N C T I O N S    ***********/

/* Implementing error_check_input() */
int error_check_input(CONTACT contacts[], CONTACT *ptr)
{
	int counter=0, phone_size = EOF;

	if (strcmp(ptr->name, "") == 0)
	{
		fprintf(stderr, "\nError: please enter a valid name.\n");
		counter++;
	}

	if ((check_if_digits(ptr->phone_number)) == SUCCESS)
	{
		phone_size=strlen(ptr->phone_number);
		if(phone_size<8 && phone_size>15)
		{
			printf("\nError: invalid phone number size\n");
			counter++;
		}
	}
	else
	{
		fprintf(stderr, "\nError: Invalid phone number\n");
		counter++;
	}

	if ( (validate_email(ptr)) == NOTHING)
	{
		fprintf(stderr, "\nError:invalid email.\n");
		counter++;
	}

	if (counter == 0)
		return SUCCESS;

	return NOTHING;

} /* end error_check_input() */


/* function to check if a string contains ONLY digits*/
int check_if_digits(char digit_str[])
{
	/* - counter   : counts the digits chars inside a string
	   - ascii_num : temp ascii value holder for each char */

	int counter = 0,   ascii_num = 0;

	for (register int i = 0; i < strlen(digit_str); i++)
	{
		/* casting char to int, to get the decimal ascii value */
		ascii_num = (int) * (digit_str + i);

		if (ascii_num > 47 && ascii_num < 58)
			counter++;
	}
	if (counter == strlen(digit_str))
		return SUCCESS;
	return NOTHING;

} /* end check_if_digits() */


/* Implementing validate_email() */
int validate_email(CONTACT *ptr)
{
	char username[INPUT_SIZE];
	char host[INPUT_SIZE];
	char domain[INPUT_SIZE];
	int email_size=0;

	sscanf(ptr->email, "%[_a-zA-Z0-9.]@%[_a-zA-Z0-9].%[a-zA-Z]",
	       username, host, domain);
	/* 2 to include the unformatted @ and 'dot' in all emails */
	email_size = 2 + strlen(username) + strlen(host) + strlen(domain);


	if (email_size != (strlen(ptr->email)) )
		return NOTHING;

	return SUCCESS;
} /* end validate email() */


void print_contact(CONTACT contacts[], int number)
{
	printf("\n\nName\tPhone number\tEmail\n"
	       "____\t____________\t_____\n\n");

	for (register int i = 0; i < number; i++)
	{
		printf("%s\t%s\t%s\n",contacts[i].name,
			   contacts[i].phone_number,contacts[i].email);
	}
}