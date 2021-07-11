
%% Test Convolutional encoder and puncturing
addpath('../')
s               = RandStream.create('mt19937ar', 'Seed', 14004);
RandStream.setDefaultStream(s);

%GenPoly = [1 1 1 ; 1 0 1 ]; % octal: 7;5
GenPoly = [1 0 1 1 0 1 1; 1 1 1 1 0 0 1]; % 133;171 octal
GenPoly8 = [133 171]; %G in Octal 
 

% For matlab convenc the generated data must be a multiple of the puncture
% pattern
%CodeRate = '3/4'; punct_size = 6;
%CodeRate = '1/2';
CodeRate = 2/3; punct_size = 4;

data_bits = round(rand(1,100*punct_size));

trellis = poly2trellis( size(GenPoly,2), GenPoly8);

% Implemented punctured convolutional encoder 
encoded_data = conv_encoder( data_bits, GenPoly, CodeRate);

% Matlab convolutional encoder
if CodeRate  == 3/4
    % remove every 4th and 5th bit [1 1 1 0 0 1]
    punct_pat =  [ 1 1 1 0 0 1] ;
    % Encoding of the DATA-Field:
    [encoded_data_test fstate]= convenc(data_bits, trellis, punct_pat );
    
elseif  CodeRate  == 2/3
    % Remoce every n*4 bit, n = 1:end
    punct_pat = [1 1 1 0];
    % Encoding of the DATA-Field:
    [encoded_data_test fstate]= convenc(data_bits, trellis, punct_pat );
    
elseif CodeRate  == 1/2
    % Encoding of the DATA-Field:
    [encoded_data_test fstate]= convenc(data_bits, trellis);  
end



if sum(encoded_data_test~=encoded_data) 
    error('Something went wrong!');
end



