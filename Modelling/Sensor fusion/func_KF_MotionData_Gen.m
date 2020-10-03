function [x,xd,xdd,t] = func_KF_MotionData_Gen(Twait, Trise, Hrise, Ts)
% Test signal generator for moving mass (F=ma)
%
% The input data specifies the temporal position. The interpolation is
% sinusoidal.
% 
%                   Twait(2)
%               ---------------------
%              /                     \  
%             /                       \  Twait(2), Hrise(2)
%            /  Trise(1)               \
% t=0       /   Hrise(1)                -------------- 
% ---------/      
%         Twait(1)
% 
% 
% In addition the velocity and the acceleration are computed
% The sinusoidal function is used, as it allows to compute all derivativs 
%     
% Neumayer 2016

Tges = sum(Twait)+sum(Trise);
t = 0:Ts :Tges + 4;


x = zeros(size(t));  
xd = zeros(size(t));  
xdd = zeros(size(t));  


tstart = Twait(1);
tend   = tstart + Trise(1); 
Hges = 0;
for ii = 1:length(Twait)  
  [~,id1] =min(abs(t-tstart));
  [~,id2] =min(abs(t-tend));  
  
  Trisei = Trise(ii);
  Hrisei = Hrise(ii);
  
  id = id1:id2;
  ti = t(id);
  theta = -pi/2 + (ti-tstart)/ Trisei * pi;
  
  xi  = Hrisei*0.5*(sin(theta)+1);
  xid  = Hrisei*0.5*(cos(theta))* pi/Trisei;
  xidd = Hrisei*0.5*(-sin(theta))* (pi/Trisei)^2;
  
  x(id)  = x(id) + xi;
  xd(id) = xid;
  xdd(id) = xidd;
  
  Hges = Hges + Hrisei;
  x(id2:end) = Hges;
 if ii < length(Twait) 
  tstart = tstart + Trisei + Twait(ii+1);
  tend = tstart + Trise(ii+1);
 end
end
x  = x(:);
xd = xd(:);
xdd = xdd(:);