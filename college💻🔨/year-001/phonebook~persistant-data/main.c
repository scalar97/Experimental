/*
Program to manage a phonebook.

Date				: 22/04/2017
Tatiana Zihindula

*/
#include "contact_functions.h"

int main()
{
	CONTACT contacts[MAX_CONTACT];
	int index;
	char option;
	char file_name[INPUT_SIZE]= "contacts.txt";
	char update_file[INPUT_SIZE]= "contacts.txt"; //.ipdate will be appended when required
	char name_holder[INPUT_SIZE];
	char phone_no[INPUT_SIZE];


	clear_data(contacts, MAX_CONTACT); /*empty the database */
	load_from_file(file_name, contacts); /*load contacts from file */

	do
	{
		option=menu();

		if(option=='2' || option=='3' || option=='4')
		{
			printf("\nEnter contact's name\n>>");
			
			fgets(name_holder,INPUT_SIZE-1,stdin);
			name_holder[strlen(name_holder)-1]='\0';

			/* sort contacts before binary searching them */
			merge_sort(contacts, 0, MAX_CONTACT-1);
			index= Bin_search(name_holder,contacts,0,MAX_CONTACT-1);

			/* Contact not found if binary search return EOF */
			if( index == EOF )
			{
				fprintf(stderr,"\nError: No %s found.\n", name_holder);
				continue;
			}

			/* To delete or edit, phone number confirmation is needed */
			if (option=='2' || option=='3')
			{
				print_contact  (&contacts[index],1);

				printf("\nEnter %s's phone number\n>>", name_holder);
				
				fgets(phone_no,INPUT_SIZE-1,stdin);
				phone_no[strlen(phone_no)-1]='\0';
			}	
		}

		/* link option returned from menu() to appropriate function */
		switch(option)
		{
			case '0': print_contact  (contacts,MAX_CONTACT);
				break;
			case '1': add_contact	 (contacts);
				break;

			case '2': delete_contact (&contacts[index],phone_no);
				break;

			case '3': edit_contact   (contacts,&contacts[index],phone_no);
				break;

			case '4': search_contact (&contacts[index]);
				break;

			case '5': sort_contacts	 (contacts);
				break;

			/* Before exiting the update is saved to a file */
			case '6': write_to_file(update_file,contacts);
					  printf("\nExit Sucess!!\n\n");
					  return 0;	
				
			default : fprintf(stderr,"\nError: Invalid option!\n"
									 "Enter a digit between"
				       				 " 1 and 6 from the menu.\n");

		}/* end switch */	
	} 
	while ( option != '6'); /* end do-while*/
}/* end main() */
