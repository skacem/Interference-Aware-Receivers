function output = do_puncturing(mother_coded_bits, code_rate)

%
% Function Description:
% This function is part of the convolutional encoder, performs puncturing
% based on defined puncturing pattern.
%
% input parameters:
%       "mother_coded_bits"     : coded bits with R=1/2
%       "code_rate" : 1/2 , 3/4 or 2/3
%
% output parameter:
%       "output"    : punctured coded bits

% Date:         2012
% Version:      0.1

l = length(mother_coded_bits);

if code_rate == 1/2
    output = mother_coded_bits ;
    return
    
elseif code_rate  == 3/4
    % Puncture pattern: [1 2 3 x x 6]: skip every 4th and 5th bit
    pattern = [1 2 3 6];
    pattern_size = 6;
    
elseif code_rate  == 2/3
    % Puncture pattern: [1 2 3 x], skip every 4th bit
    pattern = 1:3;
    pattern_size = 4;
end

% Reshape encoded bits onto (pattern_size, N) Matrix
rest = mod(l, pattern_size);
coded_bits_matrix = reshape(mother_coded_bits(1: end - rest), pattern_size, []);

coded_bits_ = coded_bits_matrix(pattern,:);

if rest
     % Puncture the remainder bits if needed
    rest_bits = mother_coded_bits(l - rest +1 : l);
    rest_pattern =  pattern <= rest ;
    rest_punctured = rest_bits(rest_pattern);
    
    output = [coded_bits_(:).' rest_punctured];
    
else
   output = coded_bits_(:).';
end