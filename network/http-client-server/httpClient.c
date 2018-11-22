#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "practical.h"

int main(int argc, char** argv) {
    char recvbuffer[BUFSIZE];
    char sendbuffer[BUFSIZE];
    int numBytes = 0;

    if (argc != 4) {
	DieWithUserMessage("Parameters(s)","<Server Address> <Server Port> <Page relative URL>");
    }
    char *servIP = argv[1]; // Website's IP address, e.g ping website.foo
    in_port_t servPort = atoi(argv[2]); // HTTP listens to port 80
    // save requested ressouce eg. index.html
    snprintf(sendbuffer, sizeof(sendbuffer), "%s\r\n\r\n", argv[3]);
    printf("the request is\n%s", sendbuffer);
    // connect the send socket to the TCP layer
    int sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (sock < 0) {
	DieWithSystemMessage("Socket() Failed");
    }
    struct sockaddr_in servAddr;
    memset(&servAddr, 0, sizeof(servAddr));
    servAddr.sin_family = AF_INET;

    int rtnVal = inet_pton(AF_INET, servIP, &servAddr.sin_addr.s_addr);
    if (rtnVal == 0){
		DieWithUserMessage("inet_pton()","invalid IP address string");
    } else if (rtnVal < 0) {
		DieWithSystemMessage("inet_pton(): Error occured when formatting IP address string");
    }
    servAddr.sin_port = htons(servPort);
    if(connect(sock,(struct sockaddr *) &servAddr, sizeof(servAddr)) < 0) {
	DieWithSystemMessage("Connect() failed");
    }
    ssize_t numBytesSent = send(sock, sendbuffer, strlen(sendbuffer), 0);
    if (numBytesSent < 0) {
	DieWithSystemMessage("send() failled");
    }
    while((numBytes = recv(sock, recvbuffer, BUFSIZE -1,0)) > 0){
	recvbuffer[numBytes] = '\0';
	fputs(recvbuffer, stdout); // print the echo buffer
    }
    if (numBytes < 0) {
	DieWithSystemMessage("recv() failed");
    }
    fputc('\n', stdout);
    close(sock);
    exit(0);
}
