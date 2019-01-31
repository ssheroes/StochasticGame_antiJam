for k=1:StateNum
    StateIndex = find(Com.Player.StateIndexlist==stateIndex_see(k));
    figure;
    plot(PolicySeeCom{k}(:,StepCntTotal)); 
    title(['Final Policy Com of state[',num2str(StateSee(k,:)),']']);
    
    [~,posMax] = max(PolicySeeCom{k}(:,StepCntTotal));   
    action = transpose(Com.Player.ActionSetCom{StateIndex}(:,posMax));
    figure;
    plot(PolicySeeCom{k}(posMax,:));
    title(['The convergency of the Com action[',num2str(action),']of state[',num2str(StateSee(k,:)),']']);
    
    figure;
    plot(PolicySeeAttacker{k}(:,StepCntTotal));
    title(['Final Policy Attacker of state[',num2str(StateSee(k,:)),']']);
    
    [~,posMax] = max(PolicySeeAttacker{k}(:,StepCntTotal));
    action = transpose(Attacker.Player.ActionSetCom{StateIndex}(:,posMax));
    figure;
    plot(PolicySeeAttacker{k}(posMax,:));
    title(['The convergency of the Attacker action[',num2str(action),']of state[',num2str(StateSee(k,:)),']']);
end