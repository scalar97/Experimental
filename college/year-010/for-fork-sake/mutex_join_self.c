    #include <stdio.h>
    #include <pthread.h>
	
/*

	code found at: http://www.cs.cmu.edu/afs/cs/academic/class/15492-f07/www/pthreads.html
	
	expected output
	
	 Compile: cc -lpthread join1.c
	Run: ./a.out
	Results:

    Thread number 1026
    Thread number 2051
    Thread number 3076
    Thread number 4101
    Thread number 5126
    Thread number 6151
    Thread number 7176
    Thread number 8201
    Thread number 9226
    Thread number 10251
    Final counter value: 10

*/

    #define NTHREADS 10
    void *thread_function(void *);
    pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;  // default declaration 
    int  counter = 0;

    main()
    {
       pthread_t thread_id[NTHREADS];
       int i, j;

       for(i=0; i < NTHREADS; i++)
       {
          pthread_create( &thread_id[i], NULL, thread_function, NULL );
       }

       for(j=0; j < NTHREADS; j++)
       {
          pthread_join( thread_id[j], NULL); 
       }
      
       /* Now that all threads are complete I can print the final result.     */
       /* Without the join I could be printing a value before all the threads */
       /* have been completed.                                                */

       printf("Final counter value: %d\n", counter);
    }

    void *thread_function(void *dummyPtr)
    {
       printf("Thread number %ld\n", pthread_self());
       pthread_mutex_lock( &mutex1 );
       counter++;
       pthread_mutex_unlock( &mutex1 );
    }

