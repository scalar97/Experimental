 /*  variation of program can be found at: http://www.csl.mtu.edu/cs4411.ck/www/NOTES/process/fork/create.html */


#include<stdio.h>
#include<unistd.h>
#include <sys/types.h>
#include <wait.h>

#define   MAX_COUNT  100

void  ChildProcess(void);                /* child process prototype  */
void  ParentProcess(void);               /* parent process prototype */

void  main(void)
{
     pid_t  pid;
	 int status;

     pid = fork();
     if (pid == 0)
	 {
          ChildProcess();
	 }
     else 
	 {
          ParentProcess();
		  pid = wait(&status);
		  // on sucess, returns the process ID of the child that has terminated. else, returns -1
		  // must include wait.h>
		  pid = wait(&status);
	 }	  
}

void  ChildProcess(void)
{
     int   i;

     for (i = 1; i <= MAX_COUNT; i++)
          printf("   This line is from child, value = %d\n", i);
     printf("   *** Child process is done ***\n");
}

void  ParentProcess(void)
{
	int   i, status;
//	pid_t process_id = wait(&status);
		 
     for (i = 1; i <= 200; i++)
          printf("This line is from parent, value = %d\n", i);
     printf("*** Parent is done ***\n");
}
