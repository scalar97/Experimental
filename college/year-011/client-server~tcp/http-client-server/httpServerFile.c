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

    FILE* succ = fopen("./index.html", "r");
    FILE* fail = fopen("./error.html", "r");
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
	// capture the client's IP address
	struct sockaddr_in cliaddr; //new address structure
	socklen_t clntAddrLen = sizeof(cliaddr); // hold the lenght of the struct type socketaddr_in
	char clntName [INET_ADDRSTRLEN]; // to hold the client's address name
	
	int clnSock = accept(servSock, (struct sockaddr *) &cliaddr, &clntAddrLen);
	if (clnSock < 0){
	    DieWithSystemMessage("Accept() failed");
	}	
	printf("connection from %s, port %d\n", inet_ntop(AF_INET, &cliaddr.sin_addr, clntName, sizeof(clntName)), ntohs(cliaddr.sin_port)); //print out client address
	
	// connection to client was established
	int numBytes = 0;
	ssize_t numBytesSent = 0;
	char cmd[NAME_SIZE] = {'\0'};
	char path[NAME_SIZE] = {'\0'};
	char vers[NAME_SIZE] = {'\0'};
	rewind(succ);
	rewind(fail);
	while((numBytes = recv(clnSock, recvbuffer, BUFSIZE -1,0)) > 0) {
	    recvbuffer[numBytes] = '\0';
	    if (strstr(recvbuffer, "\r\n") > 0) break;
    	}
	sscanf(recvbuffer, "%s %s %s", cmd, path, vers);
	if (strcmp(path, "/") == 0) {
	    fread(sendbuffer, 1, sizeof(sendbuffer), succ);
	} else {
	    fread(sendbuffer, 1, sizeof(sendbuffer), fail);
	}
	numBytesSent = send(clnSock, sendbuffer, strlen(sendbuffer), 0);
	if (numBytesSent < 0) DieWithSystemMessage("send() html failled");
	
	if (numBytes < 0) {
	    DieWithSystemMessage("recv() failed");
    	}
	close(clnSock); // close client socket
    }
    fclose(succ);
    fclose(fail);
}
