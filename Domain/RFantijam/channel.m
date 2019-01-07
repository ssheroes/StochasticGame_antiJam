classdef channel < handle 
    %channel ĞÅµÀÀà
    
    properties
        bandNum;
        channelNum;
        %at the time slot t, control(data) channels and the part of being
        %jammed
        controlChannels;
        dataChannels;
        JammedChannelsControl;    
        JammedChannelsData;
        seq_Jammed;
        seq_unJammed;
        seq_whole;
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

