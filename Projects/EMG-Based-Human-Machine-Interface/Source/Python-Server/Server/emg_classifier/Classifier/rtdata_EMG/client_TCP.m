% instrreset
clear all
global t_client

t_client = tcpip('localhost', 30000, 'NetworkRole', 'client');
t_client.OutputBufferSize = 6400;

fopen(t_client);

data = rand(4,1000);
data = data(:);
fwrite(t_client, data)

t = timer;
t.ExecutionMode= 'fixedSpacing';
t.TimerFcn = @generate_signal;
t.TasksToExecute = 20;
start(t);

function generate_signal(~,~)
global t_client
data = rand(4,1000);
%[ones(1000,1),2*ones(1000,1),3*ones(1000,1),4*ones(1000,1)]'; %rand(1000,4);
data = data(:);
%plot(data);
fwrite(t_client, data)
end
