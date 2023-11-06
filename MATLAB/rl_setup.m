%ensure reproducability
%rng(0);

%-------------------------------------------------------------------------------------------------------------
%Reward function parameters
%-------------------------------------------------------------------------------------------------------------
reward_vx = 50;
reward_sx = 1;

reward_vy = -1;
reward_h = -1;
reward_energy = -0.025;

%-------------------------------------------------------------------------------------------------------------
%Agent Setup
%-------------------------------------------------------------------------------------------------------------


rl_agent_setup_DDPG;
%rl_agent_setup_DQN;
%rl_agent_setup_PPO_continuous;
%rl_agent_setup_PPO_discrete;

%--------------------------------------------------------------------------
%Configure RL training 
%--------------------------------------------------------------------------

maxEpisodes = 10000;
maxSteps = 256;


%trainingOptions, used for single agent training
trainOpts = rlTrainingOptions(...
    MaxEpisodes=maxEpisodes,...
    MaxStepsPerEpisode=maxSteps,...
    ScoreAveragingWindowLength=250,...
    Verbose=true,...
    Plots="training-progress",...
    StopTrainingCriteria="EpisodeCount",...
    StopTrainingValue=maxEpisodes,...
    SaveAgentCriteria="EpisodeReward",...
    SaveAgentValue=300);

%--------------------------------------------------------------------------
%Parallelization of RL 

%delete old parallel pool
delete(gcp('nocreate'))

%number of parallel agents
N = 8;
pool = parpool(N);

%ensure that the number of workers is not less than N
retries = 0;
retry_limit = 3;
while (pool.NumWorkers < N)
    retries = retries + 1;
    disp('Restarting parallel pool');
    delete(pool);
    pool = parpool('local',core);
    disp(['Pool has been started with Num Workers ' num2str(pool.NumWorkers)]);
    if(retries >= retry_limit)
        disp('Unable to create requested number of workers');
        break;
    end
end


trainOpts.UseParallel = true;
trainOpts.ParallelizationOptions.Mode = "async";

%--------------------------------------------------------------------------

%Start training process
trainingStats = train(agent, env, trainOpts);

%To start training where it left off
%agentOpts.ResetExperienceBufferBeforeTraining = false;  %prevent experience reset if continuing training on pretrained model
%trainingStats = train(agent,env,trainingStats);


%To start training again after max episodes was reached
%trainingStats.TrainingOptions.MaxEpisodes = 100000;
%trainingStats = train(agent,env,trainingStats);
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Simulate trained agent
%experience = sim(env, agent)
%experience = sim(env, saved_agent)

% Save and load commands
%filename = "agentBackup_ppo_continuous_64.mat";
%save(filename,"agent");
%save('Workspace_DDPG_redefinedReward', 'trainingStats', '-v7.3')   %for files larger than 2 GB
%load(filename);
%inspectTrainingResult(trainingStats)




