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
            Channelgain = obj.Channel.Gain;
            GainIndex = obj.Channel.GainIndex;
            n_Jammed_C = obj.Channel.n_Jammed_C;
            n_Jammed_D = obj.Channel.n_Jammed_D;
            state.value = [PuState,Channelgain,n_Jammed_C,n_Jammed_D];         
           state.Index = obj.stateToIndex(state.value,MaxJam);         
        end
        
        function stateIndex = stateToIndex(obj,stateValue,MaxJam)
            StateNum = size(stateValue,1);
            stateIndex = zeros(1,StateNum);
            for h = 1:StateNum
                PuState = stateValue(h,1);
                Channelgain =  stateValue(h,2);
                n_Jammed_C = stateValue(h,3);
                n_Jammed_D = stateValue(h,4);
                GainIndex = 0;
                switch Channelgain
                    case 1
                        GainIndex = 1;
                    case 6
                        GainIndex  = 2;
                    case 11
                        GainIndex = 3;
                end
                
                if PuState
                    count1 = 0; %  [1,0]
                else
                    count1 = GainIndex; % [0,1] [0,2] [0,3]
                end
                % weight2 is the index of the combination [n_Jammed_C,n_Jammed_D]
                weight1 = (MaxJam+1)*(MaxJam+1);
                count2 = n_Jammed_C;
                weight2 = (MaxJam+1);
                count3 = n_Jammed_D;
                stateIndex(h) = count1*weight1+count2*weight2+count3+1;
            end
        end
        
        function Addstate( obj,Com,Attacker, state)
           if ~ismember(state.Index,obj.StateOccurSet)
            ActionSetCom = Com.findAvaliableAction(state,obj.Channel.channelNum);
            ActionSetAttack = Attacker.findAvaliableAction(state,obj.Channel.channelNum);
            Com.Player.Addstate( state , ActionSetCom , ActionSetAttack);
            Attacker.Player.Addstate(state , ActionSetAttack , ActionSetCom);
            obj.StateOccurSet = [ obj.StateOccurSet , state.Index ];
           end
        end
        
        function [PolicySeeCom,PolicySeeAttacker,stateIndex_see] = train(obj,Com,Attacker,TrainStepCnt,StateSee)
           step = 0;
           obj.restart(); 
           JamMax = Attacker.JamMax;
           while step <= TrainStepCnt
               if mod(step,TrainStepCnt/20)==0
                   disp('------------------------------------');
                   fprintf('%4f%%\n',step*100/TrainStepCnt);
                   fprintf('第%d次step 已完成\n',step);
                   disp(['当前时间',datestr(now)]);
               end              
               state = obj.boardToState(JamMax);
               obj.Addstate(Com,Attacker, state);
               actionA = Com.chooseAction( state );
               actionB = Attacker.chooseAction( state );
                disp(step);
               obj.playRound( actionA.action,actionB.action );
               reward = obj.resultToReward(actionA.action);
               newstate = obj.boardToState(JamMax);
               obj.Addstate(Com,Attacker, newstate);
               Com.UpdatePolicy( state,newstate,[actionA.Index,actionB.Index],reward );
               Attacker.UpdatePolicy( state,newstate,[actionB.Index,actionA.Index],-reward );
               step = step+1;
           end
           stateIndex_see = obj.stateToIndex(StateSee,JamMax);
           PolicySeeCom = Com.Player.TrackPolicy(stateIndex_see,TrainStepCnt);
           PolicySeeAttacker = Attacker.Player.TrackPolicy(stateIndex_see,TrainStepCnt);
        end
        
        function PlotPolicy( obj , PolicySee ,stateIndex_see )
            StateNum = length(stateIndex_see);
            
            
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
            if(isempty(obj.Channel.seq_Control_unJammed))
                reward = 0;
            else
            reward = numel(obj.Channel.seq_Data_unJammed)*obj.Channel.Gain/sum(actionA);
            end
        end
        
    end
    
end

