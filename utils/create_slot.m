%
% Consider 5 MHz for now. 3GPP TS 36.104 version 9.11.0 Release 9
% 5 MHz is equal to 25 resource blocks
%
% Frame structure type 1 (FDD): 3GPP TS 36.211 version 9.1.0 Release 9
%
% One transmit antenna
%
% We consider QPSK
%
% Ns is the slot number (0 to 19)
function [slot perm data_encoded] = create_slot(data, user_param, sys_param)


global phy_param;

Ep = 1;
% Sub-frame is two slots
slot = zeros(phy_param.N_RB*phy_param.N_sc, phy_param.N_symb);

if (phy_param.IC_Method == 2); Ep = phy_param.Ep; end; 

% Insert the pilot symbols in the slots
slot(user_param.masks.pilot(:,1)==1,1)= sqrt(Ep)*user_param.pilot_sym(1,:);
slot(user_param.masks.pilot(:,5)==1,5)= sqrt(Ep)*user_param.pilot_sym(2,:);



% Scrambling 
data_scrambled = xor(user_param.scrambling_seq,data);

%% BICM Block
% Convolutional encoder
data_encoded = conv_encoder(data_scrambled, sys_param.G, sys_param.codeR);

% interleaving
[data_interleaved perm] = do_interlv(data_encoded,sys_param.intlv);

% Symbol mapping
data_sym = modulation(data_interleaved,sys_param.M);

%%
% Mapping to the resource block elements
slot(user_param.masks.data==1) = data_sym;

end