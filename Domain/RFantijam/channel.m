classdef channel < handle 
    %channel ĞÅµÀÀà
    
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
        Gain;
    end
    
    methods
        function obj = channel(bandNum,channelNum)
            obj.bandNum = bandNum;
            obj.channelNum = channelNum;
        end
        
        function Init()
            
        end
        
        function GainVariate()
            
        end
    end
    
end

