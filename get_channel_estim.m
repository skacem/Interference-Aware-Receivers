function [ output H_hat]= get_channel_estim(input, masks, pilot_sym)


%
% Function Description:
% LTE channel estimation and interpolation
%   
%
%
% input parameters:
%       "input"     : Received REs
%       "masks"     : 
%       "pilots"
%
% output parameter:
%       "output"    : 300x7 matrix of channel coefficients
%       "H_hat"     : Channel estimates on the REs carriying the pilots (2x50 Matrix)    

% Date:         2012
% Version:      0.1


H_hat_ext_0 = zeros(1,300);
H_hat_ext_4 = zeros(1,300);
output =  zeros(300,7);

H_hat = reshape(input(masks.pilot==1),[],2).' .* conj(pilot_sym);
idx = masks.pilot(:,[1 5]).';
start_pilot = [ find(idx(1,1:6))  find(idx(2,1:6)) ];


% Linear Interpolation frequency domain

i = 1 : 5;
x = 6;
sp0 = start_pilot(1) + 1;
sp1 = start_pilot(2) +1;
s = 0;
for k = 1:50 -1
    H_hat_ext_0(sp0 + (x*s)  : sp0 + length(i) - 1 + (x*s) ) = ((H_hat(1,k+1) - H_hat(1,k))./x)*i ...
        + repmat(H_hat(1,k),1,length(i));
    H_hat_ext_4(sp1+ (x*s)  : sp1 + length(i)-1 + (x*s)  ) = ((H_hat(2,k+1) - H_hat(2,k))./x)*i ...
        + repmat(H_hat(2,k),1,length(i));
    s=s+1;
end
H_hat_ext_0(idx(1,:)==1) = H_hat(1,:);
H_hat_ext_4(idx(2,:)==1) = H_hat(2,:);

H_hat_ext_0(1:start_pilot(1)-1) = -(H_hat_ext_0(sp0) - H_hat(1,1))*(1:start_pilot(1)-1)...
    + H_hat(1,1);
H_hat_ext_0(end - x + start_pilot(1)  +1: end ) = -(H_hat_ext_0(end-x+start_pilot(1)-1) ...
    - H_hat(1,end))*(1:x - start_pilot(1)) + H_hat(1,end);
H_hat_ext_4(start_pilot(2)-1:-1:1) = -( H_hat_ext_4(sp1) - H_hat(2,1))*(1:start_pilot(2)-1) ...
   + H_hat(2,1);
H_hat_ext_4(end - x + start_pilot(2)  +1: end ) = -(H_hat_ext_4(end-x+start_pilot(2)-1) ...
    - H_hat(2,end))*(1:x - start_pilot(2)) + H_hat(2,end);



% Linear Interpolation time domain
output(:, [1 5]) = [H_hat_ext_0.' H_hat_ext_4.'];
output(:,2) = (3/4)*(output(:,1)) + (1/4)*(output(:,5));
output(:,3) = (1/2)*(output(:,1)) + (1/2)*(output(:,5));
output(:,4) = (1/4)*(output(:,1)) + (3/4)*(output(:,5));
output(:,[6 7]) = -( output(:,4) - output(:,5) )*(1:2) + repmat(output(:,5),1,2);
