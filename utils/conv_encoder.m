function coded_bits = conv_encoder(input, G, code_rate)

%
% Function Description:
% Convolutional encoder with different code rates R
% R = '1/2' , '3/4', '2/3' obtained after puncturing.
%
% input parameters:
%       "input"     : information bits
%       "G"         : Matrix with 2 Generator Polynomials
%       "code_rate" : code rate
%
% output parameter:
%       "coded_bits"    : Coded bits

% Date:         2012
% Version:      0.2


if(nargin<3) ; code_rate = 1/2 ;end

seq = zeros(1,size(G,2));
l = length(input);

conseq1 = zeros(1,l);
conseq2 = zeros(1,l);

for i = 1 : l
    
    seq(2:end) = seq(1:end-1);
    seq(1) = input(i);
    
    conseq1(i) = prod(1 -2*(seq .* G(1,:)));
    conseq2(i) = prod(1 -2*(seq .* G(2,:)));
    
end

mother_coded_bits = 0.5*(1 - (kron(conseq1,[1 0]) + kron(conseq2,[0 1])));

% Puncturing
coded_bits = do_puncturing(mother_coded_bits, code_rate);