clear

N = 10^5; % number of bits
SNR_dB = 0; % SNR in dB

n_values = [5, 7, 9]; % repetition code lengths

for n_index = 1:length(n_values)
    n = n_values(n_index);

    % Transmitter
    ip = rand(1, N) > 0.5; % generating 0, 1 with equal probability
    s = 2 * ip - 1; % BPSK modulation: 0 -> -1, 1 -> 1
    coded = repelem(s, n); % repetition coding

    % AWGN Channel Generation
    w = 1/sqrt(2*10^(SNR_dB/10)) * (randn(1, N * n) + 1i * randn(1, N * n)); % white Gaussian noise
    y_coded = coded + w; % received signal with noise

    % Receiver - hard decision decoding
    coded_ipHat = real(y_coded) > 0;
    decoded_ip = reshape(coded_ipHat, n, N);
    decoded_ip = sum(decoded_ip) >= (n + 1) / 2;

    % Counting the errors
    decoded_nErr(n_index) = sum(ip ~= decoded_ip);
end

% Simulated BER
decoded_simBer = decoded_nErr / N;

fprintf('Simulated BER for BPSK with repetition codes:\n');
for n_index = 1:length(n_values)
    fprintf('n = %d: %e\n', n_values(n_index), decoded_simBer(n_index));
end
