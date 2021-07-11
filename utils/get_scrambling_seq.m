% 3GPP TS 36.211 version 9.1.0 Release 9, Section 6.3.1
function [c] = get_scrambling_seq(L,Ns,cell_id,Nrnti)

c_init = get_c_init(0,Ns,cell_id,Nrnti);
c = get_random_c(L,c_init);

% For PDSCH
function [c_init] = get_c_init(q,Ns,Nrnti,cell_id)
c_init = (Nrnti*2^14)+(q*2^13)+(floor(Ns/2)*2^9)+cell_id;
end

end