function  [ x_k, xd_k, xdd_k, xd_new, xdd_new ] = KalmamFilter(x, xd ,xdd,EPSQ )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% initializing parameters

Ts = 0.01;
X = [0;0;0];                             %Initial state vectors
F = [ 1  Ts 0.5*Ts^2; 0 1 Ts; 0 0 1 ];   %State transition Matrix
P = [1 0 0; 0 1 0; 0 0 1];    %Covariance matrix for state vector. Initial covariance is assumed unity.
Q = [0 0 0; 0 0 0; 0 0 EPSQ];   % Initialisation of process noise covariance Q
H = [0 1 0; 0 0 1]; % measurement transformation Matrix,
R = [1 0; 0 1^2 ]; % measurement noise covariance matrix (sigma 1)^2 = 0.1; (Sigma2)^2 = 0.01


% generate noises
len = length(xd);
xd_new = xd + 1*randn(len,1);
xdd_new = xdd + 1*randn(len,1);
Z = [xd_new , xdd_new];

x_k = zeros(len,1);
xd_k = zeros(len,1);
xdd_k = zeros(len,1);


for i = 1:len
X_ = F*X;  %  Project the state ahead - prediction equation
P_ = F*P*F' + Q;  % Project the error covariance ahead - prediction equation

K = P_*H'*inv(H*P_*H' + R); % Compute the Kalman gain - Update equation
%                     2*3 3*1 2*1

X = X_ + K*( Z(i,:)'- H*X_);  % Upfdate estimate with measurement Zk - Update equation
P = (eye(3) - K*H )*P_;  %Upate the error covariance - Update equation

x_k(i,1) = X(1);    
xd_k(i,1) = X(2);
xdd_k(i,1) = X(3);


end




end

