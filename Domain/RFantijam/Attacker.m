classdef Attacker < handle
    %ATTACK attaker 干扰者
    % Exogenous attacker
    
    properties
        AttackNum=1;    %干扰者个数
        Player;
        n_AttackChannels_1;   % the attakced channels from unjammed channels
        n_AttackChannels_2;   %the attacked channels from jammed channels
        numAction = 2;
        JamMax;
    end
    
    
    methods
        function obj = Attacker(Player,JamMax)
            obj.JamMax = JamMax;
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
                ActionSet{2} = [0;0];
                ActionSet{1} = obj.actionToIndex(ActionSet{2},obj.JamMax);
                return;
            else
            for n_attack_1 = 0:min(n_unJammed,obj.JamMax)
                for n_attack_2 = 0:min(n_Jammed,obj.JamMax-n_attack_1)
                    actionItem = [ n_attack_1;n_attack_2 ];
                    actionIndex = obj.actionToIndex(actionItem,obj.JamMax);
                    ActionSet{1} = [ActionSet{1},actionIndex];
                    ActionSet{2} = [ActionSet{2},actionItem];
                end
            end
            end
            
        end 
        
        function Index = actionToIndex(obj,action,JamMax)
            Index = action(1)*JamMax + action(2)+1;           
        end
        
        function actionChosen =chooseAction(obj,state)
            actionChosen = obj.Player.chooseAction(state);
            obj.n_AttackChannels_1 = actionChosen.action(1);
            obj.n_AttackChannels_2 = actionChosen.action(2);
        end
        
        function UpdatePolicy( obj , CurState , NextState , actions , reward)
            obj.Player.UpdatePolicy(CurState , NextState , actions , reward);
        end

    end
    
end

