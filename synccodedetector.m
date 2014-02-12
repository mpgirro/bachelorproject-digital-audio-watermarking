function [ found ] = synccodedetector( sample_sequence )
%UNTITLED checks if a sequence of signal samples holds a synccode
%   Checks if a sequence of signal samples encode a synchronization code.
%   To encode 1 bit, there are coefficient_segment_length sample values
%   necessary. Each synccode has a length of sync_segment_length. Therefore
%   the signal sample sequence this function processes musst be:
%   coefficient_segment_length x sync_segment_length values long. 
%
%   sample_sequence...coefficient_segment_length x sync_segment_length
%   samples values of the signal
%   found...boolean value, true if valid sync code sequence found, false
%   otherwise

sampleSize  = size(sample_sequence);
windowWidth = Setting.coefficient_segment_length;
syncCode    = Setting.sync_code;
codeLength  = Setting.sync_segment_length;
readCode    = zeros([1,codeLength]);

windowStart = 1;
windowEnd   = windowWidth;

for i=1:codeLength
    
    segment = sample_sequence(windowStart:windowEnd);
    readCode(i) = extractbit(segment);
    
    windowStart = windowStart + windowWidth;
    windowEnd   = windowEnd + windowWidth;
    
end

found = isequal(syncCode,readCode);

end

