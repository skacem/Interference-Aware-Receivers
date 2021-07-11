
addpath('../')


RESULT_DIR = 'results/';
FIGURE_DIR = 'figures/';

s               = RandStream.create('mt19937ar', 'Seed', 14004);
RandStream.setDefaultStream(s);


%% test auto correlation property of the generated CS-RS
if 1
    
    cellID = 1;
    ns = 0;
    sss = GenRefSig(cellID, ns);
    
    % test channel estim on the RE with RS
    alpha = 0.2; % one tap channel
    rest = (alpha*sss) .* conj(sss);
    if ( numel(find(rest-alpha)) ~= (numel(sss)))
        disp('Oops!');
    else
        disp('OK!');
    end
    
    figure; plot(abs(ccf(sss(1,:),sss(1,:))))
    grid on;
    title('Autocorrelation Property of CS-RS ')
    ylabel('Amplitude')
    xlabel('samples')
    
    if 0
        TITLE = 'chan_matrix';
        saveas(gcf,[ FIGURE_DIR TITLE '.fig']);
        printIEEE([ FIGURE_DIR TITLE '.eps'] ) ;
        saveas(gcf, [ FIGURE_DIR TITLE '.pdf'] );
        
        
        zlabel('20log_{10}| \hat{H} |')
    end
    
end


%% test scrambler/descrambler
if 1
    %q = randi([0 1], 1,100);
    q = [0 1 0 1 1 1 0 0 1 0 1 1 1 0 0 1 0 1 1 1 0 0 1 ...
        0 1 1 1 0 0 1 0 1 1 1 0 0 1 0 1 1 1 0 0 1 0 1 1 1 0];
    RNTI1 = 1;
    RNTI2 = 3;
    cellID1 = 0;
    cellID2 = 1;
    ns = 2;
    
    %scramble codeword
    sc1 = scrambleSeq(q,ns,RNTI1, cellID1);
    sc2 = scrambleSeq(q,ns,RNTI2, cellID2);
    
    % test correlation between signals different cells after scrambling
    figure; plot(abs(ccf(sc1,sc2)))
    
    %descramble codeword
    desc1 = scrambleSeq(sc1,ns,RNTI1, cellID1);
    
    %
    Err_Rate = sum(sum(desc1 ~=q))/numel(q)
    
end



%% test do_OFDM_mod/do_OFDM_demod
if 1
    % generate test signal
    q = (1/sqrt(2))*(1-2*randi([0 1], 300,7)) + 1i*(1/sqrt(2))*(1-2*randi([0 1], 300,7));
    
    % IFFT
    test = do_OFDM_mod(q);
    
    % FFT
    demod_test = do_OFDM_demod(test);
    result = abs(demod_test - q);
    
    idx = find (result > 10e-10);
    Err_Rate = numel(idx)/numel(q)
end

%% BER plots simulated vs theoretical

N_sc = 12;
N_symb = 7;
N_cp = [160 144];
fftsize = 512;
used_sc = 300;
M = 2; % QPSK

snr_dB = 0:1: 9;


%theoreticalBER = zeros(1,length(EsN0dB));

i_loop = 100;
BER = zeros(length(snr_dB),i_loop);
for i = 1 :i_loop
for k = 1:length(snr_dB)
    % generate test signal
    data_i = randi([0 1], 1, 300*7) ;
    data_q = randi([0 1], 1, 300*7) ;
    data = kron(data_i,[1 0]) + kron(data_q,[0 1]);
    q = (1/sqrt(2))*(1-2*reshape(data_i,300,7)) ...
        + 1i*(1/sqrt(2))*(1-2*reshape(data_q,300,7));
    
    % OFDM mod
    Tx_sig = do_OFDM_mod(q,'morm');
    
    % Gaussian noise of unit variance, 0 mean
    noise = 1/sqrt(2)*(randn(1,length(Tx_sig)) + 1j*randn(1,length(Tx_sig)));
    Rx_sig = sqrt((N_cp(2) - 50 + fftsize)/fftsize) * Tx_sig + ...
        10^(-snr_dB(k)/20)* noise;
    
    Rx_slot = do_OFDM_demod(Rx_sig);
   
    data_hat = demodulation(reshape(Rx_slot,1,[]),M);
    BER(k,i) = sum(sum(data~=data_hat))/numel(data);
