actionInfo = rlNumericSpec([8 1]);
actionInfo.Name = 'control_output';
actionInfo.Description = "Frequency,Duty Cycle," + ...
                         "lbl_offset,lml_offset,lfl_offset," + ...
                         "rbl_offset,rml_offset,rfl_offset";

%Observations: walked distance, steadiness
observationInfo = rlNumericSpec([2 1],...
    'LowerLimit',[-inf 0]',...
    'UpperLimit',[ inf 1]');
observationInfo.Name = 'observations';
observationInfo.Description = 'walked distance,steadiness';


hexapodEnv = rlSimulinkEnv(mdl,[mdl '/Motion Controller/Coordinator/RL Agent'],observationInfo,actionInfo);