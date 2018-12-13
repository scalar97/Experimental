A client-server implementation that uses sockets to send data between a client and a server using the TCP layer.

## Usage

1. Compile everything.
```
$ ./compile
```
2. Run the server binary on a port number. e.g 5000, if 5000 is in use try 5001 etc.
```
$ ./helloServer.out <port-number>
```
3. In another terminal window, cd to current $PWD, then make a request to the server 
by specifying the IP address on which the server is running, localhost(127.0.0.1) in this case,
followed by the port number used to run the server, then your name afterwards as a string argument. 
"Foo Bar" in my case. Nice to meet you btw!
```
$ ./helloClient.out 127.0.0.1 <port-number> "Foo Bar"
```

## Output

1. On the server's side
```
Hello, Foo bar!

```
2. From the other side
```
Server: received "Foo bar" - Thu Jan  1 01:00:00 1970
```

## Reflection
If a server was a circle, and a client a sphere, how would we know which side is the client's side and which one is the server's side? 🤔