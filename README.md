# Lab2_robotica
# Estudiantes: Alejandra Rojas - Juan Diego Plaza
## Ejercicios en el laboratorio:
***
De manera preliminar se pide medir las longitudes entre cada articulación, estas medidas son:
<img src="https://i.postimg.cc/vm1r954x/longitudes-robot.png" alt="drawing" width="400"/>

L0=38.5

L1=105.7

L2= 106

L3=65.7

Una vez se han determinado las longitudes entre articulaciones, se presenta el robot con la herramienta SerialLink de Matlab junto con los parámetros DH calculados previamente, a continuación se muestra el código utilizado y los resultados obtenidos:

```
l0=38.5;
l1=105.7;
l2=106;
l3=65.7;
L(1) = Link('revolute','alpha',-pi/2,'a',0,'d',l0,'offset',-pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(2) = Link('revolute','alpha',0,'a',l1,'d',0,'offset',-pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(3) = Link('revolute','alpha',0,'a',l2,'d',0,'offset',0,'qlim',[-3*pi/4 3*pi/4]);
L(4) = Link('revolute','alpha',0,'a',l3,'d',0,'offset',0,'qlim',[-3*pi/4 3*pi/4]);
Robot = SerialLink(L,'name','Px')
q=[0 0 0 0];
Robot.plot(q,'notiles','noname');
```
Parámetros DH:

<img src="https://i.postimg.cc/qRnzxb7g/parametros-DH.png" alt="drawing" width="400"/>

Presentación del robot con los parámetros DH mostrados anteriormente:

<img src="https://i.postimg.cc/65rpFx3S/robotmatlab.png" alt="drawing" width="400"/>
***


