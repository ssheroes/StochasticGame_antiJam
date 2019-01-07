classdef soccer < handle
    %soccer domain
    properties
        h = 4;  % height
        w = 5;  % weight
        positions = cell(1,2);   %positions of two players
        InitPositions = {[3,2],[1,1]}; %the left bottom corner coordinate is [0,0]
        goalRange_y = [1,2];   % the y range of the goals
        ballowner = 0;    % the ball owner
        drawProbability = 0;   % drawProbability
        EndEpisode = 0;    % the end flag, 1: the episode is over, 0: the episode isn't over
        drawFlag = 0; 
    end
    
    methods
        
        % constructor function
        function obj = soccer(varargin)
            if(nargin == 0)
                % No custom parameters values, thus create default object
                return
            elseif mod(nargin,2)==0
                % User is providing property/value pairs
                names = fieldnames(obj);   %Get names of class properties
                for i = 1 : 2 : nargin-1
                    if any(strcmpi(varargin{i},names))
                        %User has specified a valid property
                        propName = names(strcmpi(varargin{i},names));
                        obj.(propName{1}) = varargin{i+1};
                    else
                        error('GampOpt: %s is an unrecognized option',num2str(varargin{i}));
                    end
                end
            else
                error(['The Soccer constructor requires arguments be provided in pairs']);
            end
        end
        
        % a round play of the game 
        function [PlayResult] = playRound( obj,actionA,actionB )
            % PlayResult = -2: draw, the episode has finished
            % PlayResult = 1 or 0: enter the goal range, the episode has
            % finished , 1:left  0:right 
            % PlayResult = -1, normal move, this round cannot terminate the episode,
            % need next ones
            if rand < obj.drawProbability
                PlayResult = -2;
                obj.EndEpisode = 1;
                obj.drawFlag = 1;
                return;
            end
             first = randsrc(1,1,[0,1]);
            actions = [actionA,actionB];
            m1 = obj.move( first,actions(first+1));
            if m1>=0
                PlayResult = m1;
                obj.EndEpisode = 1;
                return;
            else
                PlayResult = obj.move(1-first,actions(2-first));
                if PlayResult>=0
                    obj.EndEpisode = 1;
                else
                    obj.EndEpisode = 0;
                end
                return;
            end
        end
        
        function  restart(obj)  % restart set the players' positions to the specific initpositions
%             other = obj;
            obj.positions{1} = [3,2];
            obj.positions{2} = [1,1];
            obj.ballowner = randsrc(1,1,[0,1]);
            obj.EndEpisode = 0;
            obj.drawFlag = 0;
        end
        
        function XYbias = actionToMove(obj,action)
            % actions [0:Left,1:Up,2:Right,3:Down,4:Stand]
            switch action
                case 1
                    XYbias = [-1,0];   % Left
                case 2
                    XYbias = [0,1];   % Up
                case 3
                    XYbias = [1,0];   %Right
                case 4
                    XYbias = [0,-1];   %down
                case 5
                    XYbias = [0,0];   %stand
            end
        end
        
        function MoveResult = move( obj,player,action)
            % the player takes the action and move
            % MoveResult = 1: reach the goal in the left episode over
            % MoveResult = 0: reach the goal in the right episode over
            % MoveResult = -1: don't reach the goal, the episode has to go
            % on
            opponent = 1 - player;
            newPosition = obj.positions{player+1}+obj.actionToMove(action);
            
            % if the newPosition is the opponent's position, it cannot move and the ballowner
            % comes to the opponent , and his move has finished, it coming to the opponent's move turn 
            if newPosition == obj.positions{opponent+1}
                obj.ballowner = opponent;
            % if the newPosition is in Goal range, the game has finished,
            % and the reward is decided 
            elseif obj.isInGoal(newPosition(1),newPosition(2))>=0&&obj.ballowner==player
                MoveResult = obj.isInGoal(newPosition(1),newPosition(2));
                return;
            elseif obj.isInBoard(newPosition(1),newPosition(2))  % if the new position is in board
                obj.positions{player+1} = newPosition;            
            end
            MoveResult = -1;
            return;
        end
        
        function IsInBoard = isInBoard( obj,x,y )
            if(x>=0 && x<obj.w && y>=0 && y<obj.h)
               IsInBoard = 1;
               return;
            else
                IsInBoard = 0;
                return;
            end
        end
            
        function IsInGoalResult = isInGoal( obj,x,y )
            if(obj.goalRange_y(1)<=y && y<= obj.goalRange_y(2))
                if x==-1
                    IsInGoalResult = 1;
                    return;
                elseif x==obj.w
                    IsInGoalResult = 0;
                    return;
                end
            end
            IsInGoalResult = -1;
        end
        
        function domain=draw(obj)
            domain = cell( obj.h , obj.w );
            for h_index= 1:obj.h
                for w_index = 1:obj.w
                    domain{h_index,w_index}='-';
                end               
            end
%                 domain{:} = '-';
                x_PlayerA = obj.positions{1}(1)+1;
                y_PlayerA = obj.h-obj.positions{1}(2);
                x_PlayerB = obj.positions{2}(1)+1;
                y_PlayerB = obj.h-obj.positions{2}(2);
                
                if(obj.ballowner==0)
                    if(obj.EndEpisode==0||obj.drawFlag==1)
                  domain{y_PlayerA,x_PlayerA}='A';
                  domain{y_PlayerB,x_PlayerB}='b';
                    else
                   domain{y_PlayerB,x_PlayerB}='b';
                    end
                else
                    if(obj.EndEpisode==0||obj.drawFlag==1)
                  domain{y_PlayerA,x_PlayerA}='a';
                  domain{y_PlayerB,x_PlayerB}='B';
                    else
                    domain{y_PlayerA,x_PlayerA}='a';    
                    end
                end
                disp(domain);
        end
    end
    
end