end

end

% theoretical BER


% semilogy(snr_dB, BER_1,'-o')
% hold on; semilogy(snr_dB, BER_2,'r-d')
semilogy(snr_dB, BER,'r-o')
theoretical_BER = 0.5*erfc(sqrt(10.^(snr_dB/10)));
hold on; semilogy(snr_dB, theoretical_BER, 'g-*')
xlabel('SNR [dB]');
ylabel('BER');

legend('with channel equalization','without channel Equalization')
title( 'BER performance in a 5-taps Rayleigh channel')
grid on;

if 0
    TITLE = 'ber_rayleigh_w_wo';
    saveas(gcf,[ FIGURE_DIR TITLE '.fig']);
    printIEEE([ FIGURE_DIR TITLE '.eps'] ) ;
    saveas(gcf, [ FIGURE_DIR TITLE '.pdf'] );
end

%% Channel Estimation

test = get_channel_estim(Rx_slot, masks.id_0, pilot_sym.id_0);


N_samp = 50;

no_s0 = zeros(300,1);
no_s4 = zeros(300,1);
no_s0(masks.id_0.pilot(:,1) == 1) = test(masks.id_0.pilot(:,1) == 1,1);
no_s4(masks.id_0.pilot(:,5) == 1) = test(masks.id_0.pilot(:,5) == 1,5);


stem(test(1:N_samp,1))
hold on; stem(no_s0(1:N_samp),'ro')
xlabel('Sub-carriers');
ylabel('Channel gain');

legend('Channel estim. by interpolation', 'Channel estim. by pilots')
title( {'Illustration of  50 Sub-carriers', 'from the 1^{st} OFDM Symbol'})
grid on;

if 0
    TITLE = 'sys_ber_perform';
    saveas(gcf,[ FIGURE_DIR TITLE '.fig']);
    printIEEE([ FIGURE_DIR TITLE '.eps'] ) ;
    saveas(gcf, [ FIGURE_DIR TITLE '.pdf'] );

    close
end



figureSo the first plot BER vs SNR is just to show that the OFDM mod/demod work fine only the AWGN addition considering the k
stem(test(1:N_samp,5))
hold on; stem(no_s4(1:N_samp),'ro')
xlabel('Sub-carriers');
ylabel('Channel gain');

legend('Channel estim. by interpolation', 'Channel estim. by pilots')
title( {'Illustration of  50 Sub-carriers', 'from the 5^{th} OFDM Symbol'})
grid on;

if 0
    TITLE = 'channel_est_5th_symb';
    saveas(gcf,[ FIGURE_DIR TITLE '.fig']);
    printIEEE([ FIGURE_DIR TITLE '.eps'] ) ;
    saveas(gcf, [ FIGURE_DIR TITLE '.pdf'] );

    close
end



figure
test2 = zeros(1,7);
test2([1 5]) = test(2,[1 5]);
stem(test(2,:))
hold on

stem(test2,'ro')
xlabel('OFDM Symbol');
ylabel('Channel gain');

legend('Channel estim. by interpolation', 'Channel estim. by pilots')
title( {'Illustration of  the channel estim', 'of the 2^{nd} subcarrier over the time'})
grid on;

if 0
    TITLE = '4taps_ray_nocor';
    saveas(gcf,[ FIGURE_DIR TITLE '.fig']);
    printIEEE([ FIGURE_DIR TITLE '.eps'] ) ;
    saveas(gcf, [ FIGURE_DIR TITLE '.pdf'] );

    close
end


%% perfect channel estimation

% generate test signal
    data_i = randi([0 1], 1, 300*7) ;
    data_q = randi([0 1], 1, 300*7) ;
    data = kron(data_i,[1 0]) + kron(data_q,[0 1]);
    q = (1/sqrt(2))*(1-2*reshape(data_i,300,7)) ...
        + 1i*(1/sqrt(2))*(1-2*reshape(data_q,300,7));

    % OFDM mod
    Tx_sig = do_OFDM_mod(q,'norm');
    
    % over Rayleigh channel
    [ Rx_sig h ] = channel(Tx_sig, 'Rayleigh', snr_dB(k), 5);
    %Rx_sig = Tx_sig;
    % Rx demodulation
       
        Rx_slot = do_OFDM_demod(Rx_sig);
    
    % get perfect channel estimate;
    H_perfect = Rx_slot .* conj(q);
    
    
 % Channel estimation quality
 qual = abs(H_perfect - H_hat).^2;
 
 
    
