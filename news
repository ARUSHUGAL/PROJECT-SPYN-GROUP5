% Initialize the connection with the LEGO Mindstorm EV3 brick named 'TWERKINATOR'
brick = ConnectBrick('TWERKINATOR');

% Set the color sensor to mode 3 (ColorCode) and the touch sensor to mode 2 (Binary)
brick.SetColorMode(3, 2);

% Loop for continuous operation
while 1
    % Read color code from the color sensor on port 3
    colorCode = brick.ColorCode(3);
    disp('Color Code: ' + colorCode);

    % Read the distance from the ultrasonic sensor on port 1
    distance = brick.UltrasonicDist(1);
    disp('Distance: ' + distance);

    % Read the touch sensor value from port 4
    touch = brick.TouchPressed(4);
    disp('Touch: ' + touch);

    % Autonomous behavior based on sensor readings

    % If the distance is less than or equal to 50 cm and the touch sensor is not pressed
    if (distance <= 50 && touch == 0)
        brick.MoveMotor('A', 44);
        brick.MoveMotor('D', 50);
    end

    % If the color code is 5
    if colorCode == 5
        brick.StopMotor('AD');
        pause(2)
        brick.MoveMotor('A', 44);
        brick.MoveMotor('D', 50);
        pause(1)
    end

    % If the distance is less than or equal to 50 cm and the touch sensor is pressed
    if (distance <= 50 && touch == 1)
        pause(0.5);
        brick.StopMotor('AD');
        brick.MoveMotor('AD', -20);
        pause(1.2);
        brick.MoveMotor('D', 15);
        brick.MoveMotor('A', -20);
        pause(2);
        brick.StopMotor('AD');
        brick.MoveMotor('A', 44);
        brick.MoveMotor('D', 50);
        pause(1.4);
    end

    % If the distance is greater than 85 cm and the touch sensor is not pressed
    if (distance > 85 && touch == 0)
        brick.StopMotor('AD');
        pause(0.5);
        brick.MoveMotor('D', -20);
        brick.MoveMotor('A', 25);
        pause(1.2);
        brick.MoveMotor('A', 44);
        brick.MoveMotor('D', 50);
        pause(2);
    end

    % If the touch sensor is pressed and the distance is greater than 60 cm
    if (touch == 1 && distance > 60)
        brick.StopMotor('AD');
        pause(0.5);
        brick.MoveMotor('AD', -20);
        pause(1.5);
        brick.MoveMotor('D', -15);
        brick.MoveMotor('A', 20);
        pause(2);
        brick.MoveMotor('A', 44);
        brick.MoveMotor('D', 50);
        pause(1)
    end
end

% Code to control the robot manually using keyboard arrow keys
InitKeyboard();
global key;

while 1
    pause(0.1);
    switch key
        case 'uparrow'
            disp('Up Arrow pressed');
            brick.MoveMotor('AD', 30);
            pause(0.1);
            brick.StopMotor('AD');

        case 'downarrow'
            disp ('Down Arrow Pressed');
            brick.MoveMotor('AD', -30);
            pause(0.1);
            brick.StopMotor('AD');

        case 'leftarrow'
            disp('Left Arrow Pressed');
            brick.MoveMotor('A', -30);
            brick.MoveMotor('D', 30);
            pause(0.1);
            brick.StopMotor('AD');

        case 'rightarrow'
            disp('Right Arrow Pressed');
            brick.MoveMotor('A', 30);
            brick.MoveMotor('D', -30);
            pause(0.1);
            brick.StopMotor('AD');

        case 0
            disp('Press a key');

        case 'q'
            break;
    end
end
CloseKeyboard();

% Code to control specific motor B to perform forward, backward, and stop actions
brick.MoveMotor('B', 10);
pause(0.3);
brick.StopMotor('B');

brick.MoveMotor('B', -10);
pause(0.2);
brick.StopMotor('B');

brick.MoveMotor('B', 10);
pause(0.1);
brick.StopMotor('B');
