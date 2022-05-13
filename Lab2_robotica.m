l0=39;
l1=105.7;
l2=106;
l3=65.7;
L(1) = Link('revolute','alpha',-pi/2,'a',0,'d',l0,'offset',-pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(2) = Link('revolute','alpha',0,'a',l1,'d',0,'offset',-pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(3) = Link('revolute','alpha',0,'a',l2,'d',0,'offset',0,'qlim',[-3*pi/4 3*pi/4]);
L(4) = Link('revolute','alpha',0,'a',l3,'d',0,'offset',0,'qlim',[-3*pi/4 3*pi/4]);
Robot = SerialLink(L,'name','Px')
Robot.tool=[0 0 1 0;
            1 0 0 0;
            0 1 0 0;
            0 0 0 1];
figure();
q1=[0 0 0 0];
Hbt1=L(1).A(q1(1))*L(2).A(q1(2))*L(3).A(q1(3))*L(4).A(q1(4))
Robot.plot(q1,'notiles','noname');
Robot.plot(q1,'notiles','noname');

figure();
q2=[0 0 pi/2 pi/2];
Hbt2=L(1).A(q2(1))*L(2).A(q2(2))*L(3).A(q2(3))*L(4).A(q2(4))
Robot.plot(q2,'notiles','noname');

figure();
q3=[pi pi/3 pi/3 pi/8];
Hbt3=L(1).A(q3(1))*L(2).A(q3(2))*L(3).A(q3(3))*L(4).A(q3(4))
Robot.plot(q3,'notiles','noname');

figure();
q4=[-pi/3 -pi/3 -pi/3 -pi/3];
Hbt4=L(1).A(q4(1))*L(2).A(q4(2))*L(3).A(q4(3))*L(4).A(q4(4))
Robot.plot(q4,'notiles','noname');