classdef Jammer
    %ATTACK attaker ������
    % Exogenous attacker
    
    properties
        Power;   %����
        LastTime;  %���ų���ʱ��
        AttackSignal;  %�����ź�
        Num;    %�����߸���
        Positions;  %�����ߵ�λ�÷ֲ�
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

