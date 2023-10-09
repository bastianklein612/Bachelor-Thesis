%--------------------------------------------------------------------------
% DQN agent and environment setup skript
%--------------------------------------------------------------------------
%Source: 

%-----------------------------------------------------------------------------------------------
% Environment setup
%-----------------------------------------------------------------------------------------------

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

env = rlSimulinkEnv(mdl,[mdl '/Motion Controller/Coordinator/RL Agent'],observationInfo,actionInfo);

%-----------------------------------------------------------------------
%Agent setup
%-----------------------------------------------------------------------

% width of nn layer
units = 8;
%units = 8;



env = rlSimulinkEnv(mdl,[mdl '/Motion Controller/Coordinator/RL Agent'],observationInfo,actionInfo);

%--------------------------------------------------------------------------
%CREATE CRITIC 

% Observation path
obsPath = [
    featureInputLayer(prod(observationInfo.Dimension),Name="netOin")
    fullyConnectedLayer(units)
    reluLayer
    fullyConnectedLayer(units,Name="fcObsPath")
    ];

% Action path
actPath = [
    featureInputLayer(prod(actionInfo.Dimension),Name="netAin")
    fullyConnectedLayer(units,Name="fcActPath")
    ];

% Common  path (concatenate inputs along dim #1)
commonPath = [
    concatenationLayer(1,2,Name="cat")
    reluLayer
    fullyConnectedLayer(1,Name="out")
    ];

% Add paths to network
criticNetwork = layerGraph;
criticNetwork = addLayers(criticNetwork,obsPath);
criticNetwork = addLayers(criticNetwork,actPath);
criticNetwork = addLayers(criticNetwork,commonPath);

% Connect layers
criticNetwork = connectLayers(criticNetwork,"fcObsPath","cat/in1");
criticNetwork = connectLayers(criticNetwork,"fcActPath","cat/in2");

% Convert to dlnetwork object
criticNetwork = dlnetwork(criticNetwork);


fprintf('Critic Network: \n');
summary(criticNetwork);
%analyzeNetwork(criticNetwork);
%plot(criticNetwork);


critic = rlQValueFunction(criticNetwork, ...
    observationInfo, ...
    actionInfo, ...
    ObservationInputNames="netOin", ...
    ActionInputNames="netAin");


%--------------------------------------------------------------------------
%CREATE DQN AGENT

%specify critic options
criticOpts = rlOptimizerOptions(LearnRate=1e-3,GradientThreshold=1);

%specify DQN options
agentOpts = rlDQNAgentOptions( ...
                             SampleTime=0.05,...
                             UseDoubleDQN=false,...
                             TargetUpdateMethod="periodic",...
                             TargetUpdateFrequency=4,...
                             ExperienceBufferLength=1e5,...
                             DiscountFactor=0.99,...
                             MiniBatchSize=32,...
                             CriticOptimizerOptions=criticOpts);

agent = rlDQNAgent(critic, agentOpts);

