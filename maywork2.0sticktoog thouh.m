% Setup the sensors and motor ports
brick.SetColorMode(1, 2);  % Set color sensor to color code mode (if needed)

% Sensor and motor ports
ultrasonicPort = 2;         % Ultrasonic sensor port (for detecting obstacles)
touchPortFront = 4;         % Front touch sensor port (for detecting obstacles in front)
killSwitchPort = 3;         % Kill switch touch sensor port
leftMotor = 'C';            % Left motor port
rightMotor = 'A';           % Right motor port

% Define motor speeds (separate for left and right motors)
leftMotorSpeed = 70;   % Speed for the left motor (can be adjusted)
rightMotorSpeed = 66;  % Speed for the right motor (can be adjusted)
turnSpeed = 100;       % Speed for turns (higher for quicker turns)
reverseSpeed = -60;    % Speed for reverse

% Initialize movement flags
lastDecisionTime = tic;  % Timer for decision-making cooldown
decisionCooldown = 10;   % 10 seconds cooldown after a decision

% Start solving the maze
while true
    % Check if kill switch is pressed
    if brick.TouchPressed(killSwitchPort)
        brick.MoveMotor(leftMotor, 0);
        brick.MoveMotor(rightMotor, 0);
        disp('Kill switch activated! Motors stopped.');
        break;  % Exit the loop to stop the program
    end
    
    % Current time to check for decision cooldown
    elapsedTime = toc(lastDecisionTime);  % Get the elapsed time since last decision
    
    % If cooldown time has passed, we make a decision
    if elapsedTime >= decisionCooldown
        % Move forward at a steady speed
        brick.MoveMotor(leftMotor, leftMotorSpeed);
        brick.MoveMotor(rightMotor, rightMotorSpeed);

        % Read the ultrasonic sensor to detect an obstacle in front
        distance = brick.UltrasonicDist(ultrasonicPort);  % Get distance from ultrasonic sensor

        % Check for obstacles and decide actions based on the Left-Hand Rule:
        % If no obstacle detected in front and distance is greater than 100, turn left
        if distance > 100  % If there's a lot of space ahead (more than 100 cm)
            disp('Plenty of space ahead (distance > 100 cm), turning left...');
            
            % Stop momentarily before turning
            brick.StopMotor(leftMotor, 'Brake');
            brick.StopMotor(rightMotor, 'Brake');
            pause(0.2);  % Small pause before turning
            
            % Turn left sharply (move left motor backward, right motor forward)
            brick.MoveMotor(leftMotor, reverseSpeed);  % Left motor moves backward
            brick.MoveMotor(rightMotor, turnSpeed);   % Right motor moves forward
            pause(0.5);  % Adjust the time for a sharper 90-degree left turn
            
            % Continue moving forward after turn
            brick.MoveMotor(leftMotor, leftMotorSpeed);
            brick.MoveMotor(rightMotor, rightMotorSpeed);
            
        elseif brick.TouchPressed(touchPortFront)  % Obstacle in front
            % Stop immediately when the touch sensor is pressed
            brick.StopMotor(leftMotor, 'Brake');
            brick.StopMotor(rightMotor, 'Brake');
            disp('Obstacle detected in front, reversing for 0.7 seconds...');

            % Reverse for 0.7 seconds
            brick.MoveMotor(leftMotor, reverseSpeed);  % Left motor moves backward
            brick.MoveMotor(rightMotor, reverseSpeed); % Right motor moves backward
            pause(0.7);  % Reverse for 0.7 seconds
            
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
                brick.MoveMotor(rightMotor, turnSpeed);   % Right motor moves forward
                pause(0.5);  % Adjust the time for a sharper 90-degree left turn
                
                % Continue moving forward after turn
                brick.MoveMotor(leftMotor, leftMotorSpeed);
                brick.MoveMotor(rightMotor, rightMotorSpeed);
            else
                % Otherwise, if space is not enough on the left, turn right
                disp('Reversed, turning right...');
                
                % Turn right sharply (move left motor forward, right motor backward)
                brick.MoveMotor(leftMotor, turnSpeed);   % Left motor moves forward
                brick.MoveMotor(rightMotor, reverseSpeed);  % Right motor moves backward
                pause(0.5);  % Adjust the time for a sharper 90-degree right turn
                
                % Continue moving forward after turn
                brick.MoveMotor(leftMotor, leftMotorSpeed);
                brick.MoveMotor(rightMotor, rightMotorSpeed);
            end
        end
        
        % Update the last decision time (time when the turn/decision was made)
        lastDecisionTime = tic;
    else
        % Keep moving forward without any new decision
        brick.MoveMotor(leftMotor, leftMotorSpeed);
        brick.MoveMotor(rightMotor, rightMotorSpeed);
    end
end

disp('Program ended.');
