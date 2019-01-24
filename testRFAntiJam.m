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
StepCntTotal = 150;
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
% playerB = minimaxAntiJam(); 
Attacker = Attacker(playerB,4);
Com = Com(decay,expl,gamma);

StateSee = [0,1,0,0;0,6,0,0;0,11,0,0];
PolicySee = RFAntiJam.train(Com,Attacker,StepCntTotal,StateSee);


