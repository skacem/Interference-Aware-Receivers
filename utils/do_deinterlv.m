function [output] = do_deinterlv(inp, perm)

%
% Function Description:
%
%
% input parameters:
%       "coded_bits"    : coded bits
%       "type"          : "ideal" interleaver, or "finite_depth" interlv
%       "depth"         : if "finite_depth" length, depth of the interlv
%
% output parameter:
%       "output"    : interleaved bits
%       "perm"      : permutation pattern for de-interleaving purposes

% Date:         2012
% Version:      0.1

if nargin ~= 2; error('Wrong number of arguments!');end
if mod(length(inp), length(perm))
    error('input must be as long as perm or divisible by perm');
end

[~, inv_perm] = sort(perm);

y = length(inp)/length(perm);
tmp = reshape(inp,y,[]);
output = reshape(tmp(:,inv_perm),1,[]);