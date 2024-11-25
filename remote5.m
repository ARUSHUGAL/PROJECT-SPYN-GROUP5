global key;
leftMotorPort = 'C';
rightMotorPort = 'A';
grannyLifter = 'B';
speed = 150;
gSpeed = 30;

InitKeyboard(); % Initialize keyboard control

while true
    pause(0.1); % Small delay for smoother control
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
            disp('W Key Pressed for gentle forward movement!');
            brick.MoveMotor(leftMotorPort, gSpeed);
            brick.MoveMotor(rightMotorPort, gSpeed);

        case 's'
            disp('S Key Pressed for gentle backward movement!');
            brick.MoveMotor(leftMotorPort, -gSpeed);
            brick.MoveMotor(rightMotorPort, -gSpeed);

        case 'a'
            disp('A Key Pressed for gentle left turn!');
            brick.MoveMotor(leftMotorPort, -gSpeed);
            brick.MoveMotor(rightMotorPort, gSpeed);

        case 'd'
            disp('D Key Pressed for gentle right turn!');
            brick.MoveMotor(leftMotorPort, gSpeed);
            brick.MoveMotor(rightMotorPort, -gSpeed);

        case 'r' % Lift object
            disp('Lifting object...');
            brick.MoveMotorAngleRel(grannyLifter, -10, 30, 'Brake');
            brick.WaitForMotor(grannyLifter);

        case 'f' % Lower object
            disp('Lowering object...');
            brick.MoveMotorAngleRel(grannyLifter, 10, 30, 'Brake');
            brick.WaitForMotor(grannyLifter);

        case 0
            disp('No Key Pressed!');
            brick.StopMotor(leftMotorPort, 'Brake');
            brick.StopMotor(rightMotorPort, 'Brake');
            brick.StopMotor(grannyLifter, 'Brake');

        case 'q'
            disp('Exiting Program...');
            break; % Exit the loop

        otherwise
            disp('Invalid Key Pressed!');
    end
end

CloseKeyboard(); % Clean up on exit
