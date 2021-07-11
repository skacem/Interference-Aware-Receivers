function [ber] = debug_slicer(slot,M,masks,scrambling_seq,data)

% Extract the data
rx_data_signal = slot(find(masks.data==1));
%size(rx_data_signal); % Debug
% Demodulation
data_hat = demodulation(rx_data_signal,M);
% Descramble
data_hat = xor(scrambling_seq,data_hat);
% Check (should be zero if no erro)
nb_error = sum(abs(data-data_hat));
fprintf('Number of errors: %d\n',nb_error);

% Note: for BPSK and QPSK, theoretical BER should be
% 5*erfc(sqrt(10.^(snr_dB/10)))
ber = nb_error/length(data);

end