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
       
        function ActionSet = findAvaliableAction(obj,state,ChannelNum)   %constructor
            ActionSet = [];
            n_Jammed_C = state(3);
            n_Jammed_D = state(4);
            n_Jammed = n_Jammed_C+n_Jammed_D;
            n_unJammed = ChannelNum-n_Jammed;
            for n_attack_1 = 0:min(n_unJammed,obj.AttackNum)
                for n_attack_2 = 0:min(n_Jammed,obj.AttackNum-n_attack_1)
                    actionItem = [ n_attack_1,n_attack_2 ];
                    actionIndex = obj.actionToIndex(actionItem,AttackNum);
                    actionStruct.action = actionItem;
                    actionStruct.Index = actionIndex;
                    ActionSet = [ActionSet,actionStruct];
                end
            end
            
        end 
        
        function Index = actionToIndex(obj,action,AttackNum)
            Index = action(1)*AttackNum + action(2)+1;           
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

