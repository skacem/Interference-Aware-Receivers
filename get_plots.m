% script get_plots


semilogy(sir_dB, BER,'g-o')

xlabel('SIR [dB]');
ylabel('BER');

%legend('with channel equalization','without channel Equalization')
title( {'BER vs SIR by IAR (SNR = 25 dB) '})
grid on;


hold on;
semilogy(sir_dB, BER,'r-*')
%semilogy(sir_dB, BER,'g-v')


printIEEE([ FIGURE_DIR 'IARholes_vs_NIAR.eps'] ) ;
saveas(gcf, [ FIGURE_DIR 'IARholes_vs_NIAR.pdf'] ) ;
saveas(gcf, [ FIGURE_DIR 'IARholes_vs_NIAR.fig'] ) ;



save( [RESULT_DIR 'test.mat'],  'BER', 'sir_dB') 