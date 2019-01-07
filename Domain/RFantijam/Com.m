classdef Com < handle
    %通信方，包含transmitter 以及 receiver
    
    properties
        SUnum;
        n_Data_1; % data channels chosen from unjammed channels at the end of 
        % time slot t
        n_Data_2;% data channels chosen from jammed channels at the end of
        % time slot t 
        n_Control_1; %control channels chosen from unjammed channels at the
        %end of time slot t
        n_Control_2; %control channels chosen from jammed channels at the
        %end of time slot t
        Player;   %the player policy
        action;
    end

    
    methods
        function obj = Com(Player)   %constructor
            obj.Player = Player;
        end
        
        function action = get.action(obj)   %Output the action
            action = [obj.n_DataChannels_1,obj.n_DataChannels_2,obj.n_ControlChannels_1...
                ,obj.n_ControlChannels_2];
        end
        
    
    end
    
end

