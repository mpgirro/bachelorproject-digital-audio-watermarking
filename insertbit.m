function [ modSignalSegment ] = insertbit( origSignalSegment, bit )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
%   

decomposition = signaldecomposition( origSignalSegment );
Emin = decomposition.Emin;
Emed = decomposition.Emed;
Emax = decomposition.Emax;
A = decomposition.A;
B = decomposition.B;
subbandMap = decomposition.SubbandMap;
decompositionVector = decomposition.DecompositionVector;
bookkeepingVector = decomposition.BookkeepingVector;

% embedding strength factor
esf = Setting.embedding_strength_factor;
%esf = AlgoSettings.EMBEDDING_STRENGTH_FACTOR;

% ES...embedding strength (S im paper)
ES = (esf * sum(abs(decompositionVector(1:3*Setting.subband_length)) )) / 3;

% satisfy equation (11)
if ES >= 2*Emed / (Emed+Emin) * (Emax-Emin)
%    fprintf('reduceing S from %8f ',ES);
    ES = 2*Emed / (Emed+Emin) * (Emax-Emin);
%    fprintf('to %8f [satisfying (11)]\n',ES);
end

% satisfy equation (8)
if ES >= 2*Emed / (Emed+Emax) * (Emax-Emin)
%    fprintf('reduceing S from %8f ',ES);
    ES = 2*Emed / (Emed+Emax) * (Emax-Emin);
%    fprintf('to %8f [satisfying (8)]\n',ES);
end


% THIS IS A SECURITY MARGIN OF MY OWN DESIGN
% to make sure that E'med < E'max
% if not, it could be that E'med = E'max
ES = ES - 0.1*ES;



% fprintf('PAYLOAD: %g\n',bit);
% fprintf('A-B=%8f\n',A-B);
% fprintf('B-A=%8f\n',B-A);
% fprintf('S=%8f\n',ES);

insertion = false;

if bit == 1 && A-B >= ES
    %do nothing - bit '1' can already logically encoded
elseif bit == 0 && B-A >= ES
    %do nothing - bit '0' can already logically encoded
else
    
    % engery level differences do not satisfy the logic yet
    % we need to do some adjustments
    
    if bit == 1 && A-B < ES
    
        insertion = true;
        
        %     fprintf('A-B=%d\n',A-B);
        
        xi = abs(ES-A+B);
        
        % precalculate the alteration factors to the coefficients
        % these are static and not influenced by the c(i)
        factorMinMax = 1 + xi/(Emax + 2*Emed + Emin);
        factorMed 	 = 1 - xi/(Emax + 2*Emed + Emin);
    
    elseif bit == 0 && B-A < ES
    
        insertion = true;
        %     fprintf('B-A=%d\n',B-A);
        
        xi = abs(ES+A-B);
        
        % precalculate the alteration factors to the coefficients
        % these are static and not influenced by the c(i)
        factorMinMax = 1 - xi/(Emax + 2*Emed + Emin);
        factorMed 	 = 1 + xi/(Emax + 2*Emed + Emin);
	else
		fprintf('Oh boy, there is something really wrong here\n'); 
    end
end

% DEBUG - - - - - - - - - - 
mod_bit = 'X';
%  - - - - - - - - - - - - - 

if(insertion)
    
    Smin = subbandMap('min');
    Smed = subbandMap('med');
    Smax = subbandMap('max');
	
	Smin.coefArray(:) = Smin.coefArray(:) .* factorMinMax;
	Smed.coefArray(:) = Smed.coefArray(:) .* factorMed;
	Smax.coefArray(:) = Smax.coefArray(:) .* factorMinMax;
	
	
	% DEBUG - - - - - - - - - - 
	Emin_mod = sum(abs(Smin.coefArray(:)));
	Emed_mod = sum(abs(Smed.coefArray(:)));
	Emax_mod = sum(abs(Smax.coefArray(:)));

	A_mod = Emax_mod - Emed_mod;
	B_mod = Emed_mod - Emin_mod;

	if A_mod > B_mod
		mod_bit = '1';
	 else
		 mod_bit = '0';
	 end
	%  - - - - - - - - - - - - - 
    
    modDecompositionVector = decompositionVector;
	
	modDecompositionVector(Smin.posArray(:)) = Smin.coefArray(:);
	modDecompositionVector(Smed.posArray(:)) = Smed.coefArray(:);
	modDecompositionVector(Smax.posArray(:)) = Smax.coefArray(:);
	

%    % Best don't do this at home, kids!
%    audiowrite('tmp/original.wav',decompositionVector,48000);
%    audiowrite('tmp/modified.wav',modDecompositionVector,48000);
%     
%     odg = PQevalAudio('tmp/orig_dwt.wav','tmp/mod_dwt.wav')
%
%	% http://www.mathworks.de/de/help/matlab/ref/system.html
%	[status,cmdout] = system('bin/PQevalAudio tmp/original.wav tmp/modified.wav');
%	cmdoutLen = size(cmdout);
%	str = 'Objective Difference Grade: ';
%	strLen = size(str);
%	odgOutPos = findstr(cmdout,str);
%	odgVal = cmdout(odgOutPos+strLen(2):cmdoutLen(2));
%	odg = str2double(odgVal)	

    modSignalSegment = waverec(modDecompositionVector, bookkeepingVector, Setting.dwt_wavelet);

else
    modSignalSegment = origSignalSegment;
end


% - - - final checks - - - 

% [extracted_bit, all_coef] = extractbit( modSignalSegment );
% fprintf('[CHECK] %g | %c | %g', bit, mod_bit, extracted_bit);
% if bit ~= extracted_bit
% 	fprintf(' [!] Emin=%4f, Emed=%4f, Emax=%4f, Emin_mod=%4f, Emed_mod=%4f, Emax_mod=%4f', Emin, Emed, Emax, Emin_mod, Emed_mod, Emax_mod );
% 	modDecompositionVector(1:2)
% 	all_coef(1:2)
% end
% fprintf('\n');

% - - - - - - - - - - - -


end

