%needs more optimisation still sometimes the maze is not being solved
%granny lifer mechanism is improved on mon,november 26 2020
%for wednesday do more optmisations and make the granny lifer stopper more stable
%check for turns and adjust speeds


% Setup the sensors and motor ports
brick.SetColorMode(1, 2);  % Set color sensor to color code mode (if needed)

% Sensor and motor ports
ultrasonicPort = 2;         % Ultrasonic sensor port (for detecting obstacles)
touchPortFront = 4;         % Front touch sensor port (for detecting obstacles in front)
killSwitchPort = 3;         % Kill switch touch sensor port
leftMotor = 'C';            % Left motor port
rightMotor = 'A';           % Right motor port

% Define motor speeds (these can be adjusted at the start)
leftMotorSpeed = 63;   % Speed for left motor (can be adjusted)
rightMotorSpeed = 60;  % Speed for right motor (can be adjusted)
turnSpeedLeft = 75;    % Speed for left turn (adjusted for a better left turn)
turnSpeedRight = 85;   % Speed for right turn (adjusted for sharper right turn)
reverseSpeed = -60;    % Speed for reverse

% Alignment thresholds
alignmentThresholdNear = 10;   % Threshold for too close to the left wall (in cm)
alignmentThresholdFar = 20;    % Threshold for too far from the left wall (in cm)

% Start solving the maze
while true
    % Check if kill switch is pressed
    if brick.TouchPressed(killSwitchPort)
        brick.MoveMotor(leftMotor, 0);
        brick.MoveMotor(rightMotor, 0);
        disp('Kill switch activated! Motors stopped.');
        break;  % Exit the loop to stop the program
    end

    % Move forward at a steady speed with independent motor speeds
    brick.MoveMotor(leftMotor, leftMotorSpeed);
    brick.MoveMotor(rightMotor, rightMotorSpeed);

    % Read the ultrasonic sensor to detect an obstacle in front
    distance = brick.UltrasonicDist(ultrasonicPort);  % Get distance from ultrasonic sensor

    % Check for obstacles and decide actions based on the Left-Hand Rule:
    % If no obstacle detected in front and distance is greater than 30, turn left
    if distance > 30  % If there's plenty of space ahead (more than 30 cm)
        disp('Plenty of space ahead (distance > 30 cm), turning left...');
        pause(0.6);  % Wait a little to get past the wall
        brick.StopMotor('AC', 'Brake');  % Stop both motors
        brick.MoveMotor('C', -46.2);  % Move left motor backward
        pause(1.71);  % Turn left for 1.5 seconds (adjust time for sharpness)
        brick.StopMotor('C', 'Brake');  % Stop the left motor
        brick.MoveMotor('C', leftMotorSpeed);  % Move left motor forward
        brick.MoveMotor('A', rightMotorSpeed);  % Move right motor forward
        pause(2);  % Resume moving forward for 2 seconds
        
    elseif brick.TouchPressed(touchPortFront)  % Obstacle in front
        % Stop immediately when the touch sensor is pressed
        brick.StopMotor(leftMotor, 'Brake');
        brick.StopMotor(rightMotor, 'Brake');
        disp('Obstacle detected in front, reversing for 0.7 seconds...');
        
        % Reverse for 0.9 seconds
        brick.MoveMotor(leftMotor, reverseSpeed);  % Left motor moves backward
        brick.MoveMotor(rightMotor, reverseSpeed); % Right motor moves backward
        pause(0.9);  % Reverse for 0.9 seconds
        
        % After reversing, stop the motors
        brick.StopMotor(leftMotor, 'Brake');
        brick.StopMotor(rightMotor, 'Brake');
        pause(0.5);  % Small pause after reversing
        
        % Decide whether to turn left or right based on the space available
        leftSpace = brick.UltrasonicDist(ultrasonicPort);  % Measure space on the left

        if leftSpace > 50  % If there's plenty of space on the left, turn left
            disp('Reversed, plenty of space on the left. Turning left...');
            
            % Turn left sharply (move left motor backward, right motor forward)
            brick.MoveMotor(leftMotor, reverseSpeed);  % Left motor moves backward
            brick.MoveMotor(rightMotor, turnSpeedLeft);   % Right motor moves forward with adjusted speed
            pause(0.5);  % Adjust the time for a sharper 90-degree left turn
            
            % Continue moving forward after turn
            brick.MoveMotor(leftMotor, leftMotorSpeed);
            brick.MoveMotor(rightMotor, rightMotorSpeed);
        else
            % Otherwise, if space is not enough on the left, turn right
            disp('Reversed, turning right...');
            
            % Turn right sharply (move left motor forward, right motor backward)
            brick.MoveMotor(leftMotor, turnSpeedRight);   % Left motor moves forward with adjusted speed
            brick.MoveMotor(rightMotor, reverseSpeed);  % Right motor moves backward
            pause(0.5);  % Adjust the time for a sharper 90-degree right turn
            
            % Continue moving forward after turn
            brick.MoveMotor(leftMotor, leftMotorSpeed);
            brick.MoveMotor(rightMotor, rightMotorSpeed);
        end
    end

    % Alignment to the left wall
    leftWallDistance = brick.UltrasonicDist(ultrasonicPort);  % Measure distance to left wall

    % Adjust position if robot is too close or too far from the left wall
    if leftWallDistance < alignmentThresholdNear  % Too close to the left wall
        disp('Too close to the left wall. Moving slightly to the right...');
        brick.MoveMotor(leftMotor, rightMotorSpeed);  % Move left motor at normal speed
        brick.MoveMotor(rightMotor, rightMotorSpeed); % Move right motor at normal speed
        pause(0.3);  % Adjust the robot to move slightly away from the wall
    elseif leftWallDistance > alignmentThresholdFar  % Too far from the left wall
        disp('Too far from the left wall. Moving slightly to the left...');
        brick.MoveMotor(leftMotor, leftMotorSpeed);   % Move left motor at normal speed
        brick.MoveMotor(rightMotor, rightMotorSpeed); % Move right motor at normal speed
        pause(0.3);  % Adjust the robot to move slightly closer to the wall
    end

    % Keep moving forward without any new decision
    brick.MoveMotor(leftMotor, leftMotorSpeed);
    brick.MoveMotor(rightMotor, rightMotorSpeed);
end

disp('Program ended.');
