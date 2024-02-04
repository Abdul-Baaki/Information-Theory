clear
close all
clc

%%
fprintf('ABDUL-BAAKI YAKUBU\n');
fprintf('INFORMATION THEORY, ASSIGNMENT\n');
fprintf('-------------------------------------------------\n')

%%
N = 10^5; % number of bits
SNR_dB = 0; % SNR in dB

n_values = [3, 5, 7, 9, 11]; % repetition code lengths

BER_values = zeros(1, length(n_values));

fprintf('Simulated BER for BPSK with repetition codes:\n');
figure; hold on;

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
    decoded_nErr = sum(ip ~= decoded_ip);

    % Calculate BER
    BER_values(n_index) = decoded_nErr / N;
    fprintf('n = %d: r = %f: BER = %e\n', n_values(n_index), 1/n, BER_values(n_index));

    % Plot the relationship between code rate and BER
    semilogx(1/n, BER_values(n_index), 'o-', 'LineWidth', 1.5);
end

grid on
xlabel('Code Rate (r = 1/n)');
ylabel('Bit Error Rate (BER)');
title('Code Rate vs BER for BPSK with Repetition Codes');

% Legend entries based on the number of repetition code lengths
legend('n = 3', 'n = 5', 'n = 7', 'n = 9', 'n = 11', ...
    'Location','northwest');
