classdef Attacker < handle
    %ATTACK attaker ������
    % Exogenous attacker
    
    properties
        AttackNum;    %�����߸���
        
    end
    
    methods
        function obj = Attacker(AttackNum)
            obj.AttackNum = AttackNum;
        end
        
        function JamChannel = Attack()
          
        end
    end
    
end

