function error = setProjector(bitsDepth)
if ~exist('bitsDepth','var'), bitsDepth = 4; end

% See http://www.ti.com/lit/ug/dlpu007d/dlpu007d.pdf for references
% PktType |    CMD1   |   CMD2  | PktNmb | DataLenght1 | DataLenght2 | Data | Checksum
% Write   | FrameRate | Trigger | Single |    LSB      |    MSB      | ...
%  0x02   |    0x3C        |  0x04   |  0x00  | ...

error = false;

% Set HDMI
message = uint8([2 1 1 0 1 0 2]);
message(end+1) = uint8(bitand(sum(message),255)); % 7
error = error || projSendCmd(message);

% Set 60 Hz, 4 bit depth, RGB
message = uint8([2 2 1 0 3 0 60 bitsDepth 1]);
message(end+1) = uint8(bitand(sum(message),255)); % 73
error = error || projSendCmd(message);

% Set resolution to 608x684
message = uint8([2 2 0 0 12 0 96 2 172 2 0 0 0 0 96 2 172 2]);
message(end+1) = uint8(bitand(sum(message),255)); % 48
error = error || projSendCmd(message);

error = error || setTrigger(0);


