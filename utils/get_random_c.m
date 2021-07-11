%
% See 3GPP TS 36.211 version 9.1.0 Release 9, Section 7.2
%
function [c] = get_random_c(L,init_x2_dec)

Nc = 1600;
x1 = zeros(1,31);
x2 = dec2bin(init_x2_dec)-'0'; % Shorter than 32 bits
x2 = [x2 zeros(1,32-length(x2))];
c  = zeros(1,L);

% Init
x1(1) = 1;
x2(1) = 1;

% Run initial 1600 bits
for k = 1:1600
  [out1,out2,x1,x2] = get_x_out(x1,x2);
end

for k = 1:L
  [out1,out2,x1,x2] = get_x_out(x1,x2);
  c(k) = mod(out1 + out2,2);
end

function [out1,out2,x1,x2] = get_x_out(x1,x2)
  out1 = mod(x1(31) + x1(28),2);
  out2 = mod(x2(31) + x2(30) + x2(29) + x2(28),2);
  x1 = circshift(x1,[0 1]); x1(1) = out1;
  x2 = circshift(x2,[0 1]); x2(1) = out2;
end

end