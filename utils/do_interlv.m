function [output perm] = do_interlv(coded_bits, type)

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



l = length(coded_bits);


if strcmp(type, 'lte')
    
    perm  = get_qpp_idx(l);
    y = l/length(perm);
    sig = reshape(coded_bits,y,[]);
    output = reshape(sig(:,perm),1,[]);
    
end


% default ideal
if (nargin <2); type = 'ideal';end

if strcmp(type, 'ideal')
    % permutation
    perm = randperm(l);
    output = coded_bits(perm);
end

