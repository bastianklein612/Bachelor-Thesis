gravity_vector = [0, 0, -9.81];

%Parameter zur Definierung der Schritthöhe/-weite
step_height = 0.06;
step_length = 0.04;

%Anterial Extreme Position (AEP), relative to the leg
AEP = 0.03;
%Posterior Extreme Position (PEP), relative to the leg
PEP = -0.03;

%offset for the ground plane
plane_offset = 0.16;


% DYNAMIXEL XL430-W250-T Servo:
% Drehmoment: 140 Ncm = 1.4 NM
globalTorque = 1.4;

%Individual max. torque for each joint
max_torque_alpha = globalTorque;
max_torque_beta = globalTorque;
max_torque_gamma = globalTorque;


% initial joint offsets
angle_offsets_LF_RB  = [45, 14.03624347, 60.58440117];
angle_offsets_middle = [0, 14.03624347, 60.58440117];
angle_offsets_RF_LB   = [-45, 14.03624347, 60.58440117];


%joint parameters
global_transition_region = 1;
joint_damping_coefficient = 0;

% Spatial contact force parameters
stiffness = 1e6;
damping = 1e3;
transition_region = 1e-4;

mu_static = 0.9;    
mu_dynamic = 0.8;   
critical_vel = 1e-3;

%PID parameters
pid_P = 600;
pid_I = 0.1;
pid_D = 1;
pid_filter_N = 1000;

%old pid configuration
%pid_P = 3;
%pid_I = 0.2;
%pid_D = 1;
%pid_filter_N = 100;

%import PhantomX MK4 .urdf to form rigidBodyTree
phantomX_mk4  = importrobot('robot_models\interbotix_xshexapod_descriptions\urdf\pxmark4.urdf.xacro');

%generate Simulink model from rigidBodyTree
%smimport(phantomX_mk4);

mdl = 'PhantomX_MK4';
open_system(mdl);
	