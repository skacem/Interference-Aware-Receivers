
function sc = scramble(q,ns,RNTI, cellID)

%
% Function Description: 
%
%  XOR codeword q with scrambling sequence c. 
%   Shall be called prior to the modulation. (TS 36.211 p.57)
%   note:
%       Call the pnGen() with different c_init depending on the CellID
%       and the RNTI associated with the PDSCH transmission
%
% input parameters:
%       "q"     : codeword
%       "ns"    : slot number within a radio frame
%       "RNTI"  : radio network temporary identifier
%       "cellID": physical layer cell identity 
%
% output parameter:
%       "sc"    : block of scrambled bits 

% Date:         2012
% Version:      0.1



q_ = 0; % in case of single codeword q_ is equal to zero!
Mbitq = length(q);

c_init = RNTI*(2^14) + q_*(2^13) + floor(ns/2)*(2^9) + cellID;

c = pnGen(c_init,Mbitq);

sc = mod(q + c ,2);
