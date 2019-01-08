classdef RFAntiJamtester < handle
    %RFENVIRONMENT 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        Channel;
        Pu;
        BandNum=1;
        TrainStepsCnt;
        
    end
       
    methods
        function obj = RFAntiJam(Channel,Su,Attacker,Pu)
            obj.Channel = Channel;
            obj.Su = Su;
            obj.Attacker = Attacker;
            obj.Pu = Pu;
        end
        
        function state = boardToState( obj,MaxJam )
            PUoccupied = obj.Pu.PuState;
            GainIndex = obj.Channel.GainIndex;
            n_Jammed_C = obj.Channel.n_Jammed_C;
            n_Jammed_D = obj.Channel.n_Jammed_D;
            state.value = [PUoccupied,Channelgain,n_Jammed_C,n_Jammed_D];
             % weight1 is the index of the combination [PUoccupied,GainIndex]
            if PUoccupied
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
               result = obj.playround( actionA,actionB );
               reward = obj.resultToReward( result );
               newstate = obj.boradToState();
               Com.UpdatePolicy( state,newstate,[actionA,actionB],reward );
               Attacker.UpdatePolicy( state,newstate,[actionB,actionA],-reward );
               step = step+1;
           end            
        end
        
        function restart(obj)
            obj.Channel.Init();            
        end
        
        function playRound( obj,actionA,actionB )
        % relative to state, SU action, Attack Action
            n_Data_1 = actionA(1);
            n_Control_1 = actionA(2);
            n_Data_2 = actionA(3);         
            n_Control_2 = actionA(4);
            
            n_Attack_1 = actionB(1);
            n_Attack_2 = actionB(2);
            n_unJammed = obj.Channel.channelNum-(obj.Channel.n_Jammed_C+obj.Channel.n_Jammed_D);
            n_Jammed = obj.Channel.n_Jammed_C+obj.Channel.n_Jammed_D;
            
            seq_Data_1 = obj.Channel.seq_unJammed(randperm(n_unJammed,n_Data_1));
            seq_temp1 = setdiff(obj.Channel.seq_unJammed,seq_Data_1);
            seq_Control_1 = seq_temp1(randperm(numel(seq_temp1),n_Control_1));
            
            seq_Data_2 = obj.Channel.seq_Jammed(randperm(n_Jammed,n_Data_2));
            seq_temp2 = setdiff(obj.Channel.seq_Jammed,seq_Data_2);
            seq_Control_2 = seq_temp2(randperm(numel(seq_temp2),n_Control_2));
            
            seq_Attacked_1 = obj.Channel.seq_unJammed(randperm(n_unJammed,n_Attack_1));
            seq_Attacked_2 = obj.Channel.seq_Jammed(randperm(n_Jammed,n_Attack_2));
            
            seq_Control = union(seq_Control_1,seq_Control_2);
            seq_Data = union(seq_Data_1,seq_Data_2);
            seq_Attacked = union(seq_Attacked_1,seq_Attacked_2);
   
            %    generate the new channel state
            obj.channel.seq_Control_Jammed = intersect(seq_Control,seq_Attacked);
            obj.channel.seq_Data_Jammed = intersect(seq_Data,seq_Attacked);
            
            obj.channel.n_Jammed_C = numel(obj.channel.seq_Control_Jammed);
            obj.channel.n_Jammed_D = numel(obj.channel.seq_Data_Jammed);
            
            obj.Channel.seq_unJammed = union(seq_Control_Jammed,seq_Data_Jammed);
            obj.Channel.seq_Jammed = setdiff(obj.Channel.seq_whole,obj.Channel.seq_unJammed);
            
            PuState = obj.Pu.StateVariate();
            obj.Channel.GainVariate(PuState);
        end
        
        function SenseResult = Sense(obj)
            SenseResult = obj.Pu.bandState;
        end
        
        
        function reward = GetReward()
        % relative to state, SU action, Attack Action
            
        end
        
    end
    
end

