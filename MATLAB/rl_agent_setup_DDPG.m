%--------------------------------------------------------------------------
%DDPG agent and environment setup script
%--------------------------------------------------------------------------
%Partially adapted from: https://de.mathworks.com/help/reinforcement-learning/ug/train-ddpg-agent-to-swing-up-and-balance-pendulum.html

%-----------------------------------------------------------------------------------------------
% Environment setup
%-----------------------------------------------------------------------------------------------

%Create observation specification
%Observations: alpha angle of each leg
%{
observationInfo = rlNumericSpec([6 1],...
    'LowerLimit',[-inf -inf -inf -inf -inf -inf]',...
    'UpperLimit',[inf inf inf inf inf inf]');
observationInfo.Name = 'observations';
%}

observationInfo = rlNumericSpec([12 1],...
    'LowerLimit',[-inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf]',...
    'UpperLimit',[inf inf inf inf inf inf inf inf inf inf inf inf]');
observationInfo.Name = 'observations';

%Create CONTINUOUS action specification
%Action: Initiate swing phase of each leg(1 initiates, [0,1) does nothing)
actionInfo = rlNumericSpec([6 1], ...
    'LowerLimit', [0, 0, 0, 0, 0, 0]',...
    'UpperLimit', [1, 1, 1, 1, 1, 1]');

actionInfo.Name = 'control_output';


env = rlSimulinkEnv(mdl,[mdl '/Motion Controller/Coordinator/RL Setup/RL Agent'],observationInfo,actionInfo);

%-----------------------------------------------------------------------
%Agent setup
%-----------------------------------------------------------------------

% width of nn layer
units = 100;
%units = 8;


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
fprintf('Critic Network: \n');
summary(criticNetwork);
%analyzeNetwork(criticNetwork);
%plot(criticNetwork);
%figure


critic = rlQValueFunction(criticNetwork, observationInfo,actionInfo, ...
                          ObservationInputNames="obsPathInputLayer", ...
                          ActionInputNames="actPathInputLayer");

%--------------------------------------------------------------------------
%Actor network

%setting ceiling clip value for Relu-layer
ceiling = 1;

%network path
actorNetworkPath = [
             featureInputLayer(observationInfo.Dimension(1), Name="observationInputLayer")
             fullyConnectedLayer(units)
             reluLayer
             fullyConnectedLayer(units)
             reluLayer
             fullyConnectedLayer(actionInfo.Dimension(1))
             clippedReluLayer(ceiling, Name="ClippedActionOutputLayer")%inserted this layer to clip output
             %tanhLayer
             %scalingLayer(Scale=max(0.5), Bias=0.5)
             ];

%create actor network
actorNetwork = layerGraph();
actorNetwork = addLayers(actorNetwork,actorNetworkPath);

actorNetwork = dlnetwork(actorNetwork);
fprintf('Actor Network: \n');
summary(actorNetwork);
%analyzeNetwork(actorNetwork);
%plot(actorNetwork);

actor = rlContinuousDeterministicActor(actorNetwork,observationInfo,actionInfo);


%--------------------------------------------------------------------------
%Specify options and create final ddpg agent

%specify critic and agent options
%with a learning rate of 10−4 and 10−3 for the actor and critic respectively
actorOpts = rlOptimizerOptions(LearnRate=3e-4);%,L2RegularizationFactor=1e-4);
criticOpts = rlOptimizerOptions(LearnRate=3e-4);

%specify DDPG options
agentOpts = rlDDPGAgentOptions(...
                               SampleTime=0.05,...
                               ActorOptimizerOptions=actorOpts,...
                               CriticOptimizerOptions=criticOpts,...
                               ExperienceBufferLength=1e6,...%1e5
                               DiscountFactor=0.99,...
                               MiniBatchSize=316);

agentOpts.NoiseOptions.StandardDeviation=0.05;
agentOpts.NoiseOptions.StandardDeviationDecayRate=0;
%agentOpts.NoiseOptions.MeanAttractionConstant=0.15;

%Variance parameters not recommended (MATLAB)
%agentOpts.NoiseOptions.Variance=0.3;                   
%agentOpts.NoiseOptions.VarianceDecayRate=1e-6;

agentOpts.ResetExperienceBufferBeforeTraining = false;


%Create DDPG agent
agent = rlDDPGAgent(actor,critic,agentOpts);