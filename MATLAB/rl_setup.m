actionInfo = rlNumericSpec([8 1], ...
    'LowerLimit', [0.1, 0.4, 0, 0, 0, 0, 0, 0]',...
    'UpperLimit', [2, 0.8, 5, 5, 5, 5, 5, 5]');

actionInfo.Name = 'control_output';

%Observations: walked distance, steadiness
observationInfo = rlNumericSpec([7 1],...
    'LowerLimit',[-inf -inf -inf -inf -inf -inf -inf]',...
    'UpperLimit',[inf inf inf inf inf inf inf]');
observationInfo.Name = 'observations';
%observationInfo.Description = 'walked distance,steadiness';


hexapodEnv = rlSimulinkEnv(mdl,[mdl '/Motion Controller/Coordinator/RL Agent'],observationInfo,actionInfo);