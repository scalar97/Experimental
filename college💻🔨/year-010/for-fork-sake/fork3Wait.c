 /*  variation of program can be found at: http://www.csl.mtu.edu/cs4411.ck/www/NOTES/process/fork/create.html */


#include  <stdio.h>
#include  <unistd.h>
#include  <sys/types.h>
#include <sys/wait.h>

#define   MAX_COUNT  200

void  ChildProcess(void);                /* child process prototype  */
void  ParentProcess(void);               /* parent process prototype */

void  main(void)
{
     pid_t  pid;
	 

     pid = fork();
     if (pid == 0) 
          ChildProcess();
     else 
	 {
          ParentProcess();
		  
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
     int   i;
	
	 pid_t  pid;
	 int status;	
	 
     //sleep(1);    // the parent is put to sleep for 1 sec 
     pid = wait(&status);  // parent will wait for the child 
 	 
     for (i = 1; i <= MAX_COUNT; i++)
          printf("This line is from parent, value = %d\n", i);
     printf("*** Parent is done ***\n");
}
