instrreset;
s=serial('com3','baudrate',9600) ;
fopen(s) ;%Open Com Port
while(1)
    data = fscanf(s)
%     pause(0.1)
end
    fclose(s);
