
#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define NITER 1000000

int cnt = 0;

/* declare a semaphore */ 
sem_t  mutex;

void * Count(void * a)
{
    int i, tmp;

    int t = (int)a; 

    /* lock the mutex */

  //  printf(" about to block the mutex\n");

    sem_wait(&mutex);

    printf(" the mutex is now locked by thread %d \n", t);				
    for(i = 0; i < NITER; i++)
    {
       
		
	tmp = cnt;      /* copy the global cnt locally */
        tmp = tmp+1;    /* increment the local copy */
        cnt = tmp;      /* store the local value into the global cnt */ 
		
		
    }
	
	printf("unlocking the mutex\n");
	sem_post(&mutex);

	printf(" the mutex is unlocked by thread %d\n",t);

	
	/* code to exit a thread correctly */ 
	pthread_exit( NULL );
	
        return NULL;
}

int main(int argc, char * argv[])
{
    pthread_t tid1, tid2;
    int t1 =1, t2 =2;

     // initalize the mutex

    sem_init(&mutex, 0, 1);		

    if(pthread_create(&tid1, NULL, Count, (void *)t1 ))
    {
      printf("\n ERROR creating thread 1");
      exit(1);
    }

    if(pthread_create(&tid2, NULL, Count, (void *)t2))
    {
      printf("\n ERROR creating thread 2");
      exit(1);
    }

    if(pthread_join(tid1, NULL))	/* wait for the thread 1 to finish */
    {
      printf("\n ERROR joining thread");
      exit(1);
    }

    if(pthread_join(tid2, NULL))        /* wait for the thread 2 to finish */
    {
      printf("\n ERROR joining thread");
      exit(1);
    }

    if (cnt < 2 * NITER) 
        printf("\n BOOM! cnt is [%d], should be %d\n", cnt, 2*NITER);
    else
        printf("\n OK! cnt is [%d]\n", cnt);
  
    pthread_exit(NULL);
}

