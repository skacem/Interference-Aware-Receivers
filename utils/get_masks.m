% Generate positions of pilots and data
function [masks] = get_masks(N_RB,N_sc,N_symb,cell_id)

masks.pilot = zeros(N_RB*N_sc,N_symb);
masks.data = ones(N_RB*N_sc,N_symb);

% Pilot position generation (per slot)
[k0,k4] = pilot_position(N_RB,cell_id);
% For debugging, put a 1 at the pilot position
masks.pilot(k0+1,1) = 1; % The +1 is to adapt to 1,N matlab notation
masks.pilot(k4+1,5) = 1;
%pilot_mask % Debug: show the pilot position

% Create a data mask
masks.data = masks.data - masks.pilot;
masks.data(:,1:3) = 0;
%data_mask % Debug

% Calculate the position of the pilots
function [k0,k4] = pilot_position(N_RB,cell_id)
  % We assume antenna port 0
  p = 0;
  v_shift = mod(cell_id,6);

  % rows: k = 6m + (v + vshift )mod 6, columns l=⎪⎨0,Nsymb−3
  % if p in {0,1} i.e. = 0,4 for N_symb = 7;
  m = 0:1:2*N_RB-1;
  k0 = 6*m + mod(0 + v_shift,6);
  k4 = 6*m + mod(3 + v_shift,6);
end


end
