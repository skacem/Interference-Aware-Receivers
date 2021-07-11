function output = do_OFDM_mod(symbMatrix, type)

%
% Function Description:
%
%   Add the zero-padded frequencies around the DC, IFFT modulation and
%   CP insertion.
%
%
% input parameters:
%       "symbMatrix"    : mapped REs
%	"type"		: - "norm": normal, means with N_cp0 = N_cp +16
%			  - "exp" : N_cp0 = N_cp = 144
%			  - "noCP": without guard interval
%
% output parameter:
%       "output"        : signal in the time domain without the CP

% Date:         2012
% Version:      0.2


if nargin < 2
    
    type = 'norm';
    
end

global phy_param;

N_symb = phy_param.N_symb;
fftsize = phy_param.fftsize;
N_cp0 = phy_param.N_cp(1);
N_cp = phy_param.N_cp(2);
used_sc = 300;

% place holder:
tmp = zeros(fftsize,N_symb);

% zero-padded frequencies
tmp(1:300,:) = symbMatrix;

%IFFT modulation
timesig =(fftsize/sqrt(used_sc))* ifft(tmp,fftsize);


if strcmp(type,'norm')
    % CP insertion
    timesig_cp = [timesig(end - N_cp +1 : end,:);timesig];
    output = [ timesig(end - N_cp0 +1 : end - N_cp,1).' reshape(timesig_cp,1,[])];
    
elseif strcmp(type, 'exp')
    output = reshape([timesig(end - N_cp +1 : end,:);timesig],1,[] );
    
elseif strcmp(type, 'noCP')
    
    output = reshape(timesig,1,[]);
end
