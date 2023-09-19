%--------------------------------------------------------------------------
% PPO agent setup
%--------------------------------------------------------------------------
%Source: https://de.mathworks.com/help/reinforcement-learning/ug/train-ppo-agent-to-land-vehicle.html

units = 16;
numObs = observationInfo.Dimension(1);
numAct = actionInfo.Dimension(1);

%create critic network
criticNet = [
    featureInputLayer(numObs)
    fullyConnectedLayer(units)
    reluLayer
    fullyConnectedLayer(1)
    ];

% Convert to dlnetwork and display number of weights
criticNet = dlnetwork(criticNet);
summary(criticNet)
plot(criticNet)

critic = rlValueFunction(criticNet,observationInfo);

% Define common input path layer
commonPath = [ 
    featureInputLayer(numObs,Name="comPathIn")
    fullyConnectedLayer(units)
    reluLayer
    fullyConnectedLayer(1,Name="comPathOut") 
    ];

% Define mean value path
meanPath = [
    fullyConnectedLayer(15,Name="meanPathIn")
    reluLayer
    fullyConnectedLayer(numAct);
    tanhLayer;
    scalingLayer(Name="meanPathOut",Scale=actionInfo.UpperLimit) 
    ];

% Define standard deviation path
sdevPath = [
    fullyConnectedLayer(15,"Name","stdPathIn")
    reluLayer
    fullyConnectedLayer(numAct);
    softplusLayer(Name="stdPathOut") 
    ];

% Add layers to layerGraph object
actorNet = layerGraph(commonPath);
actorNet = addLayers(actorNet,meanPath);
actorNet = addLayers(actorNet,sdevPath);

% Connect paths
actorNet = connectLayers(actorNet,"comPathOut","meanPathIn/in");
actorNet = connectLayers(actorNet,"comPathOut","stdPathIn/in");


% Convert to dlnetwork and display number of weights
actorNet = dlnetwork(actorNet);
summary(actorNet)
plot(actorNet)


%create continuous actor
actor = rlContinuousGaussianActor(actorNet, observationInfo, actionInfo, ...
    "ActionMeanOutputNames","meanPathOut",...
    "ActionStandardDeviationOutputNames","stdPathOut",...
    ObservationInputNames="comPathIn");

%--------------------------------------------------------------------------
%Specify options and create final ppo agent

%specify critic and agent options
criticOpts = rlOptimizerOptions(LearnRate=1e-2);
actorOpts = rlOptimizerOptions(LearnRate=1e-3);

%specify ppo options
agentOpts = rlPPOAgentOptions(...
    ClipFactor=0.02,...
    EntropyLossWeight=0.01,...
    ActorOptimizerOptions=actorOpts,...
    CriticOptimizerOptions=criticOpts,...
    NumEpoch=3,...
    AdvantageEstimateMethod="gae",...
    GAEFactor=0.95,...
    SampleTime=0.05,...
    DiscountFactor=0.95);

%Create DDPG agent
agent = rlPPOAgent(actor,critic,agentOpts);

