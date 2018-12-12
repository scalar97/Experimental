
#define INPUT_SIZE 50

/* 

CONTACT: hold the contact details of the contact listmembers.

    - name_text    : ascii characters of the name in textual form
    - phone number : size chan changed based on geographical location
    - empty_spot   : array initialiser
*/
typedef struct contact_details
{
	char name [INPUT_SIZE];
	char phone_number [INPUT_SIZE];
	char email [INPUT_SIZE];
	int  empty_spot;
}CONTACT;
