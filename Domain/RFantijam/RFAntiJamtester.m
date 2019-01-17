classdef RFAntiJamtester < handle
    %RFENVIRONMENT 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        Channel;
        Pu;      
        StateOccurSet;
    end
       
    methods
        function obj = RFAntiJamtester(Channel,Pu)
            obj.Channel = Channel;
            obj.Pu = Pu;
            obj.StateOccurSet = [];
        end
        
        
        function state = boardToState( obj,MaxJam )
            PuState = obj.Pu.PuState;
            GainIndex = obj.Channel.GainIndex;
            n_Jammed_C = obj.Channel.n_Jammed_C;
            n_Jammed_D = obj.Channel.n_Jammed_D;
            state.value = [PuState,Channelgain,n_Jammed_C,n_Jammed_D];
             % weight1 is the index of the combination [PUoccupied,GainIndex]
            if PuState
                  weight1 = 0; %  [1,0]
            else
                  weight1 = GainIndex; % [0,1] [0,2] [0,3]
            end
           % weight2 is the index of the combination [n_Jammed_C,n_Jammed_D]
           if  n_Jammed_C==0
               weight2 = n_Jammed_D;
           else
               weight2 = sum(MaxJam+2-n_Jammed_C:MaxJam+1);
           end           
           weight2Max = sum(1:MaxJam+1);
           state.Index = weight1*weight2Max+weight2+1;         
        end
        
        function wins = train(obj,Com,Attacker)
           step = 0;
           obj.restart(); 
           while step <= obj.TrainStepCnt
               state = obj.boardToState();
               if ~ismember(state.Index,obj.StateOccurSet)
                    % the state has not occurred before
                    ActionSetCom = Com.findAvaliableAction(state,obj.Channel.ChannelNum);
                    ActionSetAttack = Attack.findAvaliableAction(state,obj.Channel.ChannelNum);
                    actionA = Com.chooseAction( state , ActionSetCom , ActionSetAttack ,1);      
                    actionB = Attacker.chooseAction( state, ActionSetAttack,1 );
                    obj.StateOccurSet = [ obj.StateOccurSet , state.Index ];
               else
                    actionA = Com.chooseAction( state , ActionSetCom , ActionSetAttack ,0);
                    actionB = Attacker.chooseAction( state, ActionSetAttack,0 );
               end
               obj.playRound( actionA.action,actionB.action );
               reward = obj.resultToReward(actionA.action);
               newstate = obj.boradToState();
               Com.UpdatePolicy( state,newstate,[actionA.Index,actionB.Index],reward );
               Attacker.UpdatePolicy( state,newstate,[actionB.Index,actionA.Index],-reward );
               step = step+1;
           end            
        end
        
        function restart(obj)
            obj.Channel.Init();   
            obj.Pu.Init();
        end
        
        function playRound( obj,actionA,actionB )
        % relative to state, SU action, Attack Action           
            obj.Channel.JamChannelEvolute(actionA,actionB);           
            PuState = obj.Pu.StateVariate();
            obj.Channel.GainVariate(PuState);
        end
        
        function reward = resultToReward(obj,actionA)
            % calculate the block probability
            if(isempty(obj.Channel.seq_Data_unJammed))
                reward = 0;
            else
            reward = numel(obj.Channel.seq_Data_unJammed)*obj.Channel.Gain/sum(actionA);
            end
        end
        
        
        function reward = GetReward(obj)
        % relative to state, SU action, Attack Action
            
        end
        
    end
    
end

