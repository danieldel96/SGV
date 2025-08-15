instrreset;
s=serial('com3','baudrate',9600) ;
fopen(s) ;%Open Com Port
while(1)
    while(1)
        Head = fread(s,2,'uint8');
        if (Head(1)~=uint8(85))
            continue;
        end
        switch(Head(2))
            case 81 
                a = fread(s,3,'int16')/32768*16; 
                End = fread(s,3,'uint8');
            case 82 
                w = fread(s,3,'int16')/32768*2000;     
                End = fread(s,3,'uint8');
            case 83 
                A = fread(s,3,'int16')/32768*180;
                roll = A(2)
                End = fread(s,3,'uint8');
                break;
        end
    end
end
fclose(s);