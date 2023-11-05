%--------------------------------------------------------------------------
% discrete PPO agent and environment setup skript
%--------------------------------------------------------------------------
%Source: https://de.mathworks.com/help/reinforcement-learning/ug/train-ppo-agent-to-land-vehicle.html

%Create observation specification
observationInfo = rlNumericSpec([12 1],...
    'LowerLimit',[-inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf]',...
    'UpperLimit',[inf inf inf inf inf inf inf inf inf inf inf inf]');
observationInfo.Name = 'observations';

%Create DISCRETE action specification
%Action: Initiate swing phase of each leg(1); do nothing(0)
actions = ff2n(6);
actionInfo = rlFiniteSetSpec(num2cell(actions,2));
actionInfo.Name = 'control_output';

env = rlSimulinkEnv(mdl,[mdl '/Locomotion Controller/Coordination/RL Setup/RL Agent'],observationInfo,actionInfo);

%-----------------------------------------------------------------------
%Agent setup
%-----------------------------------------------------------------------

% width of nn layer
units = 64;



numObs = observationInfo.Dimension(1);
numAct = 2^6;
%--------------------------------------------------------------------------
%Define critic network

criticNetwork = [
                featureInputLayer(numObs, Name="obsPathInputLayer")
                fullyConnectedLayer(units)
                reluLayer
                fullyConnectedLayer(units)
                reluLayer
                fullyConnectedLayer(1)
                ];

criticNetwork = dlnetwork(criticNetwork);
summary(criticNetwork);
%plot(criticNetwork);
%figure

critic = rlValueFunction(criticNetwork,observationInfo);

%--------------------------------------------------------------------------
%Define actor network

actorNetwork = [
                featureInputLayer(numObs)
                fullyConnectedLayer(units)
                reluLayer
                fullyConnectedLayer(units)
                reluLayer
                fullyConnectedLayer(numAct)
                softmaxLayer
                ];

actorNetwork = dlnetwork(actorNetwork);
summary(actorNetwork);
%plot(actorNetwork);
%figure

%discrete actor
actor = rlDiscreteCategoricalActor(actorNetwork,observationInfo,actionInfo);

%--------------------------------------------------------------------------
%Specify options and create final ppo agent

%specify crtic and agent options
actorOpts = rlOptimizerOptions(LearnRate=1e-4);%,GradientThreshhold=1);
criticOpts = rlOptimizerOptions(LearnRate=1e-4);

%specify ppo options
agentOpts = rlPPOAgentOptions(...
    ExperienceHorizon=512,...
    MiniBatchSize=32,...
    ClipFactor=0.02,...                 %0.08 --> 0.2, changed according to "An energy-saving snake locomotion gait policy obtained using DRL"
    EntropyLossWeight=0.01,...
    ActorOptimizerOptions=actorOpts,...
    CriticOptimizerOptions=criticOpts,...
    NumEpoch=3,...                    %3 --> 10
    AdvantageEstimateMethod="gae",...
    GAEFactor=0.95,...
    SampleTime=0.05,...
    DiscountFactor=0.997);

%Create DDPG agent
agent = rlPPOAgent(actor,critic,agentOpts);



