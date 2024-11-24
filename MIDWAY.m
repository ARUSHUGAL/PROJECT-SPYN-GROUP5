% Setup the sensors and motor ports
brick.SetColorMode(1, 2);  % Set color sensor to color code mode (if needed)

% Sensor and motor ports
ultrasonicPort = 2;         % Ultrasonic sensor port (for detecting obstacles)
touchPortFront = 4;         % Front touch sensor port (for detecting obstacles in front)
killSwitchPort = 3;         % Kill switch touch sensor port
leftMotor = 'C';            % Left motor port
rightMotor = 'A';           % Right motor port

% Define motor speeds
forwardSpeed = 60;   % Speed for moving forward
turnSpeed = 100;     % Speed for turns (higher for quicker turns)
reverseSpeed = -60;  % Speed for reverse

% Initialize movement flags
lastDecisionTime = tic;  % Timer for decision-making cooldown
decisionCooldown = 10;  % 10 seconds cooldown after a decision

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
        brick.MoveMotor(leftMotor, forwardSpeed);
        brick.MoveMotor(rightMotor, forwardSpeed);

        % Read the ultrasonic sensor to detect an obstacle in front
        distance = brick.UltrasonicDist(ultrasonicPort);  % Get distance from ultrasonic sensor

        % Check for obstacles and decide actions based on the Left-Hand Rule:
        % If there is no obstacle on the left side and no front obstacle, turn left
        if distance > 30 && ~brick.TouchPressed(touchPortFront)  % No obstacle in front and left
            disp('No left wall, turning left...');
            
            % Stop momentarily before turning
            brick.StopMotor(leftMotor, 'Brake');
            brick.StopMotor(rightMotor, 'Brake');
            pause(0.2);  % Small pause before turning
            
            % Turn left (move left motor backward, right motor forward)
            brick.MoveMotor(leftMotor, reverseSpeed);  % Left motor moves backward
            brick.MoveMotor(rightMotor, turnSpeed);   % Right motor moves forward
            pause(0.6);  % Adjust the time for a sharper 90-degree left turn
            
            % Continue moving forward
            brick.MoveMotor(leftMotor, forwardSpeed);
            brick.MoveMotor(rightMotor, forwardSpeed);
        elseif brick.TouchPressed(touchPortFront)  % Obstacle in front
            % If there is an obstacle in front, decide based on left space
            leftSpace = brick.UltrasonicDist(ultrasonicPort);  % Measure space on the left

            if leftSpace > 50  % If there's plenty of space on the left, turn left
                disp('Obstacle detected in front, but plenty of space on the left. Turning left...');
                
                % Stop momentarily before turning
                brick.StopMotor(leftMotor, 'Brake');
                brick.StopMotor(rightMotor, 'Brake');
                pause(0.2);  % Small pause before turning left
                
                % Turn left (move left motor backward, right motor forward)
                brick.MoveMotor(leftMotor, reverseSpeed);  % Left motor moves backward
                brick.MoveMotor(rightMotor, turnSpeed);   % Right motor moves forward
                pause(0.6);  % Adjust the time for a sharper 90-degree left turn
                
                % Continue moving forward after turn
                brick.MoveMotor(leftMotor, forwardSpeed);
                brick.MoveMotor(rightMotor, forwardSpeed);
            else
                % Otherwise, if space is not enough on the left, turn right
                disp('Obstacle detected in front. Turning right...');
                
                % Stop momentarily before turning
                brick.StopMotor(leftMotor, 'Brake');
                brick.StopMotor(rightMotor, 'Brake');
                pause(0.2);  % Small pause before turning
                
                % Turn right (move left motor forward, right motor backward)
                brick.MoveMotor(leftMotor, turnSpeed);   % Left motor moves forward
                brick.MoveMotor(rightMotor, reverseSpeed);  % Right motor moves backward
                pause(0.7);  % Adjust the time for a sharper 90-degree right turn
                
                % Continue moving forward after turn
                brick.MoveMotor(leftMotor, forwardSpeed);
                brick.MoveMotor(rightMotor, forwardSpeed);
            end
        end
        
        % Update the last decision time (time when the turn/decision was made)
        lastDecisionTime = tic;
    else
        % Keep moving forward without any new decision
        brick.MoveMotor(leftMotor, forwardSpeed);
        brick.MoveMotor(rightMotor, forwardSpeed);
    end
end

disp('Program ended.');
