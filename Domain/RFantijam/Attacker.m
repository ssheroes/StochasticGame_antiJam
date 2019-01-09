classdef Attacker < handle
    %ATTACK attaker 干扰者
    % Exogenous attacker
    
    properties
        AttackNum;    %干扰者个数
        Player;
        action;
        n_AttackChannels_1;   % the attakced channels from unjammed channels
        n_AttackChannels_2;   %the attacked channels from jammed channels
    end
    
    
    methods
        function obj = Attacker(Player,AttackNum)
            obj.AttackNum = AttackNum;
            obj.Player = Player;
        end
        
        function action =chooseAction(obj,state)
            PuState = state.value(1);
            if(PuState==1)   %if the Pu is active
                action=zeros(1,numActionsB);
                return;
            else
                action = obj.Player.chooseAction(state.Index);               
            end  
            obj.n_AttackChannels_1 = action(1);
            obj.n_AttackChannels_2 = action(2);
        end
        
        function action = get.action(obj)
            action = [obj.n_AttackChannels_1,obj.n_AttackChannels_2];
        end
    end
    
end

