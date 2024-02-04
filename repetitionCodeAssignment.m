% BER for BPSK modulation with Repetition code (n=3) in an AWGN channel
clear
N = 10^5; % number of bits
n = 3; % length of repetition code
% Transmitter
ip = rand(1,N)>0.5; % generating 0,1 with equal probability
s =2*ip-1; % BPSK modulation 0 -> -1; 1 -> 1 
coded=[];
for j=1:length(ip)
    rep_c=s(j)*ones(1,n);
    coded= [coded rep_c];
end
SNR_dB = [-3:15]; % multiple Eb/N0 values
for ii = 1:length(SNR_dB)
     % AWGN Channel Generation
     w = 1/sqrt(2*10^(SNR_dB(ii)/10))* [randn(1,N) + 1i*randn(1,N)]; % white gaussian noise, 0dB variance 
     coded_w=1/sqrt(2*10^(SNR_dB(ii)/10))*(randn(1,n*N) + 1i*randn(1,n*N));
     
     % Channel and noise Noise addition
     y = s + w; 
     y_coded= coded + coded_w;
     % receiver - hard decision decoding
     ipHat = real(y)>0;
     coded_ipHat=real(y_coded)>0;
     decoded_ip=[];
     for j= 1:n:length(coded_ipHat)
        num_ones = length(find(coded_ipHat(j:j+n-1)==1));
        if num_ones>= (n+1)/2
            dec_ip= 1;
        else
            dec_ip= 0;
        end
        decoded_ip=[decoded_ip dec_ip];
     end
 % counting the errors
 nErr(ii) = size(find([ip~=ipHat]),2);
decoded_nErr(ii) = size(find([ip~=decoded_ip]),2);
end
simBer = nErr/N; % simulated ber
decoded_simBer = decoded_nErr/N; % simulated ber
theoryBerAWGN = 0.5*erfc(sqrt(10.^(SNR_dB/10))); % theoretical ber
SNRLin = 10.^(SNR_dB/10);
theoryBer = 0.5.*(1-sqrt(SNRLin./(SNRLin+1)));

% plot
close all
figure
semilogy(SNR_dB,theoryBerAWGN,'rd-','LineWidth',1);
hold on
semilogy(SNR_dB,simBer,'bp-','LineWidth',1);
semilogy(SNR_dB,decoded_simBer,'kp-','LineWidth',1);
axis([-3 15 10^-5 0.5])
grid on
legend('Uncoded BPSK AWGN-Theory','Uncoded BPSK AWGN-Simulation', 'Repetition Code BPSK AWGN-Simulation');
xlabel('SNR (dB)');
ylabel('Probability of Error for BPSK');
title('BER for BPSK modulation in AWGN channel');