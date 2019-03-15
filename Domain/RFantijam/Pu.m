classdef Pu < handle
    %PU primary user
    
    properties
        PUnum;
        PuState;
        ProbTran;   %[P{0->0},P{0->1};P{1->0},P{1->1}]
        alpha;   %P{1->0} 
        beta;    %P{0->1}
        PuStateSet;
    end
    
    methods
        function obj = Pu()
            alpha = 0.5;   %P{1->0}
            beta = 0.5;    %P{0->1}
            obj.ProbTran = [1-beta,beta;alpha,1-alpha];
            obj.PuStateSet = [0,1];
            obj.PuState = 0;
        end
        
        function Init(obj,InitState)
            obj.PuState = InitState(1);
        end
        
        function PuStateOut = StateVariate(obj)
            stateIndex = obj.PuState+1;
            RandChoice = rand;
            choice = 1;
            while RandChoice>sum(obj.ProbTran(stateIndex,1:choice))
                choice = choice + 1;
            end
            obj.PuState = obj.PuStateSet(choice);
            PuStateOut = obj.PuState;
        end
        
    end
    
end

