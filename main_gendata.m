clear;close all
%% Parameters
ensemble = 1;
Length = 1e5;
iteration = Length;
N = 16; % If N > 16, filter isn't probably stable anymore
N = 16; % If N > 16, filter isn't stable anymore
N = 8; % If N > 16, filter isn't stable anymore
MSE = zeros(iteration, ensemble);
% IQ Imbalance Parameters
GainIm = 2.5; % in dB if N >= 16, GainIm max is 2.5, otherweise divergence
PhaseIm = 10; % in degree
real_iqim = 10^(0.5*GainIm/20)*exp(-i*0.5*PhaseIm*pi/180)
imag_iqim = 10^(-0.5*GainIm/20)*exp(i*0.5*PhaseIm*pi/180)
% AWGN
PowerAWGN = -30; % in dB 0
% Channel Distortion
H = [1.1 + j*0.5, 0.1-j*0.3, -0.2-j*0.1]; % 3 Taps
% Phase Noise
Level = -35;
Level = -40;
FrequencyOffset = 10;
% LMS
S = struct('step',0.001, 'filterOrderNo',11,'initialCoefficients',randn(4,1), 'modulationNo', N);
e = 0;
% Record x's changes
x_record = zeros(Length, 2);
%% Do
w = 0;
for k = 1:ensemble
    [x, data] = GenerateQAMData(Length, N); % Generate Data
    y_desired = x;
%     x = conv(x, H, 'same'); % Channel Distortion
%     x = iqimbal(x, GainIm, PhaseIm); % IQ Imbalance
    x = conv(x, H, 'same'); % Channel Distortion
    x = iqimbal(x, GainIm, PhaseIm); % IQ Imbalance
    x = AddPhaseNoise(x, Level, FrequencyOffset); % Phase Noise
    x = x+wgn(Length, 1, PowerAWGN, 'complex'); % AWGN
    
    dirty_x = x;
    
%     [x, e, w]  =   ModifiedCMA(x, S); % for channel distortion
%     [x, e, w] = CircularityBasedApproach(x, 1, 1e-5, iteration); % for IQ Imbalance
    x = AddKNNClassifier(x, y_desired);
%     MSE(:,k) = e;
    [x, e, w]  =  LMSCompensator(x, y_desired, S); % for channel distortion
    x_record(:,1) = x;
    [x, e, w] = CircularityBasedApproach(x, 1, 1e-5, iteration); % for IQ Imbalance
    x_record(:,2) = x;
    MSE(:,k) = e;
end



MSE_av = sum(MSE, 2)/ensemble;

% scatterplot(x(S.filterOrderNo:end))
normalized_x = Normalization(x(S.filterOrderNo:end-4));
Plot4QAM(normalized_x, dirty_x);
PlotWeightChange(transpose(w));
PlotMSEindB(MSE_av);
w(end)
mag2db(abs(imag(w(end))/real(w(end))))
atan(imag(w(end))/real(w(end)))/pi*180
save('C:\Users\Liu Yang\Documents\GitHub\FA\MyFA\Data\dirtorted_16QAM', 'y_desired', 'dirty_x');

save('x_record.mat', 'x_record', 'y_desired');
