

function byteArray = int2byteArray(value, nBytes)

byteArray = rem(floor(value.*256.^(1-nBytes:0)),256);
% [LSB...MSB] format
byteArray = fliplr(byteArray);