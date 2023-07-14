%--------------------Initialisation Script--------------------%

gravity_vector = [0, 0, -9.81];


% Initialwinkel der Gelenke
initial_alpha = 0;
initial_beta = 0;
initial_gamma = 0;

% Minimale und maximale Winkel der einzelnen Gelenke(erstmal geschätzt)


% global transition region joints
global_transition_region = 10;

% HS-645MG Servo:
% Drehmoment: 94 Ncm = 0.94 NM
max_torque_alpha = 1;
max_torque_beta = 1;
max_torque_gamma = 1;

% Spatial friction force
stiffness = 1e6;
damping = 1e3;
transition_region = 1e-4;

% Test PID Settings
pid_P = 1;
pid_I = 0.2;
pid_D = 1;
pid_filter_N = 100;



%phantomX_uncovered = importrobot("robot_models\phantomx_description\urdf\phantomx.urdf");

%alpha         = importrobot('robot_models\interbotix_xshexapod_descriptions\urdf\alpha.urdf.xacro');
phantomX_mk4  = importrobot('robot_models\interbotix_xshexapod_descriptions\urdf\pxmark4.urdf.xacro');
%phantomX_mk4s =importrobot('robot_models\interbotix_xshexapod_descriptions\urdf\pxmark4s.urdf.xacro');
%wx_mk4        = importrobot('robot_models\interbotix_xshexapod_descriptions\urdf\wxmark4.urdf.xacro');


%smimport(['phantomx_description\urdf\phantomx.urdf']);
%smimport(phantomX_mk4);

open_system("PhantomX_MK4.slx");