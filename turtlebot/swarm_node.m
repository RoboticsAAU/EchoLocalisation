%% Main
% This file contains the setup and main loop
%% Dependencies
% This program depends on the following addons.
%% 
% * ROS Toolbox
% * Signal Processing

restartNode = true;
%% Setup

% Id of this robot
robot_id = '01';

if restartNode
    % Get the ip of the turtlebot computer.
    [~,robot_ip]= system('hostname -I');
    
    % Trim it to ensure that is is compatible with the environment variables.
    robot_ip = strtrim(robot_ip);
    

%%
    
    % Setup specifications of the hub. 
    hub_IP = '192.168.0.67';
    hub_port = '11311';
    
    % Set the ros environment variables.
    setenv('ROS_MASTER_URI',strcat('http://',hub_IP,':',hub_port))
    setenv('ROS_IP',robot_ip)
    
    % If a ros master is already running this must be shutdown before we can
    % relauch the matlab program
    rosshutdown
    
    % Initialize the global matlab node and naming it based on the robot id.
    rosinit("NodeName",strcat('/robot_',robot_id));
    
    % Launch turtlebot minimal.launch
    PIDs = launch();
end
%%
global number;
global odometryPosition;
global currentDirection;
number = 0;
sub = rossubscriber("/" + string(robot_id) + "/direction",'std_msgs/Int8',@directionCallback);

currentPosePub = rospublisher('/'+string(robot_id)+'/current_position','geometry_msgs/Pose2D');
msg = rosmessage(currentPosePub);
currentPoseSub = rossubscriber('/odom','nav_msgs/Odometry',@odomCallback);

turtlebotVelPub = rospublisher('/mobile_base/commands/velocity','geometry_msgs/Twist');
velmsg = rosmessage(turtlebotVelPub);

globalFrameSub = rossubscriber("/global_frame", "geometry_msgs/PointStamped");

globalFrame = receive(globalFrameSub);

% globalFrame.Header.FrameId
% 
% globalFrame.Point.X





%% Loop

[info_hub] = rostopic("info","/01/current_position");
[echo_odom] = rostopic("echo","/odom");

while isempty(info_hub.Subscribers) || isempty(echo_odom)
    [info_hub] = rostopic("info","/01/current_position");
    [echo_odom] = rostopic("echo","/odom");
     disp('Connecting everything')
end


while number < 20
    
    msg.X = number;
    msg.Y = 5;
    msg.Theta = 1;
    send(currentPosePub,msg);
    % odometryPosition.Pose.Pose.Position;
    % odometryPosition.Pose.Pose.Orientation

    currentDirection;
end

pause(20)
    
    
%     velmsg.Linear.X = 0.1;
%     velmsg.Angular.Z = 0.2;
%     send(turtlebotVelPub,velmsg);
% end




shutNodesDown(PIDs);

%%
function directionCallback(src,message)
    global number;
    number = message.Data;
end


function PIDs = launch()
    [minStatus,minPID] = system(['export LD_LIBRARY_PATH="/opt/ros/kinetic/lib:/opt/ros/kinetic/lib/x86_64-linux-gnu";' 'roslaunch turtlebot_bringup minimal.launch & echo $!']);
    PIDs = minPID;
end

function shutNodesDown(cmdout)
    finishup = onCleanup(@() cleanUpFunction(cmdout));
end

function odomCallback(src,message)
   global odometryPosition;
   global currentDirection;
   odometryPosition = message;
   quaternionInput = odometryPosition.Pose.Pose.Orientation
   quat = [quaternionInput.X quaternionInput.Y quaternionInput.Z quaternionInput.W];
   eul_orient = quat2eul(quat,"XYZ");
   currentDirection = eul_orient(1,3);
end