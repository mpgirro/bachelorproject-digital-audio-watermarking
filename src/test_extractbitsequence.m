% just read the encoded bit sequence of a signal

clear;

%path   = ['..',filesep,'results',filesep,'watermarked_audio.wav'];
path = ['..',filesep,'results',filesep,'DA-AD-test-1.wav'];

[signal,fs] = audioread(path);

segmentLength = Setting.coefficient_segment_length; % (3L * 2^k * (Lw+Ls), segment length to encode 1 bit (Lw+Ls=1, dwt level k=6, subband length L=8)
segmentCount = floor(size(signal)/segmentLength);

payloadBuffer = [];
payloadLength = 0;

windowStart=1;
windowEnd = segmentLength;
for i=1:segmentCount

    signalSegment = signal(windowStart:windowEnd);

    bit = extractbit(signalSegment);

    % add the bit to the recovered payload
    payloadLength = payloadLength + 1;
    payloadBuffer(payloadLength) = bit;

    windowStart = windowStart + segmentLength;
    windowEnd = windowEnd + segmentLength;
end

payloadBuffer