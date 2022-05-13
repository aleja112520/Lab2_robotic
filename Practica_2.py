import termios, sys, os
import rospy
import time
from std_msgs.msg import String
from dynamixel_workbench_msgs.srv import DynamixelCommand

__author__ = "F Gonzalez, S Realpe, JM Fajardo"
__credits__ = ["Felipe Gonzalez", "Sebastian Realpe", "Jose Manuel Fajardo", "Robotis"]
__email__ = "fegonzalezro@unal.edu.co"
__status__ = "Test"

def jointCommand(command, id_num, addr_name, value, time):
    #rospy.init_node('joint_node', anonymous=False)
    rospy.wait_for_service('dynamixel_workbench/dynamixel_command')
    try:        
        dynamixel_command = rospy.ServiceProxy('/dynamixel_workbench/dynamixel_command', DynamixelCommand)
        result = dynamixel_command(command,id_num,addr_name,value)
        rospy.sleep(time)
        return result.comm_result
    except rospy.ServiceException as exc:
        print(str(exc))




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

if __name__ == '__main__':


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

        while not rospy.is_shutdown():
            

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
                
                
                rate.sleep()


    except rospy.ROSInterruptException:
        pass