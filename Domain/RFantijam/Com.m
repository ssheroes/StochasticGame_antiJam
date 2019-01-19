classdef Com < handle
    %通信方，包含transmitter 以及 receiver
    
    properties
        SUnum;
        Player;   %the player policy
        n_Data_1;
        n_Control_1;
        n_Data_2;
        n_Control_2;
        numAction = 4;
        Pi_hist ;
        State_hist = {};
        HistNum = 0;
    end

    
    methods
        function obj = Com(decay,expl,gamma)
            obj.Player = minimaxAntiJam(decay,expl,gamma);
            obj.Pi_hist = {};
            obj.State_hist = {};
            obj.HistNum = 0;
        end
        
        function ActionSet = findAvaliableAction(obj,state,ChannelNum)   %constructor
            ActionSet = cell(1,2);  % ActionSet{1}: action item array , ActionSet{2}: action index array
            PuState = state.value(1);
            n_Jammed_C = state.value(3);
            n_Jammed_D = state.value(4);           
            n_Jammed = n_Jammed_C+n_Jammed_D;
            n_unJammed = ChannelNum-n_Jammed;
            if PuState ==1
                ActionSet{2} = [0;0;0;0];
                ActionSet{1} = obj.actionToIndex( ActionSet{2},ChannelNum);
                return;
            else
                for n_data_1 = 0:n_unJammed
                    for n_control_1 = 0:n_unJammed-n_data_1
                        for n_data_2 = 0:n_Jammed
                            for n_control_2 = 0:n_Jammed-n_data_2
                                actionItem = [ n_data_1,n_control_1,n_data_2,n_control_2].';
                                actionIndex = obj.actionToIndex(actionItem,ChannelNum);
                                ActionSet{1} = [ActionSet{1},actionIndex];
                                ActionSet{2} = [ActionSet{2},actionItem];
                            end
                        end
                    end
                end
            end
            
        end
        
        function Index = actionToIndex(obj,action,ChannelNum)
           Index = action(1)*ChannelNum^3+action(2)*ChannelNum^2+...
               +action(3)*ChannelNum+action(4)+1;          
        end
        
            
        function actionChosen =chooseAction(obj,state)   %Output the action
            actionChosen = obj.Player.chooseAction(state);
            obj.n_Data_1 = actionChosen.action(1);
            obj.n_Control_1 = actionChosen.action(2);
            obj.n_Data_2 = actionChosen.action(3);
            obj.n_Control_2 = actionChosen.action(4);    
        end
        
        function UpdatePolicy( obj , CurState , NextState , actions , reward)
            obj.Player.UpdatePolicy(CurState , NextState , actions , reward);           
        end
        
        function MemoryPi( obj , CurState )
            obj.Pi_hist{obj.HistNum+1} = obj. ;
            obj.State_hist{obj.HistNum+1} = ;
            obj.HistNum = 0;
        end
    
    end
    
end

