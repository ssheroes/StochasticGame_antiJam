% test the class SoccerTester
clear all;
close all;
clc;
addpath('Player/');
addpath('Domain/RFantijam');
s = RandStream('mt19937ar','seed',2);
RandStream.setGlobalStream(s);
% kk= randsrc(1,1,[1:5]);


numActions = 5;
drawProbability = 0.01;
StepCntTotal = 1000000;
decay = 10^(-2/StepCntTotal);
expl = 0.2;
gamma = 0.01;

% choose the player type
%minimaxQPlayer(numStates,numActionsA,numActionsB,decay,expl,gamma)


Channel = channel(1,8);
Pu = Pu();
RFAntiJam = RFAntiJamtester(Channel,Pu);

playerB = RandomAntiJam();
Attacker = Attacker(playerB,4);
Com = Com(decay,expl,gamma);

RFAntiJam.train(Com,Attacker,StepCntTotal);


