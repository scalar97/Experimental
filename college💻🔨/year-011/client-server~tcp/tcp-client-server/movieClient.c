#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "practical.h"

int main(int argc, char *argv[]) {
	char recvbuffer[BUFSIZE], sendbuffer[BUFSIZE], request_resp[20], balance_msg[20]; // text buffers
	int scanfRtn = 0, numBytes = 0, credit = 0, balance =0, charge_req = 10;
	ssize_t numBytesSent;

	if (argc < 3) // Test for correct number of arguments
    DieWithUserMessage("Parameter(s)",
        "<Server Address> <Server Port>");

	char *servIP = argv[1];     // First arg: server IP address (dotted quad)

	in_port_t servPort = atoi(argv[2]);

	// Create a reliable, stream socket using TCP
	int sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (sock < 0)
		DieWithSystemMessage("socket() failed");

	// Construct the server address structure
	struct sockaddr_in servAddr;            // Server address
	memset(&servAddr, 0, sizeof(servAddr)); // Zero out structure
	servAddr.sin_family = AF_INET;          // IPv4 address family

	// Convert IP address
	int rtnVal = inet_pton(AF_INET, servIP, &servAddr.sin_addr.s_addr);
	if (rtnVal == 0)
		DieWithUserMessage("inet_pton() failed", "invalid address string");
	else if (rtnVal < 0)
		DieWithSystemMessage("inet_pton() failed");

	servAddr.sin_port = htons(servPort);    // Server port

  // Establish the connection to the movieServer
	if (connect(sock, (struct sockaddr *) &servAddr, sizeof(servAddr)) < 0)
		DieWithSystemMessage("connect() failed");

		snprintf(sendbuffer, sizeof(sendbuffer), "MOVIE_REQUEST: %d\r\n\r\n", charge_req);

		numBytesSent = send(sock, sendbuffer, strlen(sendbuffer), 0);
		if (numBytesSent < 0)
			DieWithSystemMessage("send() failed");

		while ((numBytes = recv(sock, recvbuffer, BUFSIZE - 1, 0)) > 0) {

		if(strstr(recvbuffer, "\r\n\r\n") > 0)
				break;
		}
		if (numBytes < 0)
			DieWithSystemMessage("recv() failed");

		sscanf(recvbuffer, "%s\r\n%s %d\r\n\r\n", request_resp, balance_msg, &balance); // message expected is of the form 
											//MOVIE_GRANTED\r\nCURRENT_BALANCE: %d\r\n\r\n
											//or, MOVIE_REJECTED\r\nCURRENT_BALANCE: %d\r\n\r\n
		if (strcmp(request_resp, "MOVIE_GRANTED") == 0)
		{
		printf("\nYou can download your movie.  Your new balance is: %d\n\n", balance); 
		}   //end If
		else
		{
		printf("\nYou do not have enough credit.  Please top-up your account.\n\n"); 

		do{

		printf("\nEnter top-up amount  (minimum is 10 credits): ");

		while((scanfRtn = scanf("%d", &credit)) != 1) // checking for non-numeric values
		{
		printf("\rEnter a numeric value: ");
		getchar();		  //eliminating non-numeric values
		}

		} while(credit < 10);  //end user-entry do-while loop

		memset(sendbuffer, 0, BUFSIZE); //initialze sendbuff to all zeroes before use
		snprintf(sendbuffer, sizeof(sendbuffer), "TOP_UP: %d\r\n\r\n", credit);

		numBytesSent = send(sock, sendbuffer, strlen(sendbuffer), 0);

		if (numBytesSent < 0)
			DieWithSystemMessage("send() failed");
		}  //end Else

	fputc('\n', stdout); // Print a final linefeed

	close(sock); //close the connected socket
	exit(0);  //exit the program gracefully
}
