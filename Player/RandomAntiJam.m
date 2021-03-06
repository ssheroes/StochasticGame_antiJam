classdef RandomAntiJam < handle
    %RANDOMANTIJAM 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        Statelist;
        StateIndexlist;
        StateNumlisted;
        ActionIndexSetCom;  
        ActionSetCom;
        ActionIndexSetAttack;
        ActionSetAttack;
        StateNum;
        Pi;
        Pi_hist;
        State_hist;
        StateIndex_hist;
        ActionSetCom_hist;
        HistNum;
        learning;
    end
    
    methods
        
        function obj = RandomAntiJam()
            obj.StateIndexlist = [];
            obj.Statelist = cell(1,1);
            obj.ActionIndexSetCom = cell(1,1);
            obj.ActionSetCom = cell(1,1);
            obj.ActionIndexSetAttack = cell(1,1);
            obj.ActionSetAttack = cell(1,1);
            obj.StateNum = 0;
            obj.Pi = cell(1,1);
            obj.Pi_hist = cell(1,1);
            obj.HistNum = 0;
        end
        
        function Addstate( obj, state , ActionSetCom , ActionSetAttack)
            stateIndex = state.Index;
            if ~ismember(stateIndex,obj.StateIndexlist)    
            [~,ActionComNum] = size( ActionSetCom{1} );
            obj.StateIndexlist( obj.StateNum+1 ) = stateIndex;
            obj.Statelist{ obj.StateNum+1 } = state;           
            obj.ActionIndexSetCom{ obj.StateNum+1 } = ActionSetCom{1};
            obj.ActionIndexSetAttack{ obj.StateNum+1 } = ActionSetAttack{1};
            obj.ActionSetCom{ obj.StateNum+1 } = ActionSetCom{2};
            obj.ActionSetAttack{ obj.StateNum+1 } = ActionSetAttack{2};
            obj.Pi{ obj.StateNum+1 } = 1/ActionComNum*ones( ActionComNum,1 );
            obj.StateNum = obj.StateNum+1;
            end
        end
        
        
        function actionChosen = chooseAction( obj, state)
            stateIndex = state.Index;
            stateIndexInlist = find( obj.StateIndexlist==stateIndex,1 );
            action_num = length(obj.ActionIndexSetCom{stateIndexInlist});
            choice = randsrc(1,1,[1:action_num]);
%             if(action_num==45&&choice~=45)
%                 disp('find the choice is not 45');
%             end
            actionChosen.action = transpose( obj.ActionSetCom{stateIndexInlist}(:,choice) );
            actionChosen.Index = obj.ActionIndexSetCom{stateIndexInlist}(choice);
        end

        function UpdatePolicy(obj,CurState,NextState,actions,reward)
            return;
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
                     ActionNum = length(obj.ActionSetCom{stateIndexInlist});
                     PolicySee{h} = zeros(ActionNum,StopStep);
                     for k = 1:StopStep
                         PolicySee{h}(:,k)=1/ActionNum*ones(ActionNum,1);
                     end
                 end
             end
         end
        
        
    end
    
end

