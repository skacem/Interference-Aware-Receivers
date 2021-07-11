function depunct_bits = do_depuncturing(input, code_rate)




if nargin ~= 2 ; error('Wrong input arguments!'); end

if  code_rate  == 1/2
    depunct_bits = input ;
    return
    
elseif  code_rate == 3/4
    % Puncture pattern: [1 2 3 x x 6]: skip every 4th and 5th bit
    pattern = [1 2 3 6];
    pattern_size = 6;
    
elseif code_rate == 2/3
    % Puncture pattern: [1 2 3 x], skip every 4th bit
    pattern = 1:3;
    pattern_size = 4;
end

l = length(input);
lp = length(pattern);

% Placeholder
depunct_mat = zeros(pattern_size, floor(l/lp) );

rest = mod(l, lp);
punct_mat = reshape(input(1:end-rest), lp, []);

depunct_mat(pattern,:) = punct_mat;

if rest
     % Puncture the remainder bits if needed
    rest_bits = input(end - rest +1 : end);
    % TODO : how to find out if we had exactly 3 bits or 4 and one was
    % punctured in the example of code_rate = 3/4?
    % Actually it doesnt care?!
    
    rest_depunct = zeros(1,pattern_size);
    rest_depunct(pattern(1:rest)) =  rest_bits;
    depunct_bits = [depunct_mat(:).' rest_depunct];
    
else
   depunct_bits = depunct_mat(:).';
end
