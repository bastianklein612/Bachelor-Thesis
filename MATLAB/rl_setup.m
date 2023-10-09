%ensure reproduceability
%rng(0);

%-------------------------------------------------------------------------------------------------------------
%Agent Setup
%-------------------------------------------------------------------------------------------------------------


rl_agent_setup_DDPG;
%rl_agent_setup_DQN;
%rl_agent_setup_PPO_continuous;
%rl_agent_setup_PPO_discrete;

%--------------------------------------------------------------------------
%Configure Training
%--------------------------------------------------------------------------

%configure training options
maxEpisodes = 100000;
maxSteps = 512;


%trainingOptions, used for single agent training
trainOpts = rlTrainingOptions(...
    MaxEpisodes=maxEpisodes,...
    MaxStepsPerEpisode=maxSteps,...
    ScoreAveragingWindowLength=50,...
    Verbose=true,...
    Plots="training-progress",...
    StopTrainingCriteria="EpisodeCount",...
    StopTrainingValue=maxEpisodes,...
    SaveAgentCriteria="EpisodeReward",...
    SaveAgentValue=35);

%{
%multiAgentTrainingOptions, used for parallel/multi-agent training
trainOpts = rlMultiAgentTrainingOptions(...
    MaxEpisodes=maxEpisodes,...
    MaxStepsPerEpisode=maxSteps,...
    ScoreAveragingWindowLength=50,...
    AgentGroups={[1,2]},...
    LearningStrategy='centralized',...
    Verbose=true,...
    Plots="training-progress",...
    StopTrainingCriteria="EpisodeCount",...
    StopTrainingValue=maxEpisodes,...
    SaveAgentCriteria="EpisodeReward",...
    SaveAgentValue=50,...
    StopOnError='off');
%}
%--------------------------------------------------------------------------
%Parallelization of RL 

%delete old parallel pool
delete(gcp('nocreate'))

%number of parallel agents
N = 6;
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
%trainOpts.ParallelizationOptions.StepsUntilDataIsSent = 32;                    %not recommended
%trainOpts.ParallelizationOptions.DataToSendFromWorkers = "Experiences";        %not recommended
%--------------------------------------------------------------------------

%Start training process
trainingStats = train(agent,env,trainOpts);

%To start training where it left off
%trainingStats = train(agent,env,trainingStats);
%agentOpts.ResetExperienceBufferBeforeTraining = false;  %prevent experience reset if continuing training on pretrained model


%To start training again after max episodes was reached
%trainResults.TrainingOptions.MaxEpisodes = 100000;
%trainResultsNew = train(agent,env,trainResults);
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Simulate trained agent
%experience = sim(env, agent)
%experience = sim(env, saved_agent)

% Save and load commands
%filename = "agentBackup_ppo_continuous_64.mat";
%save(filename,"agent");
%save('trainingStats_ddpg_12000', 'trainingStats', '-v7.3')   %for files larger than 2 GB
%load(filename);




