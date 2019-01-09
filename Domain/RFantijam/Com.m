classdef Com < handle
    %通信方，包含transmitter 以及 receiver
    
    properties
        SUnum;
        Player;   %the player policy
        action;
        n_Data_1;
        n_Control_1;
        n_Data_2;
        n_Control_2;
        numAction = 4;
    end

    
    methods
        function obj = Com()
            
            
        end
        
        function ActionSet = findAvaliableAction(obj,state,ChannelNum)   %constructor
            ActionSet = [];
            n_Jammed_C = state(3);
            n_Jammed_D = state(4);
            n_Jammed = n_Jammed_C+n_Jammed_D;
            n_unJammed = ChannelNum-n_Jammed;
            for n_data_1 = 0:n_unJammed
               for n_control_1 = 0:n_unJammed-n_data_1
                  for n_data_2 = 0:n_Jammed
                      for n_control_2 = 0:n_Jammed-n_data_2
                          actionItem = [ n_data_1,n_control_1,n_data_2,n_control_2];
                          actionIndex = obj.actionToIndex(actionItem,ChannelNum);
                          actionStruct.action = actionItem;
                          actionStruct.Index = actionIndex;
                          ActionSet = [ActionSet,actionStruct];
                      end
                  end
               end
            end
            
        end
        
        function Index = actionToIndex(obj,action,ChannelNum)
           Index = action(1)*ChannelNum^3+action(2)*ChannelNum^2+...
               +action(3)*ChannelNum+action(4)+1;          
        end
        
        function Initial(obj)
            % specialize the actions for each state
            
            
        end
            
        function action =chooseAction(obj,state)   %Output the action
            PuState = state.value(1);
            if(PuState==1)   %if the Pu is active
                action=zeros(1,obj.numAction);
                return;
            else
                actionSet = obj.findAvaliableAction(state,ChannelNum);
                action = obj.Player.chooseAction(state.Index,actionSet);
            end
            obj.n_Data_1 = action(1);
            obj.n_Control_1 = action(2);
            obj.n_Data_2 = action(3);
            obj.n_Control_2 = action(4);
        end
        
        
    
    end
    
end

