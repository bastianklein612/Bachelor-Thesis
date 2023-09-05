actionInfo = rlNumericSpec([6 1], ...
    'LowerLimit', [0, 0, 0, 0, 0, 0]',...
    'UpperLimit', [1, 1, 1, 1, 1, 1]');

actionInfo.Name = 'control_output';

%Observations: walked distance, steadiness
observationInfo = rlNumericSpec([6 1],...
    'LowerLimit',[-inf -inf -inf -inf -inf -inf]',...
    'UpperLimit',[inf inf inf inf inf inf]');
observationInfo.Name = 'observations';
%observationInfo.Description = 'walked distance,steadiness';


hexapodEnv = rlSimulinkEnv(mdl,[mdl '/Motion Controller/Coordinator/RL Agent'],observationInfo,actionInfo);