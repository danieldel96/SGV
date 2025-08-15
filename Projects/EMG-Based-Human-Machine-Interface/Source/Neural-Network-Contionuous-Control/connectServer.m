%Connect Python Server

global DATA_PUB interfaceObjectEMG rateAdjustedEmgBytesToRead t_client commObject Fs window publish;
HOST_IP = 'localhost';

if strcmp(DATA_PUB,'ON')
    t_client = tcpip('127.0.0.1', 8080, "NetworkRole","client");
    try
         fopen(t_client);
         disp('Connected!');
    catch ME
        error(ME)
        return
    end

end