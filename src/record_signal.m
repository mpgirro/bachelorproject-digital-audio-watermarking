% Records a audio signal
% see http://www.mathworks.de/de/help/matlab/import_export/record-and-play-audio.html
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

% adjust this values as desired
samplerate = 44100;
bitdepth = 16;
channel = 1;
recordingduration = 15;

recObj = audiorecorder(samplerate, bitdepth, channel);
disp('Start recording.');
recordblocking(recObj, recordingduration);
disp('End of Recording.');

recordingSignal = getaudiodata(recObj);

path = ['..',filesep,'results',filesep,'recording.wav'];
audiowrite(path,  recordingSignal,  samplerate);
fprintf('Recording written to %s\n', path);