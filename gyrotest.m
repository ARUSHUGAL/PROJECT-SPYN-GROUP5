% Setup the sensors and motor ports
brick.SetColorMode(1, 2);  % Set color sensor to color code mode (if needed)

% Sensor and motor ports
touchPortFront = 4;         % Front touch sensor port (detects bump)
gyroPort = 3;               % Gyro sensor port
leftMotor = 'C';            % Left motor port
rightMotor = 'A';           % Right motor port

% Define motor speeds
leftMotorSpeed = 70;        % Speed for the left motor
rightMotorSpeed = 70;       % Speed for the right motor
turnSpeed = 250;            % Speed for turns (higher for quicker turns)
reverseSpeed = -60;         % Speed for reverse

% Initialize movement flags
lastDecisionTime = tic;     % Timer for decision-making cooldown
decisionCooldown = 10;      % 10 seconds cooldown after a decision

% Calibrate the gyro sensor at the start
brick.GyroCalibrate(gyroPort);
pause(2);  % Wait for the calibration to complete

% Start the robot's movement
while true
    % Move forward at a steady speed
    brick.MoveMotor(leftMotor, leftMotorSpeed);
    brick.MoveMotor(rightMotor, rightMotorSpeed);

    % Check if the touch sensor is pressed (bumped)
    if brick.TouchPressed(touchPortFront)
        % Stop the robot
        brick.StopMotor(leftMotor, 'Brake');
        brick.StopMotor(rightMotor, 'Brake');
        disp('Touch sensor pressed, turning right...');
        
        % Rotate 90 degrees to the right using the gyro sensor
        initialAngle = brick.GyroAngle(gyroPort);
        
        % Turn right (left motor moves forward, right motor moves backward)
        brick.MoveMotor(leftMotor, turnSpeed);  % Left motor moves forward
        brick.MoveMotor(rightMotor, reverseSpeed);  % Right motor moves backward
        
        % Wait for the gyro sensor to detect a 90-degree right turn
        while abs(brick.GyroAngle(gyroPort) - initialAngle) < 90
            % Continue turning until the gyro angle reaches 90 degrees
        end
        
        % Stop the motors after the turn
        brick.StopMotor(leftMotor, 'Brake');
        brick.StopMotor(rightMotor, 'Brake');
        disp('Turn complete.');

        % Restart the decision timer to allow the robot to continue
        lastDecisionTime = tic;
    end
end

disp('Program ended.');
