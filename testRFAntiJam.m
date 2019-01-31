% test the class SoccerTester
clear all;
close all;
clc;
addpath('Player/');
addpath('Domain/RFantijam');
% s = RandStream('mt19937ar','seed',2);
% RandStream.setGlobalStream(s);
% kk= randsrc(1,1,[1:5]);


numActions = 5;
drawProbability = 0.01;
StepCntTotal = 50000;
decay = 10^(-2/StepCntTotal);
expl = 0.2;
gamma = 0.01;

% choose the player type
%minimaxQPlayer(numStates,numActionsA,numActionsB,decay,expl,gamma)


Channel = channel(1,8);
Pu = Pu();
RFAntiJam = RFAntiJamtester(Channel,Pu);
% playerB = RandomAntiJam();
playerB = minimaxAntiJam(decay,expl,gamma);
Attacker = Attacker(playerB,4);
Com = Com(decay,expl,gamma);

StateSee = [0,1,0,0;0,6,0,0;0,11,0,0;0,6,2,0];
[PolicySeeCom,PolicySeeAttacker,stateIndex_see] = RFAntiJam.train(Com,Attacker,StepCntTotal,StateSee);

% see the final result of Com Policy
[StateNum,~] = size(StateSee);
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


