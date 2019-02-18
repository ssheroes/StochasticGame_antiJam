classdef minimaxAntiJam < handle
    %MINIMAXANTIJAM 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        decay;
        expl;
        gamma;
        alpha;
        V;
        Q;
        Pi;
        Statelist;
        StateIndexlist;
        ActionIndexSetCom;
        ActionSetCom;
        ActionIndexSetAttack;
        ActionSetAttack;
        StateNum;
        learning;
        Pi_hist ;
        State_hist;
        StateIndex_hist;
        ActionSetCom_hist;
        HistNum ;
    end
    
    
    methods
        function obj = minimaxAntiJam(decay,expl,gamma)
            obj.decay = decay;
            obj.expl = expl;
            obj.gamma = gamma;
            obj.alpha = 1;
            obj.V = [];
            obj.StateIndexlist = [];
            obj.Q = cell(1,1);
            obj.Pi = cell(1,1);
            obj.Statelist = cell(1,1);
            obj.ActionIndexSetCom = cell(1,1);
            obj.ActionSetCom = cell(1,1);
            obj.ActionIndexSetAttack = cell(1,1);
            obj.ActionSetAttack = cell(1,1);
            obj.StateNum = 0;
            obj.learning = 1;
            obj.HistNum = 0;
            obj.Pi_hist = cell(1,1) ;
            obj.State_hist = cell(1,1);
            obj.StateIndex_hist = cell(1,1);
            obj.ActionSetCom_hist = cell(1,1);
        end
        
        
        
        function Addstate( obj, state , ActionSetCom , ActionSetAttack)      
            stateIndex = state.Index;            
            if ~ismember(stateIndex,obj.StateIndexlist)            
            [~,ActionComNum] = size( ActionSetCom{1} );
            [~,ActionAttackNum] = size( ActionSetAttack{1} );
            obj.StateIndexlist( obj.StateNum+1 ) = stateIndex;
            obj.Statelist{ obj.StateNum+1 } = state;
            obj.Q{ obj.StateNum+1 } = ones( ActionComNum , ActionAttackNum);
            obj.V( obj.StateNum+1 ) = 1;
            obj.Pi{ obj.StateNum+1 } = 1/ActionComNum*ones( ActionComNum,1 );
            
            obj.ActionIndexSetCom{ obj.StateNum+1 } = ActionSetCom{1};
            obj.ActionIndexSetAttack{ obj.StateNum+1 } = ActionSetAttack{1};
            obj.ActionSetCom{ obj.StateNum+1 } = ActionSetCom{2};
            obj.ActionSetAttack{ obj.StateNum+1 } = ActionSetAttack{2};
            obj.StateNum = obj.StateNum+1;           
            end
        end
        
        
        function actionChosen = chooseAction( obj, state)   
                stateIndex = state.Index;
                stateIndexInlist = find( obj.StateIndexlist==stateIndex,1 );
                
                if obj.learning && rand < obj.expl
                    action_num = length(obj.ActionIndexSetCom{stateIndexInlist});
                    choice = randsrc(1,1,[1:action_num]);
                else
                    RandChoice = rand;
                    choice = 1;
                    PiAction = obj.Pi{stateIndexInlist};
                    while RandChoice>sum(PiAction(1:choice))
                        choice = choice+1;
                    end
                end
               actionChosen.action = transpose( obj.ActionSetCom{stateIndexInlist}(:,choice) );    
               actionChosen.Index = obj.ActionIndexSetCom{stateIndexInlist}(choice);
        end
        
        function UpdatePolicy( obj , CurState , NextState , actions , reward)
           if obj.learning == 0
               return;
           end
           actionA = actions(1);
           actionB = actions(2);         
           CurStateIndex = CurState.Index;
           NextStateIndex = NextState.Index;
           CurStateIndexInlist = find( obj.StateIndexlist==CurStateIndex,1 );
           NextStateIndexInlist = find( obj.StateIndexlist==NextStateIndex,1 );
           action_setA = obj.ActionIndexSetCom{CurStateIndexInlist};
           action_setB = obj.ActionIndexSetAttack{CurStateIndexInlist};
           ActionIndexInlistA = find( action_setA==actionA );
           ActionIndexInlistB = find( action_setB == actionB);
           obj.Q{CurStateIndexInlist}(ActionIndexInlistA,ActionIndexInlistB) = ...
               (1-obj.alpha)*obj.Q{CurStateIndexInlist}(ActionIndexInlistA,ActionIndexInlistB)+...
               +obj.alpha*(reward + obj.gamma*obj.V(NextStateIndexInlist));
            obj.UpdateV(CurStateIndexInlist);
           obj.alpha = obj.alpha*obj.decay;         
        end
        
         function UpdateV( obj ,CurStateIndexInlist)
            % using convex optimization to solve
            %   minimize  c * x
            %   s.t.   A_ub*x <= b_ub
            %          A_eq*x == b_eq
           numActionsA = length(obj.ActionIndexSetCom{CurStateIndexInlist});
           numActionsB = length(obj.ActionIndexSetAttack{CurStateIndexInlist});
            
            Q_t = transpose(obj.Q{CurStateIndexInlist});
            c = [-1,zeros(1,numActionsA)];
            n = numActionsA;
            A_up = [ones(numActionsB,1),-Q_t;zeros(numActionsA,1),-eye(numActionsA)];
            b_up = zeros(numActionsA+numActionsB,1);
            A_eq = [0,ones(1,numActionsA)];
            b_eq = 1;
            cvx_begin quiet
            variables x(n+1)
            minimize c*x
            subject to
            A_up*x <= b_up
            A_eq*x == b_eq
            cvx_end
            obj.V(CurStateIndexInlist) = x(1);
            obj.Pi{CurStateIndexInlist} = x(2:end);
         end
        
         function Record( obj )
             obj.Pi_hist{obj.HistNum+1} = obj.Pi ;
             obj.StateIndex_hist{obj.HistNum+1} = obj.StateIndexlist;
             obj.State_hist{obj.HistNum+1} = obj.Statelist;
             obj.ActionSetCom_hist{obj.HistNum+1} = obj.ActionSetCom;
             obj.HistNum = obj.HistNum+1;
         end
        
         function PolicySee = TrackPolicy( obj ,stateIndex,StopStep)
             SeeNum = length(stateIndex);
             PolicySee = cell(1,SeeNum);
             for h = 1:SeeNum
                 stateIndexInlist = find( obj.StateIndexlist==stateIndex(h),1 );
                 if isempty(stateIndexInlist)
                     disp(['cannot find the state', num2str(stateIndex(h))]);
                 else
                     StartStep = 1;
                     while 1
                         if ismember(stateIndex(h),obj.StateIndex_hist{StartStep})
                             break;
                         else
                             StartStep = StartStep+1;
                         end
                     end
                     ActionNum = length(obj.ActionSetCom{stateIndexInlist});
                     PolicySee{h} = zeros(ActionNum,StopStep);
                     for k = 1:StopStep
                         if k<StartStep
                             PolicySee{h}(:,k)=1/ActionNum*ones(ActionNum,1);
                         else
                             PolicySee{h}(:,k) = obj.Pi_hist{k}{stateIndexInlist};
                         end
                       
                     end
                 end
             end
         end
         
         
         
        
    end
end

