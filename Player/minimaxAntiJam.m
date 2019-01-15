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
        StateNumlisted;
        ActionSetComlist;
        ActionSetAttacklist;
        StateNum;
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
            obj.ActionSetComlist = cell(1,1);
            obj.ActionSetAttacklist = cell(1,1);
            obj.StateNum = length(obj.Statelist);
        end
        
        
        
        function actionChosen = chooseAction( obj, state , ActionSetCom, ActionSetAttack, flagNew ) 
            stateIndex = state.Index;
            if(flagNew)
                ActionComNum = length( ActionSetCom );
                ActionAttackNum = length( ActionSetAttack );
                obj.StateIndexlist( obj.StateNum+1 ) = state.Index;
                obj.Statelist{ obj.StateNum+1 } = state;
                obj.Q{ obj.StateNum+1 } = ones( ActionComNum , ActionAttackNum);
                obj.V( obj.StateNum+1 ) = 1;
                obj.Pi{ obj.StateNum+1 } = 1/ActionComNum*ones( ActionComNum,1 );
                obj.ActionSetComlist{ obj.StateNum+1 } = ActionSetCom;
                obj.ActionSetAttacklist{ obj.StateNum+1 } = ActionSetAttack;
                stateIndexInlist = obj.StateNum+1;
                action_num = length(obj.ActionSetComlist{obj.StateNum+1});
                choice = randsrc(1,1,action_num);    
                obj.StateNum = obj.StateNum+1;
            else       
                stateIndexInlist = find( obj.StateIndexlist==stateIndex,1 );
                if obj.learning && rand < obj.expl
                    action_num = length(obj.ActionSetComlist{stateIndexInlist});
                    choice = randsrc(1,1,action_num);
                else
                    RandChoice = rand;
                    choice = 1;
                    PiAction = obj.Pi{stateIndexInlist};
                    while RandChoice>sum(PiAction(1:choice))
                        choice = choice+1;
                    end
                end               
            end
               actionstrcut = obj.ActionSetComlist{stateIndexInlist}(choice);
               actionChosen = actionstrcut.action;              
        end
        
        
        
    end
end

