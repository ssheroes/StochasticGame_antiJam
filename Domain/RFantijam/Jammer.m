classdef Jammer
    %ATTACK attaker 干扰者
    % Exogenous attacker
    
    properties
        Power;   %功率
        LastTime;  %干扰持续时间
        AttackSignal;  %干扰信号
        Num;    %干扰者个数
        Positions;  %干扰者的位置分布
        InitPositions;
    end
    
    methods
        function obj = Jammer(Num)
            obj.Num = Num;
        end
        
        function JamChannel = Attack(ChannelTotal)
            
        end
    end
    
end

