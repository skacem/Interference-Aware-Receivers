function r = GenRefSig( cellID , ns)

%
% Function Description: 
%
%   This function generates Cell-specific reference signals for every slot
%   TS 36.211 p 74 
%   2 pilot sequences for every slot (first and 3.rd last)
%   Max RBs per OFDM symbol = 110
%   2 pilot symbols per RB
%       -> 220 pilots per OFDM Symbols
% 
%
% input parameters:
%       "cellID"    : Physical layer cell identity
%       "ns"        : slot number within a radion frame
%
% output parameter:
%       "r"         : reference signal sequences needed for one slot

% Date:         2012
% Version:      0.1

% largest dl bw configuration expressed in NRB_sc
NmaxDL_RB = 110;
% normal CP
Ncp = 1; 
% OFDM symbol idx in a slot by normal CP
l = [0 4]; 

% place holder (2x220)
r = zeros(2, 2*NmaxDL_RB);

for i_l = 1 : 2 
    c_init = (2^10)*(7*( ns +1) ...
        + l(i_l) + 1) * ( 2*cellID+1) + 2*cellID + Ncp;
    c = pnGen(c_init, NmaxDL_RB*4);
    
    for m = 1: 2*NmaxDL_RB
        r(i_l,m) = (1/sqrt(2)) * ( (1-2*c(2*m-1)) + (1-2*c(2*m))*1j ); 
    end
end

