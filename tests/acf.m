function y=acf(s)

if size(s,1)==1
    s=s.';
end

L=length(s);


if mod(L,2)~=0
    L=L-1;
    s=s(1:end-1);
end

y=zeros(1,2*L-1);

s_=[zeros(1,L/2) s.'];

for i_l=1:2*L-1
    i_l
    y(i_l)=[s_(i_l+1:end) zeros(1,L/2-1+i_l)]*conj([s;zeros(L-1,1)])/(2*L);
end