%%
%general parameters
const_size = 16;%constellation size
select_mapping = 'binary';
threshold_value = 50;
demapper_method = 'maxlogMAP';
map_metric = 'maxlogMAP';
gen = [37 21];
constraint_length = 5;
nb_errors_lim = 1500;
nb_bits_lim = 1e6;
perm_len = pow2(14);%permutation length
nb_iter = 10;%number of iterations in the turbo decoder
EbN0_dB = 0:20;
R = 1/2;%coding rate of FEC
Es = 1;%mean symbol energy    

%QAM modulator class
bits_per_symbol = log2(const_size);
h_QAMmod = modem.qammod('M', const_size, 'PhaseOffset', 0, 'SymbolOrder', select_mapping, 'InputType', 'bit');
constellation = h_QAMmod.Constellation;%complex constellation
bin_constellation = de2bi(h_QAMmod.SymbolMapping, bits_per_symbol, 'left-msb');%binary constellation
scale = modnorm(constellation, 'avpow', 1);%normalisation factor    

%other parameters
filename = ['Res/BICM_' map_metric '_' select_mapping];
nb_symb = perm_len/bits_per_symbol;
nb_bits_tail = perm_len/length(gen);
nb_bits = nb_bits_tail-(constraint_length-1);%number of bits in a block (without tail)
sigma2 = (0.5*Es/(R*bits_per_symbol))*(10.^(-EbN0_dB/10));%N0/2
%SISO NSC
nsc_apriori_data = zeros(1, nb_bits_tail);
%decision
snr_len = length(EbN0_dB);
BER = zeros(nb_iter,snr_len);
    
%CC
bin_gen = de2bi(base2dec(int2str(gen.'), 8), 'left-msb');
constraint_len = size(bin_gen, 2);
trellis = poly2trellis(constraint_len, gen);

%%
s = RandStream.create('mt19937ar', 'seed',131);
prevStream = RandStream.setGlobalStream(s); % seed for repeatability
trel = poly2trellis(3,[6 7]); % Define trellis.
msg = randi([0 1],100,1); % Random data
code = convenc(msg,trel); % Encode.
ncode = rem(code + randerr(200,1,[0 1;.95 .05]),2); % Add noise.
tblen = 3; % Traceback length
decoded1 = vitdec(ncode,trel,tblen,'cont','hard'); %Hard decision
% Use unquantized decisions.
ucode = 1-2*ncode; % +1 & -1 represent zero & one, respectively.
decoded2 = vitdec(ucode,trel,tblen,'cont','unquant');
% To prepare for soft-decision decoding, map to decision values.
[x,qcode] = quantiz(1-2*ncode,[-.75 -.5 -.25 0 .25 .5 .75],...
[7 6 5 4 3 2 1 0]); % Values in qcode are between 0 and 2^3-1.
decoded3 = vitdec(qcode',trel,tblen,'cont','soft',3);
% Compute bit error rates, using the fact that the decoder
% output is delayed by tblen symbols.
[n1,r1] = biterr(decoded1(tblen+1:end),msg(1:end-tblen));
[n2,r2] = biterr(decoded2(tblen+1:end),msg(1:end-tblen));
[n3,r3] = biterr(decoded3(tblen+1:end),msg(1:end-tblen));
disp(['The bit error rates are:   ',num2str([r1 r2 r3])])
RandStream.setGlobalStream(prevStream); % restore default stream


%%


legend('','','')


if 0
    TITLE = 'ber_rayleigh_w_wo';
    saveas(gcf,[ FIGURE_DIR TITLE '.fig']);
    printIEEE([ FIGURE_DIR TITLE '.eps'] ) ;
    saveas(gcf, [ FIGURE_DIR TITLE '.pdf'] );
end

title( 'BER performance