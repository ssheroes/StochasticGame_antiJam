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
    end
    
    methods
        function obj = channel(bandNum,channelNum)
            obj.bandNum = bandNum;
            obj.channelNum = channelNum;
            obj.GainSet = {1,6,11};
            obj.ProbTran = [0.4,0.4,0.2];
        end
        
        function Init(obj)
            obj.n_Jammed_C = 0;
            obj.n_Jammed_D = 0;
            obj.seq_Control_Jammed = [];
            obj.seq_Data_Jammed = [];
            obj.seq_Jammed = [];
            obj.seq_unJammed = [1:obj.channelNum];
            obj.Gain = randsrc(1,1,obj.GainSet);
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

        
                    

        
        
        
        
    end
    
end

