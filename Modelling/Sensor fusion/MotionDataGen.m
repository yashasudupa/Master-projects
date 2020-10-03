% Statistical Signal Processing
% 
% Test of Motion Data Generator
% 
% Neumayer 2016
clear all, close all, clc


Twait = [1 0.4 1];
Trise = [2 3  5];
Hrise = [2 3 -4];

Ts = 0.01;

[x,xd,xdd,t] = func_KF_MotionData_Gen(Twait, Trise, Hrise, Ts)

figure(1),hold on,set(gca,'FontSize',26),set(gcf,'Color','White');
subplot(3,1,1),set(gca,'FontSize',26)
plot(t,x,'LineWidth',2)
grid minor
ylabel('x (m)')
axis tight

subplot(3,1,2),set(gca,'FontSize',26)
plot(t,xd,'LineWidth',2)
grid minor
ylabel('v (m/s)')
axis tight

subplot(3,1,3),set(gca,'FontSize',26)
plot(t,xdd,'LineWidth',2)
grid minor
ylabel('a (m/s^2)')
axis tight
xlabel('t (s)')