function [data_sym] = modulation(data,M)

if M == 1
  data_stream_q = (1-(2*data))/sqrt(2);
  data_sym = data_stream_q(1,:) + 1j*data_stream_q(1,:);
elseif M == 2
  data_stream = reshape(data,[M length(data)/M]);
  data_stream_q = (1-(2*data_stream))/sqrt(2);
  data_sym = data_stream_q(1,:) + 1j*data_stream_q(2,:);
else
  error('Invalidation modulation order');
end

end
