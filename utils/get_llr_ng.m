function softbit = get_llr_ng(input,H,M)
global phy_param;

mod_order = M;
y1 = input(1).data;

softbit = zeros(1,mod_order*length(y1));


if (phy_param.IC_Method == 0)|| (phy_param.IC_Method == 4)
    switch(mod_order)
        case 1,
            softbit = real(y1) ;
            
        case 2,
            
            softbit1 = real(y1);
            softbit2 = imag(y1);
            softbit = kron(softbit1.', [1 0]) + kron(softbit2.',[0 1]);
    end
    
else
    
    y2 = input(2).data;
    cor = conj(H(1).data_hat).* H(2).data_hat; % 7x7 Matrix
    rho = (real(cor) + imag(cor))/2 ;
    rhoC = (real(cor) - imag(cor))/2 ;
    switch(mod_order)
        case 1,
            error('Not yet implemented!')
            
        case 2,
            softbit1 = max(abs(real(y2) - rho) + abs(imag(y2) - rhoC) + imag(y1), ...
                abs(real(y2) - rhoC) + abs(imag(y2) + rho) - imag(y1))/2 ...
            - max(abs(real(y2) + rhoC) + abs(imag(y2) - rho) + imag(y1), ...
                abs(real(y2) + rho) + abs(imag(y2) + rhoC) - imag(y1))/2 ...
            + real(y1);
            
            softbit2 = max(abs(real(y2) - rho) + abs(imag(y2) - rhoC) + real(y1), ...
                abs(real(y2) + rhoC) + abs(imag(y2) - rho) - real(y1) )/2 ...
            - max(abs(real(y2) - rhoC) + abs(imag(y2) + rho) + real(y1), ...
                abs(real(y2) + rho) + abs(imag(y2) + rhoC) - real(y1))/2 ...
            + imag(y1);
        
         softbit = kron(softbit1.', [1 0]) + kron(softbit2.',[0 1]); 
            
    end
    
    
    
end
