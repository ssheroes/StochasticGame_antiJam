classdef channel < handle 
    %channel �ŵ���
    
    properties
        channelnumPerband;
        %at the time slot t, control(data) channels and the part of being
        %jammed
        controlChannels;
        dataChannels;
        JammedChannelsControl;    
        JammedChannelsData;
        Gain;
    end
    
    methods
        function obj = channel()
            
        end
        
        function GainVariate()
            
        end
    end
    
end

