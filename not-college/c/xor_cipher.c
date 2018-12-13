/* using simple xor cipher or otherwise, design an algorithm that 
 * requires a secret key to encrypt a file 
 *
 * Author : Tatiana Zihindula
 */

#include<stdio.h>
#define ARG_SIZE 4

enum { KEY = 1, I_FILE, O_FILE};

void usage(char*exe)
{printf("Usage: %s key inFile outFile\n", exe);}

int main(int argc, char **argv)
{
	FILE *input_fp, *output_fp;
	char *key;
	int ascii_char;
	
	if (argc == ARG_SIZE && (key = argv[KEY]) )
	{
		if((input_fp = fopen(argv[I_FILE], "rb")) != NULL && \
          (output_fp = fopen(argv[O_FILE], "wb")) != NULL)
		{
		    while ((ascii_char = getc(input_fp)) != EOF)
			{
				if (!*key) key = argv[1]; // if (*key == '\0'),rewind.
				ascii_char ^= *(key++);   // ^ the letter with *key
				
				putc(ascii_char, output_fp);
			}
			fclose(input_fp); fclose(output_fp);
			return 0;
		}	
	}
	usage(argv[0]);
	return 1;
}
