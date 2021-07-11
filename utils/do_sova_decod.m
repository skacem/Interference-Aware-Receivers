function output = do_sova_decod(llr, G, win)

%
% Function Description:
% Channel decoder, Soft-Viterbi algorithm
%
% input parameters:
%       "llr"       : soft ouput
%       "G"         : Matrix with 2 Generator Polynomials
%       "win"       : size of the trellis buffer
%
% output parameter:
%       "output"    : Decoded bits

% Date:         2012
% Version:      0.1

%%

%llr = metric_depunct
%G = [ 1 1 1; 1 0 1 ];

len = length(llr);
[n,l] = size(G);
m = l - 1;
n_states = 2^m;

% in case llr < win
win = min( [ win, len ] );


% trim the buffer if msg is short

enc_output_ref = [1 1; 1 -1 ;-1 1; -1 -1 ];

path_ = zeros(1,len/n);
euclideanDist = zeros(n_states,len/n);

% Each node in the trellis has two incomming and outgoing paths

state = 0; %initial state


for t = 1 : len/n
    
    % current trellis
    cur = mod( t-1, win+1 ) +1;
    % next trellis position
    nxt = mod( t,   win+1 ) +1;                 
    
    y = llr(n*t - 1 : n*t);
    y_ = kron(ones(n_states,1),y);
    euclideanDist(:,t) = sum(y_.*-enc_output_ref,2);
    
       
end

[ignore state] = min(euclideanDist);

