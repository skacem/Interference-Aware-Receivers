

% Setting param script

% General parameters
RESULT_DIR = 'results/';
FIGURE_DIR = 'figures/';
s               = RandStream.create('mt19937ar', 'Seed', 14004);
RandStream.setDefaultStream(s);



% Define system and phy parameters 3GPP TS 36.211 version 9.1.0 Release 9

% PHY parameters
phy_param.N_RB = 25;
phy_param.N_min_RB = 6;
phy_param.N_max_RB = 110;
phy_param.N_sc = 12;
phy_param.N_symb = 7;
phy_param.N_cp = [160 144];
phy_param.fftsize = 512;
phy_param.used_sc = 300;% number of data subcarriers per symbol
phy_param.Bandwidth = 5e6; % BW in Hz


% System Parameters
% Generator polynomial G
%phy_param.G = [1 0 1 1 0 1 1; 1 1 1 1 0 0 1]; % 133;171 octal phy_param.G8
%= [133 171];
sys_param(1).G =  [1 1 1 ; 1 0 1];
sys_param(1).G8 = [7 5];
% code Rate
sys_param(1).codeR = 3/4;
sys_param(1).M = 2; % BPSK or QPSK
sys_param(1).cell_id = 1;
sys_param(1).Nrnti = 1;
sys_param(1).intlv = 'ideal'; % 
% for lte interleaver tbs must be conform to the standard
% between 40 and 6144 
sys_param(1).tblen = 5; % Trace back length
sys_param(1).trellis  = poly2trellis( size(sys_param.G,2), sys_param.G8); %
sys_param(1).eNB = 'serving';


sys_param(2).G = [ 1 1 1; 1 0 1 ];
sys_param(2).G8 = [7 5];
% code Rate
sys_param(2).codeR = 3/4;
sys_param(2).M = 2; % BPSK or QPSK
sys_param(2).cell_id = 2;
sys_param(2).Nrnti = 2;
sys_param(2).tblen = 5; % Trace back length
sys_param(2).trellis  = poly2trellis( size(sys_param(2).G,2), sys_param(2).G8);
sys_param(2).intlv = 'ideal'; % 
sys_param(2).eNB = 'interf';