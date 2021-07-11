function output = do_OFDM_demod(sigvec)


%
% Function Description:
%
%   Removes CP  and performs FFT
%
%
% input parameters:
%       "sigvec"        : time domain signal vector
%
% output parameter:
%       "output"         : REs

% Date:         2012
% Version:      0.2
global phy_param;

N_symb = phy_param.N_symb;
fftsize = phy_param.fftsize;
N_cp0 = phy_param.N_cp(1);
N_cp = phy_param.N_cp(2);
used_sc = 300;

N = length(sigvec);

if ( N == ((fftsize+N_cp)*7)+ N_cp0 - N_cp)
    
    % CP conform to the LTE spec
    sigmat_cp = reshape(sigvec(N_cp0 - N_cp +1 : end), [], N_symb);
    sigmat = sigmat_cp(N_cp +1 :end,:);  
    
elseif ( N == (fftsize+N_cp)*7 )
    % experimental CP/ the same CP length overall even for the first symbol
    sigmat_cp = reshape(sigvec, [], N_symb);
    sigmat = sigmat_cp(N_cp +1 :end,:);  
else
    % No CP
    sigmat = reshape(sigvec, [], N_symb);
end

% FFT
tmp = (fftsize\sqrt(used_sc))*fft(sigmat,fftsize);
output = tmp(1:300,:);