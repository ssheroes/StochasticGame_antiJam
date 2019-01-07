classdef Com < handle
    %通信方，包含transmitter 以及 receiver
    
    properties
        SUnum;
        DataChannels_1; % data channels chosen from unjammed channels at the end of 
        % time slot t
        DataChannels_2;% data channels chosen from jammed channels at the end of
        % time slot t 
        ControlChannels_1; %control channels chosen from unjammed channels at the
        %end of time slot t
        ControlChannels_2; %control channels chosen from jammed channels at the
        %end of time slot t
    end
    
    methods
        function obj = Com()   %constructor
            
        end
        
        function action = GetAction();  %Output the action
            
        end
        
    
    end
    
end

