/*
Program Description : sramble and unscramble any given file

Date				: 22/04/2017
Group Members  : Daniel Orange, Tatiana Zihindula
Implemented by : Tatiana Zihindula
*/


#include "functions.h"
/* All functions are implemented in functions.h */


int main(int argc, char *argv[])
{
	char flag = 0;
	int prog_status;
	long int file_size;
	FILE *fp;


	/**** Stage 1: error checking comand line arguments  ****/

	if ((check_args(argc, argv)) == NOTHING)
		return 0;
	else if ( (fp = fopen(argv[FILE_ARG], "rb")) == NULL)
	{
		/* the system error will be specified accordingly */
		perror("Error on given file "); 
		return 0;
	}



	/**** Stage 2: Correct flag + existing file  ****/

	/* the file to scramble or unscamble must have at leat 2 bytes */
	if ( (file_size = get_file_size(fp, &file_size)) == EOF)
	{
		fclose(fp);
		return 0;  /* to avoid reading after EOF */
	}




	/**** Stage 3 : file size is more than 1 byte  ****/

	/**** SCRAMBLING OR UNSCRAMBLING STARTS  ****/

	prog_status = NOTHING;
	flag = argv[FILE_ARG - 1][0]; //use the first character of the option choosen

	switch (flag)
	{
	case 's': prog_status = scramble(argv[FILE_ARG], fp, file_size, flag);
		break;

	case 'u': prog_status = unscramble(argv[FILE_ARG], fp, file_size);
		break;
	}



	/**** Stage 4 : Exiting the program...****/

	/**** SCRAMBLING OR UNSCRAMBLING HAS COMPLETED OR FAILED  ****/
	if (prog_status != SUCCESS)
	{
		fprintf(stderr, "\nError: Unable to %s %s.\n",
		        argv[FLAG], argv[FILE_ARG]);

		fclose(fp); /* on success this stream is closed by scramble() */
	}

	return 0;
}
