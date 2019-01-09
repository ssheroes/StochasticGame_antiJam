classdef channel < handle 
    %channel ÐÅµÀÀà
    
    properties
        bandNum;
        channelNum;
        %at the time slot t, control(data) channels and the part of being
        %jammed
        seq_Control_Jammed;
        seq_Data_Jammed;
        n_Jammed_C;
        n_Jammed_D;
        seq_unJammed;
        seq_Jammed;
        ProbTran;   %P{j->1},P{j->2},P{j->3},j=0,1,2,3
        Gain;
        GainIndex;
        GainSet;
        seq_whole;
    end
    
    methods
        function obj = channel(bandNum,channelNum)
            obj.bandNum = bandNum;
            obj.channelNum = channelNum;
            obj.GainSet = {1,6,11};
            obj.ProbTran = [0.4,0.4,0.2];
            obj.seq_whole = [1:channelNum];
            obj.Init();
        end
        
        function Init(obj)
            obj.n_Jammed_C = 0;
            obj.n_Jammed_D = 0;
            obj.seq_Control_Jammed = [];
            obj.seq_Data_Jammed = [];
            obj.seq_Jammed = [];
            obj.seq_unJammed = 1:obj.channelNum;
            obj.GainIndex = randsrc(1,1,1:length(obj.GainSet));
            obj.Gain = obj.GainSet(obj.GainIndex);
        end
        
        function GainVariate(obj,PuState)
            if(PuState == 1)
                obj.Gain = 0;
            else
                RandChoice = rand;
                choice = 1;
                while RandChoice>sum(obj.ProbTran(1:choice))
                   choice = choice + 1; 
                end
                obj.Gain = obj.GainSet(choice);
                obj.GainIndex = choice;
            end
        end

        function JamChannelEvolute(obj,actionA,actionB)
            
            n_Data_1 = actionA(1);
            n_Control_1 = actionA(2);
            n_Data_2 = actionA(3);         
            n_Control_2 = actionA(4);
            
            n_Attack_1 = actionB(1);
            n_Attack_2 = actionB(2);
            
            n_unJammed = obj.channelNum-(obj.n_Jammed_C+obj.n_Jammed_D);
            n_Jammed = obj.n_Jammed_C+obj.n_Jammed_D;
            
            seq_Data_1 = obj.seq_unJammed(randperm(n_unJammed,n_Data_1));
            seq_temp1 = setdiff(obj.seq_unJammed,seq_Data_1);
            seq_Control_1 = seq_temp1(randperm(numel(seq_temp1),n_Control_1));
            
            seq_Data_2 = obj.seq_Jammed(randperm(n_Jammed,n_Data_2));
            seq_temp2 = setdiff(obj.seq_Jammed,seq_Data_2);
            seq_Control_2 = seq_temp2(randperm(numel(seq_temp2),n_Control_2));
            
            seq_Attacked_1 = obj.seq_unJammed(randperm(n_unJammed,n_Attack_1));
            seq_Attacked_2 = obj.seq_Jammed(randperm(n_Jammed,n_Attack_2));
            
            seq_Control = union(seq_Control_1,seq_Control_2);
            seq_Data = union(seq_Data_1,seq_Data_2);
            seq_Attacked = union(seq_Attacked_1,seq_Attacked_2);
   
            %    generate the new channel state
            obj.seq_Control_Jammed = intersect(seq_Control,seq_Attacked);
            obj.seq_Data_Jammed = intersect(seq_Data,seq_Attacked);
            
            obj.n_Jammed_C = numel(obj.seq_Control_Jammed);
            obj.n_Jammed_D = numel(obj.seq_Data_Jammed);
            
            obj.seq_Jammed = union(obj.seq_Control_Jammed,obj.seq_Data_Jammed);
            obj.seq_unJammed = setdiff(obj.seq_whole,obj.seq_Jammed);

            
        end
                    

        
        
        
        
    end
    
end

