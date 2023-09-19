%--------------------------------------------------------------------------
% DDPG agent setup
%--------------------------------------------------------------------------
%Source: https://de.mathworks.com/help/reinforcement-learning/ug/train-ddpg-agent-to-swing-up-and-balance-pendulum.html


% width of nn layer
%units = 16;
units = 128;


%--------------------------------------------------------------------------
%Critic network

% Define state path
statePath = [
            featureInputLayer(observationInfo.Dimension(1), Name="obsPathInputLayer")
            fullyConnectedLayer(units)
            reluLayer
            fullyConnectedLayer(units,Name="spOutLayer")
            ];

% Define action path
actionPath = [
             featureInputLayer(actionInfo.Dimension(1), Name="actPathInputLayer")
             fullyConnectedLayer(units, Name="apOutLayer", BiasLearnRateFactor=0)
             ];

% Define common path
commonPath = [
             additionLayer(2,Name="add")
             reluLayer
             fullyConnectedLayer(1)
             ];

% Create layergraph, add layers and connect them
criticNetwork = layerGraph();
criticNetwork = addLayers(criticNetwork,statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);
criticNetwork = connectLayers(criticNetwork,"spOutLayer","add/in1");
criticNetwork = connectLayers(criticNetwork,"apOutLayer","add/in2");
       

criticNetwork = dlnetwork(criticNetwork);
summary(criticNetwork);
plot(criticNetwork);
figure


critic = rlQValueFunction(criticNetwork, observationInfo,actionInfo, ...
                          ObservationInputNames="obsPathInputLayer", ...
                          ActionInputNames="actPathInputLayer");

%--------------------------------------------------------------------------
%Actor network

%network path
actorNetworkPath = [
             featureInputLayer(observationInfo.Dimension(1), Name="observationInputLayer")
             fullyConnectedLayer(units)
             reluLayer
             fullyConnectedLayer(units)
             reluLayer
             fullyConnectedLayer(actionInfo.Dimension(1))
             tanhLayer
             scalingLayer(Scale=max(actionInfo.UpperLimit))
             ];

%create actor network
actorNetwork = layerGraph();
actorNetwork = addLayers(actorNetwork,actorNetworkPath);

actorNetwork = dlnetwork(actorNetwork);
summary(actorNetwork);
plot(actorNetwork);

%{
actorNetwork = [
               featureInputLayer(observationInfo.Dimension(1))
               fullyConnectedLayer(hiddenUnits)
               reluLayer
               fullyConnectedLayer(hiddenUnits)
               reluLayer
               fullyConnectedLayer(actionInfo.Dimension(1))
               tanhLayer
               scalingLayer(Scale=max(actionInfo.UpperLimit))
               ];
%}

actor = rlContinuousDeterministicActor(actorNetwork,observationInfo,actionInfo);


%--------------------------------------------------------------------------
%Specify options and create final ddpg agent

%specify crtic and agent options
criticOpts = rlOptimizerOptions(LearnRate=1e-02,GradientThreshold=1);
actorOpts = rlOptimizerOptions(LearnRate=1e-02,GradientThreshold=1);

%specify DDPG options
agentOpts = rlDDPGAgentOptions(...
                               SampleTime=0.05,...
                               CriticOptimizerOptions=criticOpts,...
                               ActorOptimizerOptions=actorOpts,...
                               ExperienceBufferLength=1e6,...
                               DiscountFactor=0.99,...
                               MiniBatchSize=128);

%Create DDPG agent
agent = rlDDPGAgent(actor,critic,agentOpts);