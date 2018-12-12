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
	ssize_t numBytesSent = 0;
	char cmd[NAME_SIZE] = {'\0'};
	char path[NAME_SIZE] = {'\0'};
	char vers[NAME_SIZE] = {'\0'};
	while((numBytes = recv(clnSock, recvbuffer, BUFSIZE -1,0)) > 0) {
	    recvbuffer[numBytes] = '\0';
	    if (strstr(recvbuffer, "\r\n") > 0) {
		sscanf(recvbuffer, "%s %s %s", cmd, path, vers);
		if (strcmp(path, "/") == 0) {
		    snprintf(sendbuffer, sizeof(sendbuffer), "%s\r\n", HOME_PAGE);
		} else {
		    snprintf(sendbuffer, sizeof(sendbuffer), "%s\r\n", ERROR_PAGE);
		}
		numBytesSent = send(clnSock, sendbuffer, strlen(sendbuffer), 0);
		if (numBytesSent < 0) DieWithSystemMessage("send() Time failled");
		break;
	    }
    	}
	if (numBytes < 0) {
	    DieWithSystemMessage("recv() failed");
    	}
	close(clnSock); // close client socket
    }
}
