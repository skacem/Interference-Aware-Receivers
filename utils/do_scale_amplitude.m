function s = do_scale_amplitude(d, Amp_Max)

% Scale the signal amplitude according to the maximum value Amp_Max. This
% maximum value should be the upperbound of both the real and imaginary parts
% of the scale signal s

if size(d,1)>1
    d = d.';
end

Max_re_im 	= max([abs(real(d)),abs(imag(d))]);

s 		= d*(Amp_Max/Max_re_im);
