
global key;
leftMotorPort = 'C';
rightMotorPort = 'A';
grannyLifter = 'B';
speed = 150;
gSpeed = 30;
InitKeyboard();
while 1
pause(0.1);

switch key
case 'uparrow'
disp('Up Arrow Pressed!');
brick.MoveMotor(leftMotorPort, speed);
brick.MoveMotor(rightMotorPort, speed);

case 'downarrow'
disp('Down Arrow Pressed!');
brick.MoveMotor(leftMotorPort, -speed);
brick.MoveMotor(rightMotorPort, -speed);

case 'leftarrow'
disp('Left Arrow Pressed!');
brick.MoveMotor(leftMotorPort, -speed);
brick.MoveMotor(rightMotorPort, speed);

case 'rightarrow'
disp('Right Arrow Pressed!');
brick.MoveMotor(leftMotorPort, speed);
brick.MoveMotor(rightMotorPort, -speed);

case 'w'
disp('W Arrow Pressed!');
brick.MoveMotor(leftMotorPort, gSpeed);
brick.MoveMotor(rightMotorPort, gSpeed);

case 's'
disp('S Arrow Pressed!');
brick.MoveMotor(leftMotorPort, -gSpeed);
brick.MoveMotor(rightMotorPort, -gSpeed);

case 'a'
disp('A Pressed!');
brick.MoveMotor(leftMotorPort, -gSpeed);
brick.MoveMotor(rightMotorPort, gSpeed);

case 'd'
disp('D Pressed!');
brick.MoveMotor(leftMotorPort, gSpeed);
brick.MoveMotor(rightMotorPort, -gSpeed);

case 'r'

brick.MoveMotorAngleRel(grannyLifter, -10, 30, 'Brake');
brick.WaitForMotor(grannyLifter);
disp('Lifting object');

case 'f'

brick.MoveMotorAngleRel(grannyLifter, 10, 10, 'Brake');
brick.WaitForMotor(grannyLifter);
disp('Lowering object');

case 0
disp('No Key Pressed!');
brick.StopMotor(leftMotorPort, 'Brake');
brick.StopMotor(rightMotorPort, 'Brake');
brick.StopMotor(grannyLifter, 'Brake');
brick.ResetMotorAngle(grannyLifter);

case 'q'
disp('Exiting Program...');
break;
end
end
CloseKeyboard();
