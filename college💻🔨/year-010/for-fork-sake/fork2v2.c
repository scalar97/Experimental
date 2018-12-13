 /* program can be found at: http://www.csl.mtu.edu/cs4411.ck/www/NOTES/process/fork/create.html */

#define RESET   "\033[0m"
#define BLACK   "\033[30m"      /* Black */
#define RED     "\033[31m"      /* Red */
#define GREEN   "\033[32m"      /* Green */
#define YELLOW  "\033[33m"      /* Yellow */
#define BLUE    "\033[34m"      /* Blue */
#define MAGENTA "\033[35m"      /* Magenta */
#define CYAN    "\033[36m"      /* Cyan */
#define WHITE   "\033[37m"      /* White */
#define BOLDBLACK   "\033[1m\033[30m"      /* Bold Black */
#define BOLDRED     "\033[1m\033[31m"      /* Bold Red */
#define BOLDGREEN   "\033[1m\033[32m"      /* Bold Green */
#define BOLDYELLOW  "\033[1m\033[33m"      /* Bold Yellow */
#define BOLDBLUE    "\033[1m\033[34m"      /* Bold Blue */
#define BOLDMAGENTA "\033[1m\033[35m"      /* Bold Magenta */
#define BOLDCYAN    "\033[1m\033[36m"      /* Bold Cyan */
#define BOLDWHITE   "\033[1m\033[37m"      /* Bold White */

#include  <stdio.h>
#include <unistd.h>
#include  <sys/types.h>



#define   MAX_COUNT  30

void  ChildProcess(int);                /* child process prototype  */
void  ParentProcess(int);               /* parent process prototype */

void  main(void)
{
     pid_t  pid;

     pid = fork();
 
	 if (pid == 0) 
          ChildProcess(getpid());
     else 
          ParentProcess(getpid());
}

// for(i=0; i<(0xFFFFFFFF);i++);   possibly required if running on putty. (purpose to increase the amount of computation  


void  ChildProcess(int pid)
{
     int   i;

     for (i = 1; i <= MAX_COUNT; i++)
          printf("   This line is from" RED" child" RESET", value = %s%d%s with pid= %s%d%s\n",BOLDGREEN, i,RESET, BOLDRED,pid,RESET);
     printf("   *** Child process is done ***\n");
}

void  ParentProcess(int pid)
{
	//sleep(1); // puts the parent to sleep to ensure that the child will finish processing
	// sleep function prototyped in unistd.h
	// This function causes the thread to sleep until the number of specified seconds or until a signal is released
 
     for (int i = 1; i <= MAX_COUNT; i++)
           printf("   This line is from"BLUE" parent"RESET", value = %s%d%s with pid= %s%d%s\n", BOLDBLUE,i,RESET, BOLDBLACK,pid,RESET);
     printf("*** Parent is done ***\n");
}
