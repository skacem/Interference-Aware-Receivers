function tbs = get_tbs(M,eNB)
global phy_param

N = 2; %Number of Pilots pro RB

if (phy_param.IC_Method == 3 && strcmp(eNB, 'interf')); N=4;end
    
tbs = M*((phy_param.N_symb-3)*(phy_param.N_RB*phy_param.N_sc) - N*phy_param.N_RB);

end