
close all;
l = [14.5, 10.7, 10.7, 9]; % Longitudes eslabones
% Definicion del robot RTB
L(1) = Link('revolute','alpha',pi/2,'a',0,   'd',l(1),'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(2) = Link('revolute','alpha',0,   'a',l(2),'d',0,   'offset',pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(3) = Link('revolute','alpha',0,   'a',l(3),'d',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(4) = Link('revolute','alpha',0,   'a',0,   'd',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
Robot = SerialLink(L,'name','Px');
ws = [-50 50];
% Graficar robot

%%
rosinit;
%%
cliente = rossvcclient('/dynamixel_workbench/dynamixel_command'); %Creación de cliente de pose y posición
msg = rosmessage(cliente); %Creación de mensaje
%%
msg.AddrName = "Goal_Position";
pause(2);
q = [30 30 30 30];
% q = [0 0 0 0];
for i=1:4
    msg.Id = i;
    msg.Value = mapfun(q(i),-150,150,0,1023);
    call(cliente,msg);
    pause(1);
end
Robot.plot(q,'notiles','noname');
axis([repmat(ws,1,2) 0 60])
Robot.teach()

%%
rosshutdown
%%
function output = mapfun(value,fromLow,fromHigh,toLow,toHigh)
narginchk(5,5)
nargoutchk(0,1)
output = (value - fromLow) .* (toHigh - toLow) ./ (fromHigh - fromLow) + toLow;
end