#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "practical.h"
#include <time.h>

static const int MAXPENDING = 5; // maximum outstanding request

int main(int argc, char ** argv) {
    time_t ticks;
    char sendbuffer[BUFSIZE];
    char recvbuffer[BUFSIZE];

    if (argc != 2){
		DieWithUserMessage("Parameter(s)", "<Server Port>");
    }
    in_port_t servPort = atoi(argv[1]);

    int servSock; // socket descriptor for server
    if ((servSock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0){
		DieWithSystemMessage("Socket() failed");
    }
    // Construct local address structure
    struct sockaddr_in servAddr;                 // Local address
    memset(&servAddr, 0, sizeof(servAddr));      // Zero out structure
    servAddr.sin_family = AF_INET;               // Ipv4 address structure
    servAddr.sin_addr.s_addr = htonl(INADDR_ANY);// Any incoming interface
    servAddr.sin_port = htons(servPort);         // local port

    // Bind to local address
    if (bind(servSock, (struct sockaddr*) &servAddr, sizeof(servAddr)) <0){
		DieWithSystemMessage("bind() failed");
    }
    if (listen(servSock, MAXPENDING) < 0) {
		DieWithSystemMessage("listen() failed");
    }
    // listen forever
    for(;;) {
		int clnSock = accept(servSock, (struct sockaddr *) NULL, NULL);
		if (clnSock < 0){
	    	DieWithSystemMessage("Accept() failed");
		}
		// connection to client was established
		int numBytes = 0;
		char name[NAME_SIZE] = {'\0'};

		while((numBytes = recv(clnSock, recvbuffer, BUFSIZE -1,0)) > 0){
			recvbuffer[numBytes] = '\0';
			strncat(name, recvbuffer, NAME_SIZE - strlen(name));
			if (strstr(recvbuffer, "\r\n") > 0){
				name[strlen(name) - strlen("\r\n")] = '\0';
				fputs("\nHello, ", stdout);
				fputs(name, stdout);
				fputs("!\n", stdout);
				break;
			}
    	}
	    if (numBytes < 0) {
			DieWithSystemMessage("recv() failed");
    	}
		ssize_t numBytesSent = 0;
		snprintf(sendbuffer, sizeof(sendbuffer), "Server: received \"%s\" - ", name); // format name log
		numBytesSent = send(clnSock, sendbuffer, strlen(sendbuffer), 0); // send name first
		if (numBytesSent < 0) DieWithSystemMessage("send() Name failled");

		// make another send: PROOF OF CONCEPT that two send() can be done sequentially.
		snprintf(sendbuffer, sizeof(sendbuffer), "%.24s\r\n", ctime(&ticks)); // format time log
		numBytesSent = send(clnSock, sendbuffer, strlen(sendbuffer), 0); // send date and time str
		if (numBytesSent < 0) DieWithSystemMessage("send() Time failled");

		// cleanup for next client
		name[0] = '\0'; // reset name, cheaper than memset()
		close(clnSock); // close client socket
	}
	/*
	recev()  return codes
	<0 : error condition: caught in an if statement
	>0 : the connection is still open and there is still data to to receive, this  data is coming from the TCP layer that has but it inside its send buffer.
	=0 : the connection  is closed.
	if (strstr(recevbuffer, "\r\n") > 0) break; // the http will end with "\r\r\n\n"
	*/
}
