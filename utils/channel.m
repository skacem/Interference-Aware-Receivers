function [chout h H] = channel(chin, type, d , T,Px, alpha, Gr, Gx)

%
% Function WirelessChann simulates 4 types of propagation channel:
% AWGN, Log-normal path loss channel, RayleighExp and Rayleigh
% Difference between RayleighExp and Rayleigh:
%        RayleighExp : Generates real valued rayleigh distributed channel gains
% d:    for 'AWGN' and 'Rayleigh' Channel: SNR
%       for 'path-loss' the separation distance
%
% T:    for 'path loss: Temperature'
%       for Rayleigh: number of Taps
%       for 'AWGN' : transport block size
%
% Px:   for Log-normal channel stand for transmitted carrier Power [ Watt ]
%       for Rayleigh: variance
%
% Example:
%   AWGN:
%       TxSig  = WirelessChann(Sig, 'AWGN', RxSNR)

% Date:         2012
% Version:      0.2

% Parameter Setup
global phy_param;

f           = 2.4e9 ; % Carrier frequency
c           = 3e8;          % speed of light, m/s
k           = 1.38065e-23;   % Boltzman constant, Joules/Kelvin
lambda      = c/f; %Wavelength
W           = phy_param.Bandwidth;
fftsize     = phy_param.fftsize;



if strcmp( type ,'AWGN')
    
    if nargin > 4
        error('Too much input arguments.')
    end
    
    %chout   = awgn(chin,d,'measured');
    noise = 1/sqrt(2)*(randn(1,length(chin)) + 1j*randn(1,length(chin)));
    chout = sqrt(((phy_param.N_cp(2)+(16/7) + phy_param.fftsize)/phy_param.fftsize)...
        *(phy_param.used_sc*phy_param.N_symb/T))*chin + 10^(-d/20)* noise;
    h = noise;
    
elseif strcmp( type ,'path-loss')
    % d     : distance between MS and BS [ m ]
    % T     : temperature in Kelvin.
    % Px    : transmitted carrier Power [ Watt ]
    % alpha : propagation environment [2...8]
    % Gt    : transmitter antenna
    % Gr    : receiver antenna gain
    
    if nargin > 8
        error('Too much input arguments.')
    end
    if nargin < 8; Gx = 1; end
    if nargin < 7; Gr = 1; end
    if nargin < 6; alpha = 4; end
    if nargin < 5; Px = 30e-3; end
    if nargin < 4; T = 490; end
    if nargin < 3
        error('Not enough input arguments.')
    end
    %Thermal noise present in a bandwidth
    N       = k*T*W;
    % dBm means dB relative to mW.
    if d == 0
        
        h = Inf;
        xi = real(chin);
        xq = imag(chin);
    else
        Pn      = 10*log10(N*10^3); % in dBm
        pl      = -10*log10(Gx*Gr*(lambda/(4*pi))^2); % Friis equation for d0=1m [dB]
        %d0 is the close-in reference distance
        
        % path loss modell
        
        X       = 0; % usually it is a zero mean gaussian distributed random variable in dB
        % the standard normal distribution has µ = 0 and σ = 1.
        % X = normpdf(chin,0,1)
        
        Ld      = pl + 10*alpha*log10(d) + X; %[dB]
        
        % Link Budget equation
        Pr      = 10*log10(Px*10^3) - Ld; % Px[dBm] - Ld[dB]
        
        %
        h     = Pr - Pn; %Pr [dBm] - Pn [dBm]
        chout   = awgn(chin,h,'measured');
        
        
    end
    
    
elseif strcmp( type ,'RayleighExp')
    
    if nargin < 5; Px = 0.5; end
    if nargin < 4; T = 5; end
    variance = Px;
    range = (1 : 1 : T)*(4/T) ;
    h = (range/(variance)).*exp(-range.^2/(2*variance));
    
    chout_      = conv(chin,h); % Convolution:
    chout       = awgn(chout_,d,'measured'); % awgn addition
    chout(end-T+2:end) = []; % Discard samples resulting from convolution
     H = fft(h, fftsize);
    
elseif strcmp( type ,'Rayleigh')
    if nargin < 4; T = 5; end
    
    snr_lin     = 10.^(d/10);% SNR linear
    sigma2_n    = 1./snr_lin;% AWGN variance
    
    % exponetial decaying power profile
    var_h = exp(-(1 : 1 : T)/4);
    var_h = var_h/sum(var_h); % Normalize overall average channel power
    
    % Generate random complex channel coefficients
    h = 1/sqrt(2)*( randn(1,T) + 1j*randn(1,T) ) .* sqrt(var_h);
    chout_      = conv(chin,h);
    
    % Add noise
        n = sqrt(0.5*sigma2_n) * ( randn(1,length(chout_)) + ...
            1j*randn(1,length(chout_)) );
        chout = chout_ + n;
        chout(end-T+2:end) = []; % Discard samples resulting from convolution
   
        % Channel frequency response 
   H = fft(h, fftsize);
   
else
    
    
    error('Wrong propagation channel.');
    
    
end

