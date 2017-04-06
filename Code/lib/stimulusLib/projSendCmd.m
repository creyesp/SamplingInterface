function error=projSendCmd(message,ip,port)

if ~exist('port','var'), port = 21845; end
if ~exist('ip','var'), ip = '192.168.1.100'; end

%c = tcpip(ip,port);
c = pnet('tcpconnect',ip,port);
if c == -1,
    display('Error')
    error = true;
    return
end

% try
%     fopen(c)
% catch me
%     display('Unable to connect with the LC3000 projector')
%     error = true;
%     return
% end

display('connected')

%fwrite(c,message,'uint8');
%elements=pnet(c,'write', message);
pnet(c,'write', message);
%display(['message sent: ' num2str(elements) '/' num2str(length(message))])

%headerRead = fread(c,6,'uint8');
headerRead = pnet(c,'read',6,'uint8')
dataLenght = bitshift(headerRead(6),8) + headerRead(5);

data = pnet(c,'read',dataLenght+1,'uint8')
%data = fread(c,dataLenght+1,'uint8');

rMessage = [headerRead data];

if uint8(bitand(sum(rMessage(1:end-1)),255)) ~= rMessage(end),
    display(['Checksum error: ' num2str(uint8(bitand(sum(rMessage(1:end-1)),255))) '!=' ...
        num2str(rMessage(end))])
else
    display('Checksum ok')
end

if headerRead(1) == message(1)+1,
    display('Command written');
else
    display(['Received packet type: ' num2str(headerRead(1))])
end

%fclose(c)
pnet(c,'close');
error = false;