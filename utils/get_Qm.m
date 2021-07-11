function mod_order = get_Qm(I_MCS)

%
% Function Description: 
%
%  Get constellation size from the MCS index
%   note:
%
% input parameters:
%       "I_MCS"     : MCS index
%
% output parameter:
%       "mod_order" : Number of bits per symbol

% Date:         2012
% Version:      0.1


if (I_MCS < 10)
    mod_order = 2; % QPSK
    return;
elseif (I_MCS < 17)
    mod_order = 4; % 16QAM
    return;
else
    mod_order = 6; % 64QAM
end