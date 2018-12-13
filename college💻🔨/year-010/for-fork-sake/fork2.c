 /* program can be found at: http://www.csl.mtu.edu/cs4411.ck/www/NOTES/process/fork/create.html */

#include <unistd.h> // fork function, and wait
#include <stdio.h>
#include <string.h>

void child_process_routine(char *file_name);
void parent_process_routine(char *name, int counter);
int main(void)
{
	pid_t process_id;
	process_id = fork();

	if(process_id == 0)
	{
		//This means that a child process was created.
		child_process_routine("file_created_in_child_routine.txt");
	}
	else
    {
		// -1 was returned to thie parent an no child was created
		parent_process_routine("hello", 100);
	}
	return 0;
}

void child_process_routine(char * new_file)
{
	FILE* fp = fopen(new_file, "w");
	int line_size = 500;
	char lines [line_size];

	if(fp != NULL)
	{
		char my_char;
		int i=0;
		while (((my_char = fgetc(stdin)) != EOF) && i< line_size)
        {
			lines[i] = my_char;
			i++;
			printf("runed %d times\n",i);
		}
		printf("Child process just done hihi\n");
		fwrite(lines, sizeof(char), strlen(lines), fp);
		fclose(fp);
	}
}

void parent_process_routine(char * name, int counter)
{
	for(int i=0; i< counter; i++)
    {
		printf("Hello %s %d time(s) :D\n", name, i);
	}
	printf("--I am the parent and I am just done hihi\n");
}
