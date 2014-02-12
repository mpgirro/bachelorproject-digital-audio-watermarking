function [odg] = odgFromPQevalAudioBinary( refSignal, refFs, testSignal, testFs)

	% resample if need be - PQevalAudio only works with 48kHz
%	if refFs ~= 48000
%	    signal = resample(refSignal, 48000, refFs);
%	    refFs = 48000;
%	end
%
%	if testFs ~= 48000
%	    signal = resample(testSignal, 48000, testFs);
%	    testFs = 48000;
%	end

	% write signals to harddrive
	audiowrite('tmp/refSignal.wav',  refSignal,  refFs);
	audiowrite('tmp/testSignal.wav', testSignal, testFs);

	% http://www.mathworks.de/de/help/matlab/ref/system.html
	[status,cmdout] = system('/Applications/Wine.app/Contents/Resources/bin/wine bin/EAQUAL.exe tmp/refSignal.wav tmp/testSignal.wav');
	outputLength = size(cmdout);
	odgLine = 'Objective Difference Grade: ';
	odgLineLength = size(odgLine);
	odgLinePos = findstr(cmdout,odgLine);
	odgVal = cmdout(odgLinePos+odgLineLength(2):outputLength(2));
	odg = str2double(odgVal);

end