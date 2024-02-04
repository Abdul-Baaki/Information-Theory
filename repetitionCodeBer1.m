% BER for BPSK modulation in an AWGN channel
clear
N = 10^6; % number of bits
% Transmitter side
ip = rand(1,N)>0.5; % generating 0,1 with equal probability
s =2*ip-1; % BPSK modulation 0 -> -1; 1 -> 1
SNR_dB = [-3:15]; % multiple Eb/N0 values
for ii = 1:length(SNR_dB)
    % AWGN Noise generation
    n = 1/sqrt(2*10^(SNR_dB(ii)/10))*[randn(1,N) + 1i*randn(1,N)]; % white gaussian noise, 0dB variance 
     
    % Channel and Noise addition
    y = s + n; 
    % receiver - hard decision decoding
    ipHat = real(y)>0;
    % counting the errors
    nErr(ii) = size(find([ip~=ipHat]),2);
end
simBer = nErr/N; % simulated ber
theoryBerAWGN = 0.5*erfc(sqrt(10.^(SNR_dB/10))); % theoretical ber
SNRLin = 10.^(SNR_dB/10);
theoryBer = 0.5.*(1-sqrt(SNRLin./(SNRLin+1)));
% plot
close all
figure
semilogy(SNR_dB,theoryBerAWGN,'rd-','LineWidth',1);
hold on
semilogy(SNR_dB,simBer,'bp-','LineWidth',1);
axis([-3 15 10^-5 0.5])
grid on
legend('Uncoded BPSK AWGN-Theory','Uncoded BPSK AWGN-Simulation');
xlabel('SNR (dB)');
ylabel('Probability of Error for BPSK');
title('BER for BPSK modulation in AWGN channel');