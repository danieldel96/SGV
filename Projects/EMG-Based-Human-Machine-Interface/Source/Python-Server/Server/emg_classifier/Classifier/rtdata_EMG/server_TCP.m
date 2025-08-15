clear all

t_server = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');
% t_server.OutputBufferSize = 6400;
t_server.InputBufferSize = 4000;

fopen(t_server);

% pause(5)

for i=1:10
pause(5)
data = fread(t_server, t_server.BytesAvailable);
f = plot(data);
end

disp('Finished')
fclose(t_server); 


