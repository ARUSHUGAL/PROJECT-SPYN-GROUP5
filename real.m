% Setup the sensors and motor ports
brick.SetColorMode(1, 2);  % Set color sensor to Color Code mode (COL-COLOR)

% Sensor and motor ports
ultrasonicPort = 2;         
touchPortFront = 4;         
killSwitchPort = 3;        
leftMotor = 'C';            
rightMotor = 'A';           
grannyLifter = 'B';         
colorSensorPort = 1;        

% Define motor speeds
baseSpeed = 60;             % Base speed for both motors
leftMotorSpeed = baseSpeed + 3;  % Slight adjustment for motor differences
rightMotorSpeed = baseSpeed;
turnSpeedLeft = 75;         
turnSpeedRight = 85;        
reverseSpeed = -60;         

% Wall following parameters
idealWallDistance = 22;     % Ideal distance from wall in cm
wallDetectionThreshold = 30; % Distance to detect wall presence
wallLostThreshold = 40;     % Distance to determine wall is lost
proportionalGain = 0.8;     % Adjustment factor for wall following
maxSpeedAdjustment = 15;    % Maximum speed adjustment for wall following
minWallDistance = 15;       % Minimum safe distance from wall
maxWallDistance = 35;       % Maximum distance to maintain wall following

% Control flags
manualControlFlag = false;  
wallFlag = false;           
lastWallDistance = idealWallDistance; % For smooth transitions

% Main control loop
while true
    % Kill switch check
    if brick.TouchPressed(killSwitchPort)
        brick.MoveMotor(leftMotor, 0);
        brick.MoveMotor(rightMotor, 0);
        disp('Kill switch activated! Motors stopped.');
        break;
    end
    
    % Color detection for manual control
    colorDetected = brick.ColorCode(colorSensorPort);
    if colorDetected == 2 || colorDetected == 3
        disp('Blue or Green Detected, entering manual control...');
        manualControlFlag = true;
    elseif manualControlFlag && (colorDetected ~= 2 && colorDetected ~= 3)
        disp('No Blue or Green Detected, resuming maze-solving...');
        manualControlFlag = false;
    end

    if manualControlFlag
        % Manual Control Loop (unchanged)
        % Code for manual control here...
    else
        % Enhanced autonomous maze-solving logic
        distance = brick.UltrasonicDist(ultrasonicPort);
        
        % Smooth the distance reading using exponential moving average
        distance = 0.7 * distance + 0.3 * lastWallDistance;
        lastWallDistance = distance;
        
        % Wall detection with hysteresis
        if distance < wallDetectionThreshold
            wallFlag = true;
        elseif distance > wallLostThreshold
            wallFlag = false;
        end
        
        if wallFlag
            % Enhanced proportional control for wall following
            error = distance - idealWallDistance;
            adjustment = proportionalGain * error;
            
            % Limit the adjustment
            adjustment = max(min(adjustment, maxSpeedAdjustment), -maxSpeedAdjustment);
            
            % Calculate motor speeds with smooth transitions
            leftSpeed = leftMotorSpeed - adjustment;
            rightSpeed = rightMotorSpeed + adjustment;
            
            % Safety limits
            if distance < minWallDistance
                % Too close to wall - emergency turn right
                leftSpeed = leftMotorSpeed + maxSpeedAdjustment;
                rightSpeed = rightMotorSpeed - maxSpeedAdjustment;
                disp('Warning: Too close to wall!');
            elseif distance > maxWallDistance
                % Lost wall - emergency turn left
                leftSpeed = leftMotorSpeed - maxSpeedAdjustment;
                rightSpeed = rightMotorSpeed + maxSpeedAdjustment;
                disp('Warning: Wall lost!');
            end
            
            % Apply motor speeds
            brick.MoveMotor(leftMotor, leftSpeed);
            brick.MoveMotor(rightMotor, rightSpeed);
            
            % Debug information
            disp(['Wall Distance: ' num2str(distance) ' cm, Adjustment: ' num2str(adjustment)]);
        else
            % No wall detected - search pattern
            disp('Searching for wall...');
            brick.MoveMotor(leftMotor, leftMotorSpeed * 0.9); % Slight left bias
            brick.MoveMotor(rightMotor, rightMotorSpeed);
        end
        
        % Enhanced obstacle avoidance
        if brick.TouchPressed(touchPortFront)
            % Obstacle handling with improved recovery
            disp('Obstacle detected in front, initiating recovery...');
            
            % Reverse with slight turn
            brick.MoveMotor(leftMotor, reverseSpeed * 1.1);
            brick.MoveMotor(rightMotor, reverseSpeed * 0.9);
            pause(1.0);
            brick.StopMotor('AC', 'Brake');
            
            % Scan surroundings
            leftSpace = brick.UltrasonicDist(ultrasonicPort);
            pause(0.1); % Allow sensor to stabilize
            
            % Enhanced turn decision
            if leftSpace > wallLostThreshold
                disp('Clear path detected on left, turning...');
                brick.MoveMotor(leftMotor, -turnSpeedLeft);
                brick.MoveMotor(rightMotor, turnSpeedRight);
                pause(0.5);
            else
                disp('Turning right to avoid obstacle...');
                brick.MoveMotor(leftMotor, turnSpeedRight);
                brick.MoveMotor(rightMotor, -turnSpeedLeft);
                pause(0.6); % Slightly longer turn to avoid getting stuck
            end
            brick.StopMotor('AC', 'Brake');
            pause(0.2); % Stabilization pause
        end
    end
end

disp('Program ended.');
