//  Author : Tatiana Zihindula
//  Date : 28 April 2017
// This header file contains all the functions , global variables and struture 
// templates that will be used inside this project

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#ifndef GLOBAL_SYMBOLICS
#define GLOBAL_SYMBOLICS

    #define MAX_ROOTS 3
    #define OPTION 1
    #define SNAME 2
    #define INPUT_SIZE 31

#endif

/* enumerated constants SUCCESS == 0 */
#ifndef RETURN_VALUES
#define RETURN_VALUES
    enum return_values {SUCCESS, NOTHING};
#endif


#ifndef STUDENT_STRUCT_TEMPLATE
#define STUDENT_STRUCT_TEMPLATE
/*STUDENT: hold the contact details of the contact listmembers.

    - fisrtname    : student's first name
    - surname      : student's surname
    - student_id   : student's tag and ID number 
                     * E : Funded Eu student
                     * N : Non funded Eu student
                     * T : International Student

    - *left        : STUDENT pointer to a surname alphabetically
                     inferior to the current surname

    - *right       : STUDENT pointer to a surname alphabetically 
                     inferior to the current surname

    - *middle      : STUDENT pointer to a surname alphabetically 
                     equal to the current surname (Same surname).
*/
typedef struct STUDENT
{
    char firstname [INPUT_SIZE];
    char surname [INPUT_SIZE];
    char student_id [INPUT_SIZE];
    char country [INPUT_SIZE];
    struct STUDENT *left;
    struct STUDENT *right;
    struct STUDENT *middle;

}STUDENT;

#endif

extern int check_args(int arg_c, char *[], char**);
extern char no_case_sensitive(char *[], char**);
extern void display_help(char *);

/* find_and_print.h */
extern void tree_print_all(STUDENT *);
extern void tree_print_one(STUDENT *[], char* );
extern void print_node(STUDENT *);
extern STUDENT* find(char *, STUDENT *);
extern void hash_mapping(char , STUDENT* []);

/* file_handling.h */
extern int load_from_file(STUDENT**, char*);
extern void add_child(STUDENT**, STUDENT*);
extern STUDENT* add_value(STUDENT**, STUDENT* );
extern void free_all_nodes(STUDENT* );

/* standard library functions */
extern int toupper(int c);
extern void *malloc(size_t size);
extern void free(void *ptr);
extern void *calloc(size_t nmemb, size_t size);
extern int strcmp(const char *s1, const char *s2);
extern char *strcpy(char *dest, const char *src);
