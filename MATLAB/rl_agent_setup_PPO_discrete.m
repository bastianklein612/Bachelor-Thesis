%--------------------------------------------------------------------------
% PPO agent setup
%--------------------------------------------------------------------------
%Source: https://de.mathworks.com/help/reinforcement-learning/ug/train-ppo-agent-to-land-vehicle.html


% width of nn layer
units = 16;
numObs = observationInfo.Dimension(1);
numAct = 6;
actorLayerSizes = [units units];


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
plot(criticNetwork);
figure

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
plot(actorNetwork);
figure

%discrete actor
actor = rlDiscreteCategoricalActor(actorNetwork,observationInfo,actionInfo);

%--------------------------------------------------------------------------
%Specify options and create final ppo agent

%specify crtic and agent options
actorOpts = rlOptimizerOptions(LearnRate=1e-3);
criticOpts = rlOptimizerOptions(LearnRate=1e-2);

%specify ppo options
agentOpts = rlPPOAgentOptions(...
    ExperienceHorizon=600,...
    ClipFactor=0.02,...
    EntropyLossWeight=0.01,...
    ActorOptimizerOptions=actorOpts,...
    CriticOptimizerOptions=criticOpts,...
    NumEpoch=3,...
    AdvantageEstimateMethod="gae",...
    GAEFactor=0.95,...
    SampleTime=0.05,...
    DiscountFactor=0.997);

%Create DDPG agent
agent = rlPPOAgent(actor,critic,agentOpts);



