clear;close all
%% Parameters
Length = 4096;
N = 64;
% IQ Imbalance Parameters
GainIm = 5; % in dB
PhaseIm = 5; % in degree
% Channel Distortion
H = [1.1 + j*0.5, 0.1-j*0.3, -0.2-j*0.1]; % 3 Taps
% Phase Noise
Level = -50;
FrequencyOffset = 10;

%% Do
[x, y_hat] = GenerateQAMData(Length, N); % Generate Data
x = iqimbal(x, GainIm, PhaseIm); % IQ Imbalance
% x = conv(x, H, 'same'); % Channel Distortion
% x = AddPhaseNoise(x, Level, FrequencyOffset); % Phase Noise


[x, w, e] = CircularityBasedApproach(x, 1, 1e-5, 4096); 


scatterplot(x)
figure;
semilogy(abs(e))
grid on
grid minor
