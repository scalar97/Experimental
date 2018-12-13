#include <stdio.h>
#include <string.h>

#ifndef MY_STRUCT_TEMPLATE
#define MY_STRUCT_TEMPLATE
#include "contact_struct_template.h"
#endif

#ifndef MAX_CONTACT
#define MAX_CONTACT 8
#endif

void merge_sort(CONTACT[], int, int);
void merge(CONTACT [], int , int , int );
int Bin_search(char *, CONTACT [], int , int );


/* Implementing merge_sort */

void merge_sort(CONTACT contacts[], int low, int high)
{
    int mid;
    if (low < high)
    {
        mid = low+(high-low)/2;
        merge_sort(contacts, low, mid);

        merge_sort(contacts, mid+1, high);
        
        merge(contacts, low, mid, high);
    }
    return;
}


/* implementing merge */

void merge(CONTACT contacts[], int low, int mid, int high)
{
    int size= ((mid-low)+(high-mid)+1);
    CONTACT temp[size];     //size of contacts from each call[]

    int i = low;
    int j = mid+1;
    int k = 0;

    while(i <= mid && j <= high)
    {
        /* comparing the string's ascii values
           strcmp return >0 if the first string is bigger
           returns <0 if the second string is bigger
           else, return 0 if both are similar */
        if((strcmp(contacts[i].name, contacts[j].name)) <=0)
        {
            temp[k] = contacts[i];    
            i++;
        }
        else
        {
            temp[k] = contacts[j];
            j++;
        }
        k++;
    }
    
    /* adding the remain elements if any */
    while(i <= mid)
    {
        temp[k] = contacts[i];
        i++;
        k++;
    }
    
    /*  adding the remaining elements if any */
    while(j <= high)
    {
        temp[k] = contacts[j];
        k++;
        j++;
    }
    for(i=high; i >= low; i--)
    {
        --k;
        contacts[i] = temp[k]; /* copying back sorted temp into main array */      
    }     
}


/* Implemanting binary search */

int Bin_search(char *word, CONTACT contacts[], int low, int high)
{
	if (high >= low)
	{
		int mid = (low + high) / 2;

		if ((strcmp(word,contacts[mid].name)) ==0)
			return mid; /* if found return index */
		else if ((strcmp(word, contacts[mid].name)) < 0) /* if inferior search to the left */
			return Bin_search(word, contacts, low, mid - 1);
		else /* else search to the right */
			return Bin_search(word, contacts, mid + 1, high);
	}
	return EOF;
}
