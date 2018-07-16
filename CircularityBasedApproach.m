% used by test_LMSandIQCompensator
function [compSig,estCoef, error] = CircularityBasedApproach(input, order, stepSize, iteration) 
% N=order;
% x=input;
% x_v=zeros(N,1);
% w_v=zeros(N,length(input)+1);
% y_v=input(N:-1:1);
% y=zeros(size(input));
% for m=N:length(input)
%     x_v = input(m:-1:m-N+1);
%     y(m)=x(m)+w_v(:,m).'*conj(x_v);
%     y_v=[y(m);y_v(N:-1:2)];
%     w_v(:,m+1)=w_v(:,m)-stepSize*y_v*y(m);
% end
% 
% input=input.';
% data_v=toeplitz([input(1) zeros(1,N-1)],[input zeros(1,N-1)]);
% compSig=(input+w_v(:,end).'*data_v(:,1:length(input))'.').';
% 
% estCoef=w_v;
error = 0;
%%
w_v = rand(order, 1);
y_v = zeros(order, 1);
M = ones(order)*stepSize;
error = zeros(iteration-order+1,1);

for k = order:iteration
    x = input(k);
    x_v = input(k:-1:k-order+1);
    y = x+w_v.'*x_v'.';
    y_v = [y;y_v(order:-1:2)];
    w_v = w_v-M*y_v*y;
    error(k-order+1) = sum(y_v*y);
end
% w_v = fliplr(w_v);


input=input.';
data_v=toeplitz([input(1) zeros(1,order-1)],[input zeros(1,order-1)]);
compSig=(input+w_v.'*data_v(:,1:length(input))'.').';

% compSig = input+conv(input, w_v, 'same');
estCoef = w_v;
