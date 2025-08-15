# Import socket module
import socket            
 
# Create a socket object
s = socket.socket()        
 
# Define the port on which you want to connect
port = 8080               
 
# connect to the server on local computer
s.connect(('0.0.0.0', port))
while(True):
    s.send('0000, 0000, 0000, 0000'.encode())
# receive data from the server and decoding to get the string.
print (s.recv(16).decode())
# close the connection
s.close()  