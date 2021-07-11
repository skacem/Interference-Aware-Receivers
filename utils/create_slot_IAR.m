function [slot  perm data_encoded] = create_slot_IAR(data,user_param,sys_param)


global phy_param;


% Sub-frame is two slots
slot = zeros(phy_param.N_RB*phy_param.N_sc, phy_param.N_symb);


% Insert the pilot symbols in the slots
slot(user_param(1).masks.pilot(:,1)==1,1)= user_param(1).pilot_sym(1,:);
slot(user_param(1).masks.pilot(:,5)==1,5)= user_param(1).pilot_sym(2,:);


% Insert holes in the pilot positions of the interferer 
if (phy_param.IC_Method == 3)
user_param(1).masks.data(user_param(2).masks.pilot(:,1)==1,1) = 0;
user_param(1).masks.data(user_param(2).masks.pilot(:,5)==1,5) = 0;
end

% Scrambling
data_scrambled = xor(user_param(1).scrambling_seq,data);

%% BICM Block
% Convolutional encoder
data_encoded = conv_encoder(data_scrambled, sys_param(1).G, sys_param(1).codeR);

% interleaving
[data_interleaved perm] = do_interlv(data_encoded,sys_param(1).intlv);

% Symbol mapping
data_sym = modulation(data_interleaved,sys_param(1).M);

%%
% Mapping to the resource block elements
slot(user_param(1).masks.data==1) = data_sym;

end