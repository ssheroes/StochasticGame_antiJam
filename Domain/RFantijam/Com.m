classdef Com < handle
    %ͨ�ŷ�������transmitter �Լ� receiver
    
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

