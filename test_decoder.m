
clear;

path = ['results',filesep,'watermarked_audio.wav'];
%path = ['results',filesep,'recording.wav'];
%path = ['results',filesep,'watermarked-der-affe-ist-gut.wav'];
%path = ['results',filesep,'recording-soundkarte-der-affe-ist-gut.wav'];
%path = ['results',filesep,'recording-soundkarte-ISP-leicht-gemacht.wav'];
%path = ['results',filesep,'recording-mikrofon-ISP-leicht-gemacht.wav'];
%path = ['results',filesep,'watermarked-ISP-leicht-gemacht.wav'];


fprintf('processing %s\n',path);
[signal,fs] = audioread(path);
watermark = decoder(signal);

messageLength = Setting.message_length;
wmk_bin = reshape(watermark, messageLength, numel(watermark)/messageLength)';
wmk_dec = bi2de(wmk_bin,'left-msb');

disp('    Dec              Binary')
disp('   -----   -------------------------')
disp([wmk_dec,wmk_bin])

% watermark = watermark';
% bitCount = size(watermark);
% fprintf('Decoded %d watermark bits\n',bitCount(1));
% fmt=['Watermark data: ' repmat('%d ',1,bitCount(1)) '\n'];
% fprintf(fmt,watermark);