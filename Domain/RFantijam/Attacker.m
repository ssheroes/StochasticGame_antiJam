classdef Attacker < handle
    %ATTACK attaker 干扰者
    % Exogenous attacker
    
    properties
        AttackNum;    %干扰者个数
        
    end
    
    methods
        function obj = Attacker(AttackNum)
            obj.AttackNum = AttackNum;
        end
        
        function JamChannel = Attack()
          
        end
    end
    
end

