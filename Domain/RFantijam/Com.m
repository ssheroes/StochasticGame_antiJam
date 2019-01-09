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
    end

    
    methods
        function obj = Com(Player)   %constructor
            obj.Player = Player;
        end
        
        function action =chooseAction(obj,state)   %Output the action
            PuState = state.value(1);
            if(PuState==1)   %if the Pu is active
                action=zeros(1,numActionsA);
                return;
            else
                action = obj.Player.chooseAction(state.Index);
            end
            obj.n_Data_1 = action(1);
            obj.n_Control_1 = action(2);
            obj.n_Data_2 = action(3);
            obj.n_Control_2 = action(4);
        end
        
    
    end
    
end

