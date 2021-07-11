% Create the pilot sequence, see 3GPP TS 36.211 version 9.1.0
% Release 9, 6.10.1.1
%
% These sequences need to be generated only once
%
function [pilot_sym] = get_pilot_sym(Ns,cell_id,N_RB)

pilot_sym = zeros(2,2*N_RB);

c_init = get_c_init(0,Ns,cell_id);
c0 = (1-2*reshape(get_random_c(4*N_RB,c_init),[2 2*N_RB]))/sqrt(2);
pilot_sym(1,:) = c0(1,:) + 1j*c0(2,:);
c_init = get_c_init(4,Ns,cell_id);
c4 = (1-2*reshape(get_random_c(4*N_RB,c_init),[2 2*N_RB]))/sqrt(2);
pilot_sym(2,:) = c4(1,:) + 1j*c4(2,:);

% Validated with Skander's code
function [c_init] = get_c_init(l,Ns,cell_id)
c_init = 2^10 * (7*(Ns+1)+l+1)*(2*cell_id+1)+2*cell_id+1;
end


end
