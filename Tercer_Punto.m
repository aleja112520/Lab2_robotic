
close all;
l = [39 105.7, 106, 65.7]; % Longitudes eslabones
% Definicion del robot RTB
L(1) = Link('revolute','alpha',-pi/2,'a',0,   'd',l(1),'offset',-pi/2,   'qlim',[-3*pi/4 3*pi/4]);
L(2) = Link('revolute','alpha',0,   'a',l(2),'d',0,   'offset',-pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(3) = Link('revolute','alpha',0,   'a',l(3),'d',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(4) = Link('revolute','alpha',0,   'a',l(4),   'd',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
Robot = SerialLink(L,'name','Px');

Robot.tool = [0 0 1 0;
              1 0 0 0;
              0 1 0 0;
              0 0 0 1];
ws = [-200 200];
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
Robot.plot(q*pi/180,'notiles','noname');
Robot.teach()

%%
q1 = [0 0 0 0 0];
q2 = [-20 20 -20 20 0];
q3 = [30 -30 30 -30 0];
q4 = [-90 15 -55 17 0];
q5 = [-90 45 -55 45 10];

Q = [q1; q2; q3; q4; q5];

%%
msg.AddrName = "Goal_Position";
pause(2);

for i=1:size(Q,1)
    for j=1:4
        msg.Id = j;
        msg.Value = mapfun(Q(i,j),-150,150,0,1023);
        call(cliente,msg);
        pause(1);
    end
    
    Robot.plot(Q(i,1:4)*pi/180,'notiles','noname');
    Robot.teach()
    pause(4);
end



%%
rosshutdown
%%
mapfun(30,-150,150,0,1023)
%%
function output = mapfun(value,fromLow,fromHigh,toLow,toHigh)
narginchk(5,5)
nargoutchk(0,1)
output = (value - fromLow) .* (toHigh - toLow) ./ (fromHigh - fromLow) + toLow;
end
