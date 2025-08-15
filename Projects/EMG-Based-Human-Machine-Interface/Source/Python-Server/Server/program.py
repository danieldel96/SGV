import server
import sys

def main():
    
    args = 0
    try:
        args = sys.argv[1]
    except:
        args = "-s"
    if(args == "-s" or args == "-c"):
        EMG_server = server.HMI_Server("0.0.0.0", args)
        EMG_server.start()
        EMG_server.stop()
    else:
        print("Invalid argument.")

# Using the special variable 
# __name__
if __name__=="__main__":
    main()