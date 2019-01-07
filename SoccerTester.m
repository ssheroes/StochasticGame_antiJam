classdef SoccerTester < handle
    %SOCCERTESTER tester class, test the two players in one game
    
    properties
        game = [];
        StepCntTotal ;
    end
    
    methods
        
        function obj = SoccerTester(game,StepCntTotal)
            obj.game = game;       
            obj.StepCntTotal = StepCntTotal;
        end
        
        function Reward = resultToReward( obj, result)   % from playround result to reward
            if result >= 0
                Reward = 2*result-1;
            else
                Reward = 0;
            end    
        end
        
        function displayResult(obj,result)
            switch result
                case -2
                    fprintf('该episode平局\n');
                case -1
                    fprintf('该episode尚未结束\n');
                case 0
                    fprintf('该episode B获胜\n');
                case 1
                    fprintf('该episode A获胜\n');
            end
        end
        
        function state=boardToState( obj )
            xA = obj.game.positions{1}(1);
            yA = obj.game.positions{1}(2);
            xB = obj.game.positions{2}(1);
            yB = obj.game.positions{2}(2);
            sA = yA * obj.game.w + xA;
            sB = yB * obj.game.w + xB;
            if sB > sA
                sB = sB-1;
            end
            state = (sA * (obj.game.w * obj.game.h-1) + sB)+( obj.game.w * obj.game.h)*...
                (obj.game.w * obj.game.h -1)*obj.game.ballowner+1;
        end
        
        function [positionA,positionB,ballowner] = stateToBoard( obj,state )
           state = state - 1;
            ballowner = floor(state/((obj.game.w*obj.game.h)*(obj.game.w*obj.game.h-1)));
           stateP = state-ballowner*((obj.game.w*obj.game.h)*(obj.game.w*obj.game.h-1));
           sA = floor(stateP/(obj.game.w*obj.game.h-1));
           sB = stateP-sA*(obj.game.w*obj.game.h-1);
           if sB>=sA
               sB = sB+1;
           end
           yA = floor(sA/obj.game.w);
           xA = sA - yA*obj.game.w;
           yB = floor(sB/obj.game.w);
           xB = sB - yB*obj.game.w;
           positionA = [xA,yA];
           positionB = [xB,yB];          
        end
        
        function wins = playGame(obj,playerA,playerB)
            wins = [];
            step = 0;
            i = 0;
            obj.game.restart();
%             obj.game.draw();
            while  step <=obj.StepCntTotal
                if mod(step,100)==0
                    disp('------------------------------------');
                    fprintf('%4f%%\n',step*100/obj.StepCntTotal);
                    fprintf('第%d次 episode已完成，累积%d次step\n',i,step)
                    disp(['当前时间',datestr(now)]);                   
                end                
                state = obj.boardToState();
                actionA = playerA.chooseAction(state);
                actionB = playerB.chooseAction(state);
                result = obj.game.playRound(actionA,actionB);
%                 if step<=2000
%                  fprintf('actionA:%d  actionB:%d\n',actionA,actionB);   
%                 obj.game.draw();
%                 end
                reward = obj.resultToReward(result);
                newstate = obj.boardToState();
                playerA.UpdatePolicy(state,newstate,[actionA,actionB],reward);
                playerB.UpdatePolicy(state,newstate,[actionB,actionA],-reward);
                step = step+1;
                if obj.game.EndEpisode
                    i = i+1;              
                    wins = [wins,result];
                    obj.game.restart();
%                     obj.game.draw();
                end
            end
        end
        
        function [] = plotwinResult(obj , wins)  % draw the win result
            len = length(wins);
            winResultCum = zeros(3,len);
            for i = 1:len
                winResultCum(1,i) = sum(wins(1:i)==1);  %  A wins
                winResultCum(2,i) = sum(wins(1:i)==0);  % B wins
                winResultCum(3,i) = sum(wins(1:i)==-2);  %draw
            end
           figure;
           plot(winResultCum(1,:),'r');
           hold on;
           plot(winResultCum(2,:),'b');
           legend('Awin','Bwin');
           fprintf('Result:In %d episodes\n',len);
           fprintf('Awin:%d (%5f%%)\n',winResultCum(1,len),winResultCum(1,len)/len);
           fprintf('Bwin:%d (%5f%%)\n',winResultCum(2,len),winResultCum(2,len)/len);
           fprintf('draw:%d (%5f%%)\n',winResultCum(3,len),winResultCum(3,len)/len);
        end
    end
    
end

