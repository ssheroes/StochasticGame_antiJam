classdef RFAntiJam < handle
    %RFENVIRONMENT �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
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
        %��PUchannel,channelGain,controlJammed,DataJammed���
        
        end
        
    end
    
end

