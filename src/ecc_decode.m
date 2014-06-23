function [ message ] = ecc_decode( codeword )
% decode a codeword for an ECC set in the Settings
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

ecm = Setting.error_correcion_methode;

switch ecm
    case 'BCH'
        message = bchdecode(codeword);
    case 'RS'
        message = rsdecode(codeword);
    case 'LDPC'
        message = ldpcdecode(codeword);
    case 'none'
        message = codeword;
end

end

