function output = generate_user_param(sys_param)

global phy_param;

Ns  = 0;

% Generate necessary sequences and such (pilot symbols for
% instance). For now, we assume we simulate only the first slot (see
% Ns = 0)
output.pilot_sym = get_pilot_sym(Ns,sys_param.cell_id,phy_param.N_RB);


% Generate pilot and data masks
output.masks = get_masks(phy_param.N_RB,phy_param.N_sc,phy_param.N_symb,...
    sys_param.cell_id);

% Number of bits available to transport. Modulation order times number
% of REs available for data (we start from the 4th OFDM symbol). We
% assume QPSK. This is the transport block size
output.tbs = get_tbs_ng(sys_param.M,sys_param.eNB);

% Generate scrambling sequence
output.scrambling_seq = get_scrambling_seq(output.tbs*sys_param.codeR,Ns,sys_param.cell_id,...
    sys_param.Nrnti);


end