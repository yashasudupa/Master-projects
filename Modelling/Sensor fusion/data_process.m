Twait = [1 0.4 1];
Trise = [2 3  5];
Hrise = [2 3 -4];


[x,xd,xdd,t] = func_KF_MotionData_Gen(Twait, Trise, Hrise, Ts)

EPSQ = 0.01
[x_k, xd_k ,xdd_k, xd_new, xdd_new]=KalmamFilter(x, xd ,xdd,EPSQ );

figure(2),
clf
hold on,set(gca,'FontSize',26),set(gcf,'Color','White');
subplot(3,1,1),set(gca,'FontSize',26), hold on
plot(t,x_k,'LineWidth',2)
grid minor
ylabel('x (m)')
axis tight

subplot(3,1,2),set(gca,'FontSize',26), hold on
plot(t,xd_new,'r','LineWidth',2)
plot(t,xd_k,'LineWidth',2);
plot(t,xd,'g','LineWidth',2);
grid minor
ylabel('v (m/s)')
axis tight

subplot(3,1,3),set(gca,'FontSize',26), hold on
plot(t,xdd_new,'r','LineWidth',2);
plot(t,xdd_k,'LineWidth',2);


grid minor
ylabel('a (m/s^2)')
axis tight
xlabel('t (s)')

