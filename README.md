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

## ROS:

Con base en la documentación de los motores Dynamixel en ROS, cree un script en Python que publique a los
tópicos y llame a los servicios correspondientes para realizar el movimiento de cada una de las articulaciones
del manipulador (waist, shoulder, elbow, wrist). La lógica del script puede ser la siguiente:

-Se debe realizar el movimiento entre dos posiciones angulares características de cada articulación: una
de home y otra objetivo.
-Se le debe indicar al programa qué articulación se desea mover. Se debe imprimir en consola el nombre
de la articulación operando. La articulación a operar se cambia usando las teclas ’W’ y ’S’ de la siguiente
manera:

  -Con la tecla ’W’ se pasa a la siguiente articulación (si se está en waist se pasa a shoulder ; si se está
  en shoulder se pasa a elbow y así).
  
  -Con la tecla ’S’ se pasa a la articulación anterior (si se está en wrist se pasa a elbow y así).
  
  -Se puede hacer de manera cíclica, es decir, que la siguiente articulación a wrist sea waist; y que la
  anterior a waist sea wrist.
  
  -Al pulsar la tecla ’D’ se debe llevar la articulación operada a la posición objetivo.
  
  -Al pulsar la tecla ’A’ se debe llevar la articulación operada a la posición de home.
  
-Obtenga la visualización del manipulador en RViz, de tal manera que se evidencien todos los movimientos
realizados articularmente.


Se modificó el script: jointSrv.py que venía con el paquete de Dynamixel suministrado en este laboratorio, se explicarán a continuación los cambios más importantes que se le hicieron a este archivo:

La primera modificación fue la adaptación del fragmento de código mostrado abajo, cuya finalidad es leer de la consola de Visual las teclas que sean pulsadas, la variable donde se guarda este valor es "c".
```
def detectKey():

    TERMIOS = termios    
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    new = termios.tcgetattr(fd)
    new[3] = new[3] & ~TERMIOS.ICANON & ~TERMIOS.ECHO
    new[6][TERMIOS.VMIN] = 1
    new[6][TERMIOS.VTIME] = 0
    termios.tcsetattr(fd, TERMIOS.TCSANOW, new)
    c = None
    try:
        c = os.read(fd, 1)
    finally:
        termios.tcsetattr(fd, TERMIOS.TCSAFLUSH, old)
    return c
```
Otra porción del código que se modificó fue el main del código original. Básicamente se divide el código en dos partes, una parte del código se ejecuta cuando una letra fue oprimida (código mostrado a continuación). 

Se define una variable joint_I que guardará el número ID de la articulación que se quiera mover, se ajusta el torque de las articulaciones 1 y 2 en 600, las articulaciones 3 y 4 en 300. Se consideran de esta manera ya que para algunos movimientos el torque no resultaba suficiente y el movimiento no se desarrollaba completamente. 
Respecto a la posición de las articulaciones se establece un valor de 512 que es equivalente a 0º.

```
    rospy.init_node('Mov', anonymous=False)

    joint_I = 1

    joint = joint_I

    rate = rospy.Rate(10)
    try:
        jointCommand('', joint_I, 'Torque_Limit', 600, 0)
        jointCommand('', joint_I+1, 'Torque_Limit', 600, 0)
        jointCommand('', joint_I+2, 'Torque_Limit', 300, 0)
        jointCommand('', joint_I+3, 'Torque_Limit', 300, 0)
        jointCommand('', joint_I+3, 'Goal_Position', 512, 0.5)
        jointCommand('', joint_I+2, 'Goal_Position', 512, 0.5)
        time.sleep(0.5)
        jointCommand('', joint_I+1, 'Goal_Position', 512, 0.5)
        time.sleep(0.5)
        jointCommand('', joint_I, 'Goal_Position', 512, 0.5)
```
La segunda parte del código establece lo que se hará si no se oprime ninguna tecla, lo primero será que preguntará de forma iterativa si una letra fue oprimida, posteriormente se mostrará en consola una serie de mensajes que le indicaran al usuario la articulación actual con la que se está trabajando y las opciones que tiene al oprimir las teclas. 

Por último,si la letra oprimida fue D, la posición que tomará la articulación será la objetivo (341.3 ->º). Si por el contrario, la letra oprimida fue A la articulación escogida tomará la posición de home (512->0º):

```
  joints = {joint_I:"Waist", joint_I+1:"Shoulder", joint_I+2:"Elbow", joint_I+3:"Wrist", joint_I+4:"Gripper"}

      letter = detectKey()

      print("ACTUAL JOINT: {}".format(joints[joint]))
      print(joint-joint_I+1)
      print("Press 'a' if you want to move this joint to home")
      print("or press 'd' if you want to move it to the objective position")

      if  letter == b'W' or letter == b'w':
          if joint < joint_I + 4:
              joint = joint + 1
          else:
              print("This is the last joint")
      elif letter == b'S' or letter == b's':
          if joint > joint_I:
              joint = joint - 1
          else:
              print("This is the first joint")
      elif letter == b'D' or letter == b'd':
          jointCommand('', joint, 'Goal_Position', int(512*2/3), 0.5)
          print("Go to objective position")
      elif letter == b'A' or letter == b'a':
          jointCommand('', joint, 'Goal_Position', 512, 0.5)
          print("Go to home position")
```                
Nota: Vea el código completo en los archivos adjuntos a este repositorio.

## MATLAB:

- Cree un script que permita publicar en cada tópico de controlador de junta, se deben validar los límites articulares de cada junta.
- Cree un script que permita suscribirse a cada tóopico de controlador de junta, el script debe retornar la configuración de 5 ángulos en radianes.

Para desarrollar este punto del laboratorio se creó un cliente de pose y posición, se creó un mensaje y se asignó al cliente creado previamente. Este mensaje tenia el siguiente contenido: modificar la dirección Goal_Position, luego a cada id se le asignará un valor el cual será dado por la función mapfun, ésta hace una comparación entre los valores de entrada máximo y mínimo con los valores de salida máximo y mínimo, así hace un mapeo del valor ingresado para saber el valor de salida que le correponde y así poder validar  los límites articulares de cada junta. El código explicado anterormente se muestra a continuación:

```
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
```
Función mapfun explicada anteriormente:
```
function output = mapfun(value,fromLow,fromHigh,toLow,toHigh)
narginchk(5,5)
nargoutchk(0,1)
output = (value - fromLow) .* (toHigh - toLow) ./ (fromHigh - fromLow) + toLow;
end
```
Por último, con el siguiente código se puede suscribir a cada tópico y retornar la configuración que haya sido contenida en el último mensaje enviado por el suscriptor "sub".

```
sub = rossubscriber('/dynamixel_workbench/joint_states');
sub.LatestMessage.Position
```
