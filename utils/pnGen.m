function  c = pnGen(c_init, Nseq)

%
% Function Description: 
%
%   Pseudo-random sequence generation
%   31 bits Gold sequence (TS 36.211 p.98)
%   note:
%       It can be used to generate the CS-RS, scrambling sequence,
%       or synchronization signals. Only the c_init will change.
%
% input parameters:
%       "c_init"    : physical layer cell identity
%       "Nseq"      : pn-seq size
%
% output parameter:
%       "c"         : pn-sequence 

% Date:         2012
% Version:      0.1


Nc = 1600;

% place holder
x1 = [1 zeros(1, Nseq+Nc)];
x2 = [1 zeros(1, Nseq+Nc)];
c = zeros(1,Nseq);

% generate the first m-sequence x1:
for n = 1 : Nseq + Nc - 31
    x1(n+31) = mod( (x1(n+3) + x1(n)),2);
end

% generate the second m-sequence x2:
x2_1 = dec2bin(c_init);    
x2_2 = zeros(1,31 - size(x2_1,2));
x2(1:31) = [x2_1 x2_2];

for k=1: Nc +  Nseq  - 31
   x2(k + 31) = mod((x2(k + 3) + x2(k + 2) + x2(k + 1) + x2(k)),2);
end

% generate Pseudo-random sequence 
for i = 1:  Nseq
    c(i) = mod((x1(i + Nc) + x2(i + Nc)),2);
end