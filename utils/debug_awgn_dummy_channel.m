%
% Simply add AWGN noise everywhere
%
function [slot] = debug_awgn_dummy_channel(slot,snr_dB)

% Convertion to linear domain
snr_lin = 10^(snr_dB/10);
% Assume Eb = 1 to compute the noise variance
sigma = sqrt(1 / (2*snr_lin));
% Generate noise
noise = sigma*(randn(size(slot))/sqrt(2) + j*randn(size(slot))/sqrt(2));

slot = slot + noise;