 #include<stdio.h>
#include <pthread.h>
#include<stdlib.h>
#define NUM_OF_THREADS 5

void *printHello(void *thread_id)
{
	long tid;
	tid = (long) thread_id;
	//printf("Thread_id=%p, tid=%ld\n",thread_id,tid);
	printf("hello from thread #%ld!\n", tid);

	pthread_exit(NULL);
}

int main()
{
	pthread_t threads[NUM_OF_THREADS]; // array of threads
	int return_code;
	int i;

	for(i=0; i<NUM_OF_THREADS; i++)
    {
		printf("In main: creating thread %ld\n", i);
		return_code = pthread_create(&threads[i],NULL,printHello,(void*) i);
		if(return_code) // pthread_create should return 0 on sucess
		{
			printf("Error: return code from pthread_create is %d\n", return_code);
			exit(-1);
		}
	}
	pthread_exit(NULL);
}
