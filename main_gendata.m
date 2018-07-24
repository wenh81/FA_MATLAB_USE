clear;close all
%% Parameters
ensemble = 1;
Length = 1e5;
iteration = Length;
<<<<<<< HEAD
N = 16; % If N > 16, filter isn't stable anymore
=======
N = 8; % If N > 16, filter isn't stable anymore
>>>>>>> 96659eaefa1fd5a9a096ee72755bb026656cab81
MSE = zeros(iteration, ensemble);
% IQ Imbalance Parameters
GainIm = 5; % in dB
PhaseIm = 20; % in degree
real_iqim = 10^(0.5*GainIm/20)*exp(-i*0.5*PhaseIm*pi/180)
imag_iqim = 10^(-0.5*GainIm/20)*exp(i*0.5*PhaseIm*pi/180)
% AWGN
PowerAWGN = -30; % in dB 0
% Channel Distortion
H = [1.1 + j*0.5, 0.1-j*0.3, -0.2-j*0.1]; % 3 Taps
% Phase Noise
<<<<<<< HEAD
Level = -35;
=======
Level = -40;
>>>>>>> 96659eaefa1fd5a9a096ee72755bb026656cab81
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
<<<<<<< HEAD
%     x = conv(x, H, 'same'); % Channel Distortion
%     x = iqimbal(x, GainIm, PhaseIm); % IQ Imbalance
=======
    x = conv(x, H, 'same'); % Channel Distortion
    x = iqimbal(x, GainIm, PhaseIm); % IQ Imbalance
>>>>>>> 96659eaefa1fd5a9a096ee72755bb026656cab81
    x = AddPhaseNoise(x, Level, FrequencyOffset); % Phase Noise
    x = x+wgn(Length, 1, PowerAWGN, 'complex'); % AWGN
    
    dirty_x = x;
    
<<<<<<< HEAD
%     [x, e, w]  =   ModifiedCMA(x, S); % for channel distortion
%     [x, e, w] = CircularityBasedApproach(x, 1, 1e-5, iteration); % for IQ Imbalance
    x = AddKNNClassifier(x, y_desired);
%     MSE(:,k) = e;
=======
    [x, e, w]  =  LMSCompensator(x, y_desired, S); % for channel distortion
    x_record(:,1) = x;
    [x, e, w] = CircularityBasedApproach(x, 1, 1e-5, iteration); % for IQ Imbalance
    x_record(:,2) = x;
    MSE(:,k) = e;
>>>>>>> 96659eaefa1fd5a9a096ee72755bb026656cab81
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
<<<<<<< HEAD
save('C:\Users\Liu Yang\Documents\GitHub\FA\MyFA\Data\dirtorted_16QAM', 'y_desired', 'dirty_x');
=======

save('x_record.mat', 'x_record', 'y_desired');
>>>>>>> 96659eaefa1fd5a9a096ee72755bb026656cab81
