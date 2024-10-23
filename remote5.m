global key;
leftMotorPort = 'C';
rightMotorPort = 'A';
speed = 300;
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
           
        case 0
            disp('No Key Pressed!');
            brick.StopMotor(leftMotorPort, 'Brake');
            brick.StopMotor(rightMotorPort, 'Brake');
           
        case 'q'
            disp('Exiting Program...');
            break;
    end
end
CloseKeyboard();
