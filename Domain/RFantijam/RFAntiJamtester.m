classdef RFAntiJamtester < handle
    %RFENVIRONMENT 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        Channel;
        Pu;      
    end
       
    methods
        function obj = RFAntiJamtester(Channel,Pu)
            obj.Channel = Channel;
            obj.Pu = Pu;
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
               actionA = Com.chooseAction( obj.state );
               actionB = Attacker.chooseAction( obj.state );
               obj.playRound( actionA,actionB );
               reward = obj.resultToReward( result );
               newstate = obj.boradToState();
               Com.UpdatePolicy( state,newstate,[actionA,actionB],reward );
               Attacker.UpdatePolicy( state,newstate,[actionB,actionA],-reward );
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
        
        function SenseResult = Sense(obj)
            SenseResult = obj.Pu.bandState;
        end
        
        
        function reward = GetReward(obj)
        % relative to state, SU action, Attack Action
            
        end
        
    end
    
end

