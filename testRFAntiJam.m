% test the class SoccerTester
clear all;
close all;
clc;
addpath('Player/');
addpath('Domain/RFantijam');
% s = RandStream('mt19937ar','seed',2);
% RandStream.setGlobalStream(s);



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
RFAntiJamTrain = RFAntiJamTrain(Channel,Pu);
% playerB = RandomAntiJam();
playerB = minimaxAntiJam(decay,expl,gamma);
AttackerInst = Attacker(playerB,4);
ComInst = Com(decay,expl,gamma,1);

StateSee = [0,1,0,0;0,6,0,0;0,11,0,0;0,6,2,0];
[PolicySeeCom,PolicySeeAttacker,stateIndex_see] = RFAntiJamTrain.train(ComInst,AttackerInst,StepCntTotal,StateSee);

[ComMin,AttackerMin] = RFAntiJamTrain.save(ComInst,AttackerInst);
save('SavedPlayers/Com_minimax','ComMin');
save('SavedPlayers/Attacker_minimax','AttackerMin');

RandCom = Com(decay,expl,gamma,0);
RandAttacker = Attacker(RandomAntiJam(),4)

TestCnt = 10000;
RFAntiJamTest = RFAntiJamTest(Channel,Pu);
testResult_MinVsMin = RFAntiJamTest.test(ComMin,AttackerMin,TestCnt);
RFAntiJamTest.refresh();
testResult_RandVsMin = RFAntiJamTest.test(RandCom,AttackerMin,TestCnt);
RFAntiJamTest.refresh();
testResult_RandVsRand = RFAntiJamTest.test(RandCom,RandAttacker,TestCnt);
RFAntiJamTest.refresh();
testResult_MinVsRand = RFAntiJamTest.test(ComMin,RandAttacker,TestCnt);
% see the final result of Com Policy

AveMinVsMin = zeros(1,TestCnt);
AveRandVsMin = zeros(1,TestCnt);
AveRandVsRand = zeros(1,TestCnt);
AveMinVsRand = zeros(1,TestCnt);

for k = 1:TestCnt
  AveMinVsMin(k) = mean(testResult_MinVsMin(1:k));
  AveRandVsMin(k) = mean(testResult_RandVsMin(1:k));
  AveRandVsRand(k) = mean(testResult_RandVsRand(1:k));
  AveMinVsRand(k) = mean(testResult_MinVsRand(1:k));
end

figure;
plot(AveMinVsMin);
hold on;
plot(AveRandVsMin);
hold on;
plot(AveRandVsRand);
hold on;
plot(AveMinVsRand);
legend('MinVsMin','RandVsMin','RandVsRand','MinVsRand');
PlotPolicy;