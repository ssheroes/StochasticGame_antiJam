classdef Attacker < handle
    %ATTACK attaker 干扰者
    % Exogenous attacker
    
    properties
        AttackNum;    %干扰者个数
        Player;
        action;
        n_AttackChannels_1;   % the attakced channels from unjammed channels
        n_AttackChannels_2;   %the attacked channels from jammed channels
        numAction = 2;
    end
    
    
    methods
        function obj = Attacker(Player,AttackNum)
            obj.AttackNum = AttackNum;
            obj.Player = Player;
        end
       
        function ActionSet = findAvaliableAction(obj,state,ChannelNum)   %constructor
            % ActionSet{1}: action item array , ActionSet{2}: action index array
            ActionSet = cell(1,2);
            n_Jammed_C = state.value(3);
            n_Jammed_D = state.value(4);
            PuState = state.value(1);
            n_Jammed = n_Jammed_C+n_Jammed_D;
            n_unJammed = ChannelNum-n_Jammed;
            if PuState ==1
                ActionSet{1} = [0;0];
                ActionSet{2} = obj.actionToIndex(ActionSet.action,obj.AttackNum);                
            else
            for n_attack_1 = 0:min(n_unJammed,obj.AttackNum)
                for n_attack_2 = 0:min(n_Jammed,obj.AttackNum-n_attack_1)
                    actionItem = [ n_attack_1;n_attack_2 ];
                    actionIndex = obj.actionToIndex(actionItem,obj.AttackNum);
                    ActionSet{1} = [ActionSet{1},actionItem];
                    ActionSet{2} = [ActionSet{2},actionIndex];
                end
            end
            end
            
        end 
        
        function Index = actionToIndex(obj,action,AttackNum)
            Index = action(1)*AttackNum + action(2)+1;           
        end
        
        function actionChosen =chooseAction(obj,state)
            PuState = state.value(1);
            if(PuState==1)   %if the Pu is active
                action=zeros(1,numAction);
                actionChosen.Index = obj.actionToIndex(action);
                actionChosen.action = action;
                return;
            else
                actionChosen = obj.Player.chooseAction(state,ActionSetCom,ActionSetAttack,flagNew);               
            end  
            obj.n_AttackChannels_1 = actionChosen.action(1);
            obj.n_AttackChannels_2 = actionChosen.action(2);
        end
        
        function action = get.action(obj)
            action = [obj.n_AttackChannels_1,obj.n_AttackChannels_2];
        end
    end
    
end

