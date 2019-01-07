classdef minimaxQPlayer < handle
    %minimax Q player, 
    
    properties
        decay = [];
        expl = [];
        gamma = [];
        alpha = [];
        V = [];
        Q = [];
        Pi = [];
        numStates = [];  %由A和B共同决定
        numActionsA = [];
        numActionsB = [];
        learning = [];       
    end
    
    methods
        function obj = minimaxQPlayer(numStates,numActionsA,numActionsB,decay,expl,gamma)
            obj.decay = decay;
            obj.expl = expl;
            obj.gamma = gamma;
            obj.alpha = 1;
            obj.V = ones(numStates,1);
            obj.Q = ones(numActionsA,numActionsB,numStates);
            obj.Pi = ones(numStates,numActionsA)./numActionsA;
            obj.numStates = numStates;
            obj.numActionsA = numActionsA;
            obj.numActionsB = numActionsB;
            obj.learning = 1;
        end
        
        function action = chooseAction(obj,state)
           if obj.learning && rand < obj.expl
               action = randsrc(1,1,obj.numActionsA); 
           else
               action = obj.weightedActionChoice(state);
           end
        end
        
        function action = weightedActionChoice(obj,state)
            RandChoice = rand;
            choice = 1;
            while RandChoice>sum(obj.Pi(state,1:choice))
                choice = choice+1;
            end
            action = choice;
        end
        
        function UpdatePolicy( obj , CurState , NextState , actions , reward)
           if obj.learning == 0
               return;
           end
           actionA = actions(1);
           actionB = actions(2);
           obj.Q(actionA,actionB,CurState) = (1-obj.alpha)*obj.Q(actionA, actionB,CurState)...
               +obj.alpha*(reward + obj.gamma*obj.V(NextState));
            obj.UpdateV(CurState);
           obj.alpha = obj.alpha*obj.decay;
        end
           
        function UpdateV( obj ,state)
            % using convex optimization to solve
            %   minimize  c * x
            %   s.t.   A_ub*x <= b_ub
            %          A_eq*x == b_eq
            Q_t = transpose(obj.Q(:,:,state));
            c = [-1,zeros(1,obj.numActionsA)];
            n = obj.numActionsA;
            A_up = [ones(obj.numActionsB,1),-Q_t;zeros(obj.numActionsA,1),-eye(obj.numActionsA)];
            b_up = zeros(obj.numActionsA+obj.numActionsB,1);
            A_eq = [0,ones(1,obj.numActionsA)];
            b_eq = 1;
            cvx_begin quiet
            variables x(n+1)
            minimize c*x
            subject to
            A_up*x <= b_up
            A_eq*x == b_eq
            cvx_end
            obj.V(state) = x(1);
            obj.Pi(state,:) = x(2:end);
        end
        
        function policyForState(obj, state)
           for i = 1:obj.numActionsA
            fprintf('Actions %d : %f', i,obj.Pi(state,i));
           end
        end
                    
    end
    
end
    
    
    


