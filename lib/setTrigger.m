
function error = setTrigger(triggerWidth)

% triggerWidth [uS]
if ~exist('triggerWidth','var'), triggerWidth = 800; end

if triggerWidth == 0,
    message = uint8([2 4 4 0 11 0 0 0 0 0 0 0 0 0 0 0 0]);
else
    %tW = uint8([0 0 3 32]);
    tW = int2byteArray(triggerWidth,4)
    message = uint8([2 4 4 0 11 0 1 0 0 0 0 0 0 tW]);
end

%display(tW)

% See http://www.ti.com/lit/ug/dlpu007d/dlpu007d.pdf for references
% PktType |    CMD1        |   CMD2  | PktNmb | DataLenght1 | DataLenght2 | Data | Checksum
% Write   | PatterSequence | Trigger | Single |    LSB      |    MSB      | ...
%  0x02   |    0x04        |  0x04   |  0x00  | ...


% Adding checksum
message(end+1) = uint8(bitand(sum(message),255));

error = projSendCmd(message);
