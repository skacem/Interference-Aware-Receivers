% test demapper


phy_param.M = 2;
ndata = 200;

snr_dB = 1;

data = randi([0 1], 1,ndata);
data_sym = modulation(data,phy_param.M);


for i_snr = 1 : length(snr_dB)
    
    snr_lin = 10^(snr_dB/10);
    sigma = sqrt(1 / (2*snr_lin));
    noise = sigma*(randn(size(data_sym))/sqrt(2) + 1j*randn(size(data_sym))/sqrt(2));

    Rx_sig = data_sym + noise;
    
ss =     do_compute_metric(Rx_sig,phy_param.M )
end