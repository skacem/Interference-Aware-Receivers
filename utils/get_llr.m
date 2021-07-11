function softbit = get_llr(input,mod_order)

softbit = zeros(1,mod_order*length(input));

switch(mod_order)
    case 1,
    softbit = real(input) ;

    case 2,
               
        softbit1 = real(input);
        softbit2 = imag(input);
        softbit = kron(softbit1.', [1 0]) + kron(softbit2.',[0 1]); 
end
