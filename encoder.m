
addpath('PQevalAudio');
addpath('PQevalAudio/CB');
addpath('PQevalAudio/MOV');
addpath('PQevalAudio/Misc');
addpath('PQevalAudio/Patt');


path = ['resources',filesep,'audio',filesep,'flute.wav'];
[signal,fs] = audioread(path);

% resample if need be - PQevalAudio only works with 48kHz
if fs ~= 48000
    signal = resample(signal, 48000, fs);
    fs = 48000;
end

origSignal = signal;

% aplayer = audioplayer(signal,fs);
% aplayer.play();

%plot( [1:size(signal)], signal)

payload = [1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0];

segmentLength = (3*AlgoConst.SUBBAND_LENGTH * 2 ^ AlgoConst.DWT_LEVELS); % (3L * 2^k * (Lw+Ls), segment length to encode 1 bit (Lw+Ls=1, dwt level k=6, subband length L=8)
segmentCount = floor(size(signal)/segmentLength);

windowStart=1;
windowEnd = segmentLength;
for i=1:segmentCount
    
    % if whole payload is inserted we do not need to continue
    if i > size(payload)
        break;
    end
        
    signalSegment = signal(windowStart:windowEnd);
    
    modSignalSegment = insertbit(signalSegment,payload(i));
    fprintf('Encoding check: Payload bit=%f - %f extracted bit\n',payload(i),extractbit(modSignalSegment));
    fprintf('\n');
    
    signal(windowStart:windowEnd) = modSignalSegment;
    
    windowStart = windowStart + segmentLength;
    windowEnd = windowEnd + segmentLength;
end

modSignal = signal;

audiowrite('watermarked_audio.wav',modSignal, 48000);

    
%plot( [1:size(signal)], signal)

% aplayer = audioplayer(modSignal,48000);
% aplayer.play();


% wavwrite(signal,fs,'test.wav')



