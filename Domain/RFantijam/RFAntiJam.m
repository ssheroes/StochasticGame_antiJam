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
            obj.Comm = Comm;
            obj.Attacker = Attacker;
            obj.Pu = Pu;
        end
        
        function state = get.state(obj)
        % relative to PUchannel,channelGain,controlJammed,DataJammed     
        end
        
        function OperateRound()
        % relative to state, SU action, Attack Action
        end
        
        function reward = GetReward()
        % relative to state, SU action, Attack Action
            
        end
        
    end
    
end

