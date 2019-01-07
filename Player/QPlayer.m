classdef Q_player < handle
    %Qlearning ²ßÂÔÑ¡Ôñ
    
    properties
        decay= [];
        expl= [];
        gamma = [];
        alpha = [];
        numStates = [];
        numActions = [];
        V = [];
        Q = [];
        Pi = [];
        learning = [];
    end
    
    methods
        function obj = Q_player( numStates,numActions,decay,expl,gamma)
            obj.numStates = numStates;
            obj.numActions = numActions;
            obj.decay = decay;
            obj.expl = expl;
            obj.gamma = gamma;
            obj.V = ones(numStates,1);
            obj.Q = ones(numStates,numActions);
            obj.Pi = ones(numStates,numActions)/numActions;
            obj.learning = 1;    % continue searching
        end
        
        function action = chooseAction(obj,state)
            if obj.learning && rand < obj.expl   % if we learn the policy and explore
                % we choose the random action
                action = randsrc(1,1,1:obj.numActions);
            else   % if we just use the result gotten already, we don't explore for better ones 
                [~,action] = max(Q(state,:));
            end           
        end
        
        function UpdatePolicy( obj, CurState , NextState , actions , reward)
            if obj.learning == 0
                return;
            end
            actionA = actions(1);
            actionB = actions(2);
            obj.Q(CurState,actionA) = (1-obj.alpha)*obj.Q(CurState,actionA) +...
                obj.alpha*(reward + obj.gamma*obj.V(NextState));
            [~,bestAction] = max(obj.Q(CurState,:));
            obj.Pi(CurState,:) = 0;
            obj.Pi(CurState,bestAction) = 1;
            obj.V(CurState) = obj.Q(CurState,bestAction);
            obj.alpha = obj.alpha*obj.decay;            
        end
        
        function policyForState(obj,state)
           for i = 1:obj.numActions
               fprintf('Actions %d : %f\n',i,obj.Pi(state,i));
           end
        end
        
    end
    
end

