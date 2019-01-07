classdef RFAntiJam < handle
    %RFENVIRONMENT 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        Channel;
        Comm;
        Attacker;
        Pu;
        BandNum=1;
    end
    properties(Dependent)
        state;
    end
       
    methods
        function obj = RFAntiJam(Channel,Comm,Attacker,Pu)
            obj.Channel = Channel;
            Comm
        end
        
        function state = get.state(obj)
        %与PUchannel,channelGain,controlJammed,DataJammed相关
        
        end
        
    end
    
end

