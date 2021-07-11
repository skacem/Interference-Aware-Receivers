function    y=ccf(a,b)
% y=ccf(a,b) cross correlation  function
N=min(length(a),length(b));
y=conv(a,conj(b(length(b):-1:1)))/N;