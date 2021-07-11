
% test puncturing depuncturing

CodeRate = '2/3'; punct_size = 4;

coded_bits = round(rand(1,100*punct_size));

% Puncturing
punctured_bits = do_puncturing(coded_bits, CodeRate);

% Depuncturing
depunctured_bits = do_depuncturing(punctured_bits, CodeRate);

if (length(coded_bits)~= length(depunctured_bits)) 
    error('Something went wrong!');
end
