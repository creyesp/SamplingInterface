

function serverTest(port)

if ~exist('port','var'), port = 8888; end

sock=pnet('tcpsocket',port)
if(sock==-1), error('Specified TCP port is not possible to use now.'); end
pnet(sock,'setreadtimeout',1);

while 1,
    con=pnet(sock,'tcplisten');
    if( con~=-1 ),
        try,
            [ip,port]=pnet(con,'gethost');
            disp(sprintf('Connection from host:%d.%d.%d.%d port:%d\n',ip,port));
            pnet(con,'setreadtimeout',inf);
            headerRead = pnet(con,'read',6,'uint8')
            dataLenght = bitshift(headerRead(6),8) + headerRead(5)

            data = pnet(con,'read',dataLenght+1,'uint8')
            
            
            rMessage = [headerRead' data']
            sMessage = rMessage(1:end-1);
            sMessage(1) = sMessage+1;
            sMessage(end+1) = uint8(bitand(sum(sMessage),255));
            pnet(con,'write',sMessage);

            if uint8(bitand(sum(rMessage(1:end-1)),255)) ~= rMessage(end),
                display(['Checksum error: ' num2str(uint8(bitand(sum(rMessage(1:end-1)),255))) '!=' ...
                    num2str(rMessage(end))])
            else
                display('Checksum ok')
            end
            drawnow

            display('Message: ')
            display(rMessage)
            drawnow
        end
        pnet(con,'close');
        drawnow;
    end
end