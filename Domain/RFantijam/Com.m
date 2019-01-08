classdef Com < handle
    %通信方，包含transmitter 以及 receiver
    
    properties
        SUnum;
        Player;   %the player policy
        action;
    end

    
    methods
        function obj = Com(Player)   %constructor
            obj.Player = Player;
        end
        
        function action =chooseAction(obj,state)   %Output the action
            action = zeros(1,4);
            bandState = state(1);
            channelGain = state(2);
            if(bandState==1)   %if the Pu is active
                action=0;
                return;
            else
                
                
            end
        end
        
    
    end
    
end

