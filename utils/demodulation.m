function [data_hat] = demodulation(rx_data_signal,M)

if M == 1
  data_hat = zeros(1,length(rx_data_signal));
  idx0 = find(real(rx_data_signal) > 0);
  idx1 = find(real(rx_data_signal) < 0);
  data_hat(1,idx1) = 1;
elseif M == 2
  data_hat = zeros(2,length(rx_data_signal));
  idx0 = find(real(rx_data_signal) > 0);
  idx1 = find(real(rx_data_signal) < 0);
  data_hat(1,idx1) = 1;
  idx0 = find(imag(rx_data_signal) > 0);
  idx1 = find(imag(rx_data_signal) < 0);
  data_hat(2,idx1) = 1;
  % Reshape
  data_hat = reshape(data_hat,[1 2*length(rx_data_signal)]);
else
  error('Invalidation modulation order');  
end

end