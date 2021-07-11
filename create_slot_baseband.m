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
function [slot perm data_encoded] = create_slot_baseband(data,phy_param,...
    Ns,pilot_sym,masks,scrambling_seq)

% Sub-frame is two slots
slot = zeros(phy_param.N_RB*phy_param.N_sc,phy_param.N_symb);
%size(slot) % Debug

% Insert the pilot symbols in the slots
slot(masks.pilot(:,1)==1,1)=pilot_sym(1,:);
slot(masks.pilot(:,5)==1,5)=pilot_sym(2,:);



% Scrambling 
data_scrambled = xor(scrambling_seq,data);

%% BICM Block
% Convolutional encoder
data_encoded = conv_encoder(data_scrambled, phy_param.G, phy_param.codeR);

% interleaving
[data_interleaved perm] = do_interlv(data_encoded,'ideal');

% Symbol mapping
data_sym = modulation(data_interleaved,phy_param.M);
%plot(real(data_sym),imag(data_sym),'*'); % Debug

%%
% Mapping to the resource block elements
slot(masks.data==1) = data_sym;
%real(slot) % Debug
%imag(slot) % Debug

end