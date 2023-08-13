actionInfo = rlNumericSpec([8 1], ...
    'LowerLimit', [1e-3, 0.1, 0, 0, 0, 0, 0, 0]',...
    'UpperLimit', [2, 0.9, inf, inf, inf, inf, inf, inf]');

actionInfo.Name = 'control_output';
actionInfo.Description = "Frequency,Duty Cycle," + ...
                         "lbl_offset,lml_offset,lfl_offset," + ...
                         "rbl_offset,rml_offset,rfl_offset";

%Observations: walked distance, steadiness
observationInfo = rlNumericSpec([7 1],...
    'LowerLimit',[-inf -inf -inf -inf -inf -inf -inf]',...
    'UpperLimit',[ inf inf inf inf inf inf inf]');
observationInfo.Name = 'observations';
%observationInfo.Description = 'walked distance,steadiness';


hexapodEnv = rlSimulinkEnv(mdl,[mdl '/Motion Controller/Coordinator/RL Agent'],observationInfo,actionInfo);