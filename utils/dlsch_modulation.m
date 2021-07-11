function x = dlsch_modulation(sc, mod_order, mapping)

%
% Function Description: 
%
%  
%   note:
%       %
% input parameters:
%       "sc"        : scrambled codeword
%       "mod_order" : Modulation order obtained from the I_MCS
%
% output parameter:
%       "x"    : complex symbols 

% Date:         2012
% Version:      0.1


Nbsc = length(x);
switch mod_order
    
    case 1 % BPSK only for control channels
        sc = 0.7071*(1-(2*sc));
        x = sc + 1i*sc;
    
    case 2 % QPSK
        sc = 0.7071*(1 - (2*sc));
        xm = reshape(sc,2,[]);
        x = xm(1,:) + 1i*xm(2,:);
        
    case 4 %16QAM
        xm = reshape(sc,4,[]);
        
    case 6
        
        
        
        
end