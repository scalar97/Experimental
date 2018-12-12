#include <stdio.h>
#include <string.h>

#ifndef MY_STRUCT_TEMPLATE
#include "contact_struct_template.h"
#endif
#ifndef MAX_CONTACT
#define MAX_CONTACT 8
#endif

void write_to_file(char[], CONTACT[]);
void load_from_file(char [],CONTACT []);


void load_from_file(char file_name[], CONTACT contacts[])
{
	int i=0;
	FILE* fp = fopen(file_name, "r");
	if (fp == NULL)
	{
		perror("Error: can't open the file ");
	}
	else
	{
		fseek(fp, 0, SEEK_SET);
		i = 0;
		while ( (fscanf(fp, "%s %s %s %d",
		                contacts[i].name,
		                contacts[i].phone_number,
		                contacts[i].email,
		                &contacts[i].empty_spot)) != EOF && 
						(i< MAX_CONTACT) )
		{
			i++;
		}
		fclose(fp);
	}
}


void write_to_file(char file_name[], CONTACT contacts[])
{
	FILE* fp = fopen(strcat(file_name, ".update"), "w");
	// long int contact_size= sizeof(contacts) / sizeof(contacts[0]);
	register int i = 0;

	if (fp == NULL)
	{
		perror("Error: changes made were not saved to file\n");
	}
	else
	{
		fseek(fp, 0, SEEK_SET);
		for (int i = 0; i < MAX_CONTACT; i++)
		{
			fprintf(fp,"%s %s %s %d\n",
			        contacts[i].name,
			        contacts[i].phone_number,
			        contacts[i].email,
			        contacts[i].empty_spot);

		}
	}
	fclose(fp);
}
