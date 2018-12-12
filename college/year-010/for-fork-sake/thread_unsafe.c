/*****************************************************************************
* FILE: hello_arg3.c
* DESCRIPTION:
*   This "hello world" Pthreads program demonstrates an unsafe (incorrect)
*   way to pass thread arguments at thread creation.  In this case, the
*   argument variable is changed by the main thread as it creates new threads.
* AUTHOR: Blaise Barney
* LAST REVISED: 07/16/14
******************************************************************************/
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#define NUM_THREADS 10

void *PrintHello(void *threadid)
{
   long taskid;
   // evrytime this function is called it is set to sleep for one minut.
   // this cause the process scheduler to give priority to other
   // tasks of the program 
   sleep(1);// this sleep will cause all the other processes to finish.
   taskid = *(long *)threadid; // the containt of the address contained into threadid. this is a deference
   printf("Hello from thread %ld\n", taskid);
   pthread_exit(NULL);
}

int main(int argc, char *argv[])
{
	pthread_t threads[NUM_THREADS];


	for(long i=0; i<NUM_THREADS;i++) 
	{
		printf("Creating thread %ld\n", i);
		int return_code = pthread_create(&threads[i], NULL, PrintHello, (void *) &i);
		if (return_code) 
		{
		  printf("ERROR; return code from pthread_create() is %d\n", return_code);
		  exit(-1);
		}
	}

	pthread_exit(NULL);
}
