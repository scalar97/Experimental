#include<pthread.h>
#include <stdio.h>
#include<stdlib.h>
/*   ************************************************************   */
/* Example program creating thread to compute square of value       */
/*  Jogn Gilligan notes: Threads and processes                      */
/* **************************************************************** */
 


int value;/* thread stores result here */
void *my_thread(void *param);		  /* the thread */

main (int argc, char *argv[])
{
	pthread_t tid;		/* thread identifier */
	int retcode;

	
	if (argc != 2) {
		fprintf (stderr, "usage: %s <integer value>\n", argv[0]);
		exit(0);
	}
/* create the thread */
	retcode = pthread_create(&tid,NULL,my_thread,argv[1]);
	if (retcode != 0) {
		fprintf (stderr, "Unable to create thread\n");
		exit (1);
	}

	/* wait for created thread to exit */
	pthread_join(tid,NULL);
	printf ("I am the parent: Square = %d\n", value);
} //main

/* The thread will begin control in this function */
void *my_thread(void *param)
{
	int i = atoi (param);

	printf ("I am the child, passed value %d\n", i);
	value = i * i;

	/* next line is not really necessary */
	pthread_exit(0);
}
