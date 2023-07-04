%--------------------Initialisation Script--------------------%

world_damping = 0;

mu_s = 0.9000;
mu_k = 0.8000;
mu_vth = 0.1000;

init_height = 0.8025;

%
damping_master = 0.001;

joint_damping_alpha = damping_master;
joint_damping_beta = damping_master;
joint_damping_gamma = damping_master;

% joint_damping_alpha = 1e-3;
% joint_damping_beta = 1e-3;
% joint_damping_gamma = 1e-3;

%Initialwinkel der Gelenke
initial_alpha = -90;
initial_beta = -30;
initial_gamma = 110;

% Minimale und maximale Winkel der einzelnen Gelenke(erstmal geschätzt)
lowerLimit_Alpha = -90 - 60;
upperLimit_Alpha = -90 + 60;

lowerLimit_Beta = -85;
upperLimit_Beta = 60;

lowerLimit_Gamma = 90 - 120;
upperLimit_Gamma = 90 + 60;



%HS-645MG Servo:
%Drehmoment: 94 Ncm = 0.94 NM
% motor_torque = 0.94;
motor_torque = 3;

%Spatial friction force
stiffness = 1e6;
damping = 1e3;
transition_region = 1e-4;

%Test PID Settings
pid_P = 1;
pid_I = 0.2;
pid_D = 1;
pid_filter_N = 100;

%Fallhöhe
drop_height = 300;

phantomX_uncovered = importrobot("phantomx_description\urdf\phantomx.urdf");

%alpha         = importrobot('interbotix_xshexapod_descriptions\urdf\alpha.urdf.xacro');
%phantomX_mk4  = importrobot('interbotix_xshexapod_descriptions\urdf\pxmark4.urdf.xacro');
%phantomX_mk4s =importrobot('interbotix_xshexapod_descriptions\urdf\pxmark4s.urdf.xacro');
%wx_mk4        = importrobot('interbotix_xshexapod_descriptions\urdf\wxmark4.urdf.xacro');


%smimport(['phantomx_description\urdf\phantomx.urdf']);
%smimport(phantomX_mk4);

%open_system("Sandbox.slx");