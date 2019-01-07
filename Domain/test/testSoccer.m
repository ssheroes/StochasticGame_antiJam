clear all;
close all;
clc;
addpath('../');
Soccer = soccer();
Soccer.restart();   %并不能给positions 赋值为initialpositions
Soccer.draw();
%Soccer.move( 0,0 );
actions = [0,1;0,4;1,3;1,0;1,0];
% action:   0:left  1:up  2:right  3:down  4:stand
for i = 1:5
   action = actions(i,:);
   fprintf('A action: %d\n',action(1));
   fprintf('B action: %d\n',action(2));
  [PlayResult,first]= Soccer.playRound(action(1),action(2));
  fprintf('移动过后\n'); 
  fprintf('playround result: %d\n',PlayResult);
   fprintf('first: %d\n',first);
   Soccer.draw();
end
