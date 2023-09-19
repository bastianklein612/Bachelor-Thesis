%reproducability
rng(0);

%-----------------------------------------------------------------------------------------------
% Environment setup
%-----------------------------------------------------------------------------------------------

%Create observation specification
%Observations: alpha angle of each leg
observationInfo = rlNumericSpec([6 1],...
    'LowerLimit',[-inf -inf -inf -inf -inf -inf]',...
    'UpperLimit',[inf inf inf inf inf inf]');
observationInfo.Name = 'observations';
%observationInfo.Description = 'walked distance,steadiness';


%Create CONTINUOUS action specification
%Action: Initiate swing phase of each leg(1 initiates, [0,1) does nothing)
actionInfo = rlNumericSpec([6 1], ...
    'LowerLimit', [0, 0, 0, 0, 0, 0]',...
    'UpperLimit', [1, 1, 1, 1, 1, 1]');

actionInfo.Name = 'control_output';

%{
%!!not working yet!!
%Create DISCRETE action specification
%Action: Initiate swing phase of each leg(1); do nothing(0)
actionInfo = rlFiniteSetSpec({[0 1], [0 1], [0 1], [0 1], [0 1], [0 1]});
actionInfo.Name = 'control_output';

%}
env = rlSimulinkEnv(mdl,[mdl '/Motion Controller/Coordinator/RL Agent'],observationInfo,actionInfo);


%-------------------------------------------------------------------------------------------------------------
%Agent Setup
%-------------------------------------------------------------------------------------------------------------

%Create DDPG agent
rl_agent_setup_DDPG;
%rl_agent_setup_PPO_continuous;
%rl_agent_setup_PPO_discrete;





%--------------------------------------------------------------------------
%Configure Training

%configure training options
maxEpisodes = 100000;
maxSteps = 500;
trainOpts = rlTrainingOptions(...
    MaxEpisodes=maxEpisodes,...
    MaxStepsPerEpisode=maxSteps,...
    ScoreAveragingWindowLength=75,...
    Verbose=true,...
    Plots="training-progress",...
    StopTrainingCriteria="EpisodeCount",...
    StopTrainingValue=maxEpisodes,...
    SaveAgentCriteria="EpisodeReward",...
    SaveAgentValue=100);





%--------------------------------------------------------------------------
%Parallelization of RL 

%delete old parallel pool
delete(gcp('nocreate'))

%number of parallel agents
N = 8;
pool = parpool(N);

trainOpts.UseParallel = true;
trainOpts.ParallelizationOptions.Mode = "async";
trainOpts.ParallelizationOptions.StepsUntilDataIsSent = 32;
trainOpts.ParallelizationOptions.DataToSendFromWorkers = "Experiences";
%--------------------------------------------------------------------------

%Start training process
trainingStats = train(agent,env,trainOpts);

%To start training where it left off
%trainingStats = train(agent,env,trainingStats);

%To start training again after max episodes was reached
%trainResults.TrainingOptions.MaxEpisodes = 2000;
%trainResultsNew = train(agent,env,trainResults);
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
















