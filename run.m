% run file for IC scenario

clear

addpath utils;
addpath tests;

global phy_param;

%% Versatile simulation parameters
%snr_dB = Inf;
snr_dB = 9 ;

MAX_REPT = 10; % Number of sub-frames to simulate per SNR value
DEBUG = 0;

phy_param.IC_Method = 1; % Interference cancellation method
phy_param.Ep = 2; % Pilot energy if IC_Method == 2!
phy_param.H_hat = 'perfect'; % perfect or ls

%  4 Different methods are proposed:
%  0: normal maxlog map receiver with co-channel interference
%  1: only an IAR in a normal lte environment
%  2: Increasing the power of the pilot symbols in the interfering eNB
%     relatively to the power of the data subcarriers (maximum allowed power?!)
%  3: eNB¹ creates holes in the pilot positions of the interfering
%     eNB².
%  4: normal maxlog map receiver without co-channel interference


% In both cases the eNB² is considered as interfer.
% Note: IC algorithm is not just about the receiver. The eNBs have also an
% important role.

% Channel Parameters
% SOI propagation channel
channel_param(1).type = 'Rayleigh';
channel_param(1).ntaps = 1;

% Interferer propagation channel parameters
channel_param(2).type = 'Rayleigh';
channel_param(2).ntaps = 1;

% SIR

sir_dB =10;


%% Default simulation parameters

% setting PHY and system parameters
set_params;

% generate user parameters such as pilots, mask and scrambling sequence
user_param(1) = generate_user_param(sys_param(1));
user_param(2) = generate_user_param(sys_param(2));

% Generate dummy user data Generate data
user_data1 = round(rand(1,user_param(1).tbs*sys_param(1).codeR)); % Creates a vector of data
user_data2 = round(rand(1,user_param(2).tbs*sys_param(2).codeR)); % Creates a vector of data

% Placeholder
BER = zeros(length(sir_dB),length(snr_dB));
QUAL1 = zeros(length(sir_dB),length(snr_dB));
QUAL2 = zeros(length(sir_dB),length(snr_dB));


% save some samples from a random repetation
rep = randi([1 MAX_REPT]);

%%
print_inf




%% Run the stuff

if (phy_param.IC_Method == 4)
    sir_dB = 0;
end

for i_sir = 1:length(sir_dB)
    fprintf('\nSIR = %ddB', sir_dB(i_sir));
    
    for i_snr = 1:length(snr_dB)
        fprintf(', SNR = %ddB', snr_dB(i_snr));
        ber_i = 0;
        qual1 = 0;
        qual2 = 0;
        
        for i_rep = 1:MAX_REPT
            
            % Interferer slot
            [slot2  perm2 data_enc2] = create_slot(user_data2,user_param(2),sys_param(2));
            
            %  Slot of interest
            [slot1  perm1 data_enc1] = create_slot_IAR(user_data1,user_param,sys_param);
            
            % OFDM Modulation
            Tx_sig1 = do_OFDM_mod(slot1,'norm');
            Tx_sig2 = do_OFDM_mod(slot2,'norm');
            
            % transmission over Rayleigh channels
            [chanout1 h1 H(1).perfect ] = channel_ng(Tx_sig1, channel_param(1));
            [chanout2 h2 H(2).perfect ] = channel_ng(Tx_sig2, channel_param(2));
            
            % H.perfect reshaping
            H_perfect1 = repmat(H(1).perfect(1:300).',1,7);
            H_perfect2 = repmat(H(2).perfect(1:300).',1,7);
            
            %
            sir_lin = 10.^(sir_dB(i_sir)/10);
            p1 = get_sig_power(chanout1);
            p2 = get_sig_power(chanout2);
            
            if phy_param.IC_Method == 4
                % without CCI
                sigma = 0;
                
            else
                sigma = sqrt(p1/(sir_lin*p2));
            end
            
            % Co-channel signal superposition regarding SIR
            chanout = chanout1 + sigma.*chanout2;
            
            % Additive white noise on the "receiver of interest" side
            Rx_sig = channel(chanout, 'AWGN', snr_dB(i_snr), user_param(2).tbs*sys_param(2).codeR);
            
            
            % Rx demodulation
            Rx_slot = do_OFDM_demod(Rx_sig);
            
            % Channel Estimation
            [H(1).hat H(1).pilot_position] = get_channel_estim_ng(Rx_slot, user_param(1));
            [H(2).hat H(2).pilot_position] = get_channel_estim_ng(Rx_slot, user_param(2));
            
            
            
            % Channel Equalization
            if strcmp(phy_param.H_hat,'perfect')
                
                rx(1).slot_equal = Rx_slot./H_perfect1;
                %rx(1).slot_equal_test = Rx_slot.*conj(H_perfect1)./((abs(H_perfect1)).^2);
                rx(2).slot_equal  = Rx_slot./H_perfect2;
                
            elseif strcmp(phy_param.H_hat,'ls')
                rx(1).slot_equal = Rx_slot./H(1).hat;
                rx(2).slot_equal  = Rx_slot./H(2).hat;
            end
            
            % Data Extraction
            if (phy_param.IC_Method == 3)
                user_param(1).masks.data(user_param(2).masks.pilot(:,1)==1,1) = 0;
                user_param(1).masks.data(user_param(2).masks.pilot(:,5)==1,5) = 0;
            end
            
            rx(1).data = rx(1).slot_equal(user_param(1).masks.data==1);
            rx(2).data = rx(2).slot_equal(user_param(1).masks.data==1);
            
            % Channel estimation quality
            if ~strcmp(phy_param.H_hat,'perfect')
            qual1 = abs(H_perfect1 - H(1).hat).^2 + qual1;
            qual2 = abs(H_perfect2 - H(2).hat).^2 + qual2;
            end
            
            % Estimated channel coefficient extraction
            H(1).data_hat = H(1).hat(user_param(1).masks.data==1);
            H(2).data_hat = H(2).hat(user_param(1).masks.data==1);
            
            
            
            % LLR computation
            metrics = get_llr_ng(rx,H,sys_param(1).M);
            
            % De-interleaving
            metric_deinterleaved = do_deinterlv(metrics,perm1);
            
            % De-puncturing
            metric_depunct = do_depuncturing(metric_deinterleaved,sys_param(1).codeR);
            
            % Soft decision decoding using unquantized inputs
            decoded = vitdec(metric_depunct, sys_param(1).trellis, ...
                sys_param(1).tblen, 'trunc','unquant');
            % trunc : The encoder is assumed to have started at the
            % all-zero state.
            
            % Descramble
            data_hat = xor(user_param(1).scrambling_seq,decoded);
            
            % Error Rate
            ber_i = sum(sum(user_data1~=data_hat))/numel(user_data1) + ber_i;
            
            
            % save samples
            if (i_rep == rep) && ( DEBUG == 1)

                keyboard
            end
            
        end
        
        BER(i_sir,i_snr) = ber_i/MAX_REPT;
        
        if ~strcmp(phy_param.H_hat,'perfect')
        QUAL1(i_sir,i_snr) = qual1/MAX_REPT;
        QUAL1(i_sir,i_snr) = qual2/MAX_REPT;
        end
        
        %fprintf(', BER = %d%% \n', BER(i_sir,i_snr)/MAX_REPT);
        
    end
    
end


%% Save results
save([RESULT_DIR 'IC_' num2str(phy_param.IC_Method) '_hest_' phy_param.H_hat ...
    '.mat' ] ,'phy_param', 'BER','sir_dB','snr_dB', 'sys_param',...
    'user_param','user_data', 'QUAL1', 'QUAL2');


