% --------------------------------------- %
%  test ideal interleaver/de-interleaver  %
% --------------------------------------- %

n_bits = 6144*2;
bits = randi([0 1], 1,n_bits);

% Interleaving
%[interlv_bits perm] = do_interlv(bits,'ideal');
[interlv_bits perm] = do_interlv(bits,'lte');

% Deinterleaving
deint_bits = do_deinterlv(interlv_bits,perm);


if sum(deint_bits~=bits)
    
   error('Something goes wrong!!'); 
    
end