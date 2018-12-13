/* simple xor cipher to encrypt a file using a password
 */

#include<stdio.h>
#include<stdlib.h>

enum { PASSWORD = 1, IN_FILE, ARG_NUM};

void usage(char*exe)
{printf("Usage: %s password finename\n", exe);}

int main(int argc, char **argv){
    FILE *fp;
    char *password;
    
    if (argc == ARG_NUM && (password = argv[PASSWORD]) ) {
	if((fp = fopen(argv[IN_FILE], "rb")) != NULL) {
	    fseek(fp, 0L, SEEK_END);
	    const long SIZE = ftell(fp);
	    char *buffer = calloc(SIZE, 1);
	    rewind(fp);
	    fread(buffer, 1, SIZE, fp);
	    fp = freopen(argv[IN_FILE], "wb", fp);
	    for(long i = 0; i < SIZE; i++){
		if (!*password) password = argv[PASSWORD];
		buffer[i] ^= *(password++);
	    }
	    fwrite(buffer, 1, SIZE, fp);
	    fclose(fp);
	    free(buffer);
	    return 0;
	}
    }
    usage(argv[0]);
    return 1;
}
