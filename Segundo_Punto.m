
%%
rosinit; %Conexion con nodo maestro
%%
cliente = rossvcclient('/dynamixel_workbench/dynamixel_command'); %Creación de cliente de pose y posición
msg = rosmessage(cliente); %Creación de mensaje
%%
% x = input(prompt);

msg.AddrName = "Goal_Position";
pause(2);
p = [30 30 30 30 30];
% p = [0 0 0 0 0];
for i=1:5
    msg.Id = i;
    msg.Value = mapfun(p(i),-150,150,0,1023);
    call(cliente,msg);
    pause(1);
end
%%
sub = rossubscriber('/dynamixel_workbench/joint_states');
sub.LatestMessage.Position

%%
rosshutdown
%%
function output = mapfun(value,fromLow,fromHigh,toLow,toHigh)
narginchk(5,5)
nargoutchk(0,1)
output = (value - fromLow) .* (toHigh - toLow) ./ (fromHigh - fromLow) + toLow;
end