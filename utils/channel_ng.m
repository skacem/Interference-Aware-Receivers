function [chout h H] = channel_ng(chin, channel_param)

%
% Function channel_ng simulates RayleighExp and Rayleigh.
%
% RayleighExp : Generates real valued rayleigh distributed channel gains


% Date:         2012 Version:      0.2


% No AWGN is added in this function
global phy_param

type        = channel_param.type ;
ntaps       = channel_param.ntaps;

if strcmp(type, 'AWGN')
chout   = chin;
H = ones(1,length(chin));
 h = 1;   
elseif strcmp( type ,'RayleighExp')
    

  % exponetial decaying power profile
    var_h = exp(-(1 : 1 : ntaps)/4);
    var_h = var_h/sum(var_h); % Normalize overall average channel power
    
    h = sqrt(var_h);
    chout      = conv(chin,h); % Convolution:
    chout(end-ntaps+2:end) = []; % Discard samples resulting from convolution
    H = fft(h, phy_param.fftsize);
    
elseif strcmp( type ,'Rayleigh')
    
  
    
    % exponetial decaying power profile
    var_h = exp(-(1 : 1 : ntaps)/4);
    var_h = var_h/sum(var_h); % Normalize overall average channel power
    
    % Generate random complex channel coefficients
    h = 1/sqrt(2)*( randn(1,ntaps) + 1j*randn(1,ntaps) ) .* sqrt(var_h);
    chout     = conv(chin,h);
    
    chout(end-ntaps+2:end) = []; % Discard samples resulting from convolution
    
    % Channel frequency response
    H = fft(h, phy_param.fftsize);
    
else
    
    
    error('Wrong propagation channel.');
    
    
end

