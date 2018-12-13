#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>


/* example found at:  http://www.cs.cmu.edu/afs/cs/academic/class/15492-f07/www/pthreads.html */


/*

 Compile: cc -lpthread mutex1.c
Run: ./a.out
Results:

    Counter value: 1
    Counter value: 2

When a mutex lock is attempted against a mutex which is held by another thread, the thread is blocked until the mutex is unlocked. 
When a thread terminates, the mutex does not unless explicitly unlocked. Nothing happens by default.

*/

void *functionC();
pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;
int  counter = 0;

main()
{
   int rc1, rc2;
   pthread_t thread1, thread2;

   /* Create independent threads each of which will execute functionC */

   if( (rc1=pthread_create( &thread1, NULL, &functionC, NULL)) )
   {
      printf("Thread creation failed: %d\n", rc1);
   }

   if( (rc2=pthread_create( &thread2, NULL, &functionC, NULL)) )
   {
      printf("Thread creation failed: %d\n", rc2);
   }

   /* Wait till threads are complete before main continues. Unless we  */
   /* wait we run the risk of executing an exit which will terminate   */
   /* the process and all threads before the threads have completed.   */

   pthread_join( thread1, NULL);
   pthread_join( thread2, NULL); 

   exit(0);
}

void *functionC()
{
   pthread_mutex_lock( &mutex1 );
   counter++;
   printf("Counter value: %d\n",counter);
   pthread_mutex_unlock( &mutex1 );
}