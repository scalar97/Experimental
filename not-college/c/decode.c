/* simple c program that uses xor cipher to encrypt/decrypt a file with a password
 * e.g ./prog_name password ./secret_file
 */

#include<stdio.h>
#include<stdlib.h>

enum {PROG_NAME, PASSWORD, INPUT_FILE, ARG_NUM};

void usage(char* prog_name)
{printf("\nUsage: %s password finename\n\n", prog_name);}

int main(int argc, char **argv){
    FILE *fp;
    char *password;
    
    if (argc == ARG_NUM && (password = argv[PASSWORD]) ) {
	if((fp = fopen(argv[INPUT_FILE], "rb")) != NULL) {
	    fseek(fp, 0L, SEEK_END);
	    const long SIZE = ftell(fp);
	    char *buffer = calloc(SIZE, 1);
	    rewind(fp);
	    fread(buffer, 1, SIZE, fp);
	    for(long i = 0; i < SIZE; i++){
		if (!*password) password = argv[PASSWORD];
		buffer[i] ^= *(password++);
	    }
	    fp = freopen(argv[INPUT_FILE], "wb", fp);
	    fwrite(buffer, 1, SIZE, fp);
	    fclose(fp);
	    free(buffer);
	    return 0;
	}
    }
    usage(argv[PROG_NAME]);
    return 1;
}
