import socket
from sys import stdin
import threading
from datetime import timedelta
import struct
import numpy as np
import emg_classifier.Classifier.extractTDFeats as feat
from sklearn.model_selection import train_test_split
from joblib import dump, load
#import emg_classifier.Classifier.


class HMI_Server:
    def __init__(self, ip, args):
        self.EMG_SIG_PORT = 8080
        self.EMG_OUT_PORT = 8081
        self.IP = ip
        self.DATA_CHANNELS = 4
        self.MAX_CLIENTS = 2
        self.MODE = args #-s/-c

        #self.EMG_LDA = load('C:\\NSF-Project-Files\\emg-server-python\\Server\\emg_classifier\\Classifier\\models\\EMG_LDA.joblib')

        self.isShuttingDown = False
        self.senderClients = []
        
        self.receiver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.receiver.bind((ip, self.EMG_SIG_PORT))
        
        self.sender = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sender.bind((ip, self.EMG_OUT_PORT))
    
    #processThread = threading.Thread(target=processLine, args=[dRecieved])
    
    def start(self):
        obj = []
        tRecv = threading.Thread(target=self.StartReceiver)
        tSend = threading.Thread(target=self.StartSender)
        tRecv.start()
        tSend.start()
        #Thread tReceiver = new Thread(new ParameterizedThreadStart(StartReciever))
        t = stdin.readline()
        self.stop()
    def getHost(self):
        return self.IP
    
    def getPort(self):
        return self.EMG_SIG_PORT
    
    def stop(self):
        self.isShuttingDown = True
        self.sender.close()
        self.receiver.close()
        
    def StartReceiver(self):
        try:
            self.receiver.listen(10)
            count = 0
            
            #while(not self.isShuttingDown):
            print("Waiting for EMG Connection...")
            client, addr = self.receiver.accept()
            print("Connected to EMG.")
            
            
            try:
                if self.MODE == "-c":
                    print("TODO: CONTINUOUS")

                elif self.MODE == "-s":
                    while(not self.isShuttingDown):
                        #receive packets from matlab
                        chunk = client.recv(8)
                        prediction, magnitude = struct.unpack('!ff', chunk)
                        print(prediction, magnitude)
                        pred_int = int(prediction)
                                
                        #send to unity
                        tSend = threading.Thread(target=self.SendCommand, args=(pred_int,magnitude,))
                        tSend.start()

                else:
                    print("Invalid mode entered.")

                    #end while
            #try except
            except:
                client.close()
                
        except:
            print("Socket Exception")
            self.isShuttingDown = True
            self.receiver.close()
            
            
    def StartSender(self):
        try:
            self.sender.listen(10)
            while(not self.isShuttingDown):
                print("Waiting for Client Connection...")
                client, addr = self.sender.accept()
                print("Connected to Unity.")
                tSend = threading.Thread(target=self.HandleClient, args=(client,))
                tSend.start()

        except:
            print("Socket Exception")
            self.isShuttingDown = True
            self.sender.close()
            
    def HandleClient(self, obj):
        client = obj
        self.senderClients.append(client)
        #self.CleanUpClientList()
        
    def SendCommand(self, obj1, obj2):
        size = len(self.senderClients)
        for TCP_clients in range(size):
            obj_bytes = struct.pack('<id',obj1,obj2)
            #obj_bytes = obj.to_bytes(12,'little')
            try:
                self.senderClients[TCP_clients].send(obj_bytes)
            #if not remove
            except:
                del self.senderClients[TCP_clients]
                print("Connection aborted")

                
    def CleanUpClientList(self):
        for TCP_clients in self.senderClients:
            print('remove if not connected')
            #TODO: if not connected, remove from list
            # try: TCP_clients.send("")
            # except: TCP_clients.close()


    def Mode(self, input):
        if(self.MODE == "-s"):  
             return int(input[0])
        elif self.MODE == "-c":
            print("TODO: CONTINUOUS MODE")
            return int(input[0])
            
      
 