brick.SetColorMode(1, 2);      % Set color sensor to color code mode

ultrasonicPort = 2;                  % Ultrasonic sensor port
touchPortFront = 4;                % Front touch sensor port
killSwitchPort = 3;                % Kill switch touch sensor port
leftMotor = 'C';                         % Left motor
rightMotor = 'A';                       % Right motor

while true
    % Check if kill switch is pressed
    if brick.TouchPressed(killSwitchPort)
        % Stop all motors immediately if kill switch is pressed
        brick.MoveMotor(leftMotor, 0);
        brick.MoveMotor(rightMotor, 0);
        disp('Kill switch activated! Motors stopped.');
        break;  % Exit the loop to stop the program
    end
    
    % Move Forward at speed 65
    brick.MoveMotor(leftMotor, 65);                % Move forward
    brick.MoveMotor(rightMotor, 65);

    % Check if front wall is hit
    if brick.TouchPressed(touchPortFront)
        % Stop all motors when obstacle is detected
        brick.MoveMotor(leftMotor, 0);
        brick.MoveMotor(rightMotor, 0);
        disp('Obstacle detected! Stopping and reversing...');
        pause(2.5);  % Wait for a moment to make sure the robot stops

        % Reverse for 1.3 seconds
        brick.MoveMotor(leftMotor, -65);      % Reverse
        brick.MoveMotor(rightMotor, -65);
        pause(1.3);  % Adjust the time based on your robot's speed and distance

        % Stop all motors after reversing
        brick.StopAllMotors();
        pause(0.5);  % Small pause before turning

        % Turn 90 degrees left (adjust the time to achieve a 90-degree turn)
        brick.MoveMotor(leftMotor, 100);      % Left wheel moves backward
        brick.MoveMotor(rightMotor, -100);     % Right wheel moves forward
        pause(0.6);  % Adjust time to make a 90-degree turn
        
        % Stop the motors after turn
        brick.StopAllMotors();
        
        % Continue moving forward after turn
        brick.MoveMotor(leftMotor, 65);       % Move forward after turn
        brick.MoveMotor(rightMotor, 65);
    end
end
