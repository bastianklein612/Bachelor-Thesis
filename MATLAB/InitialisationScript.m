%--------------------Initialisation Script--------------------%

gravity_vector = [0, 0, -9.81];


% Initialwinkel der Gelenke
angle_offsets_LF_RB  = [45, 14.03624347, 60.58440117];
angle_offsets_middle = [0, 14.03624347, 60.58440117];
angle_offsets_RF_LB   = [-45, 14.03624347, 60.58440117];

% Minimale und maximale Winkel der einzelnen Gelenke(erstmal geschätzt)


% global transition region joints
global_transition_region = 1;


globalTorque = 0.94;
% HS-645MG Servo:
% Drehmoment: 94 Ncm = 0.94 NM
max_torque_alpha = globalTorque;
max_torque_beta = globalTorque;
max_torque_gamma = globalTorque;

% Spatial contact force
stiffness = 1e6;
damping = 1e3;
transition_region = 1e-4;

mu_static = 0.5;
mu_dynamic = 0.3;
critical_vel = 1e-3;

% Test PID Settings
pid_P = 3;
pid_I = 0.2;
pid_D = 1;
pid_filter_N = 100;


%pattern generation
x_offset = 0.2;
z_offset = -0.13;

%pid_P = 1;
%pid_I = 0.2;
%pid_D = 1;
%pid_filter_N = 100;

%scene
plane_offset = 0.16;



%phantomX_uncovered = importrobot("robot_models\phantomx_description\urdf\phantomx.urdf");

%alpha         = importrobot('robot_models\interbotix_xshexapod_descriptions\urdf\alpha.urdf.xacro');
phantomX_mk4  = importrobot('robot_models\interbotix_xshexapod_descriptions\urdf\pxmark4.urdf.xacro');
%phantomX_mk4s =importrobot('robot_models\interbotix_xshexapod_descriptions\urdf\pxmark4s.urdf.xacro');
%wx_mk4        = importrobot('robot_models\interbotix_xshexapod_descriptions\urdf\wxmark4.urdf.xacro');


%smimport(['phantomx_description\urdf\phantomx.urdf']);
%smimport(phantomX_mk4);

open_system("PhantomX_MK4.slx");