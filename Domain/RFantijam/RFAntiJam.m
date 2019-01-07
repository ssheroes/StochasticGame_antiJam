classdef RFAntiJam < handle
    %RFENVIRONMENT 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        Channel;
        Su;
        Attacker;
        Pu;
        BandNum=1;
        state;
    end
       
    methods
        function obj = RFAntiJam(Channel,Su,Attacker,Pu)
            obj.Channel = Channel;
            obj.Su = Su;
            obj.Attacker = Attacker;
            obj.Pu = Pu;
        end
        
        function state = get.state(obj)
        % relative to PUchannel,channelGain,controlJammed,DataJammed     
        end
        
        function OperateRound(obj)
        % relative to state, SU action, Attack Action
            n_Data_1 = obj.Su.n_Data_1;
            n_Data_2 = obj.Su.n_Data_2;
            n_Control_1 = obj.Su.n_Control_1;
            n_Control_2 = obj.Su.n_Control_2;
            n_Attack_1 = obj.Attacker.n_Attack_1;
            n_Attack_2 = obj.Attacker.n_Attack_2;
            n_unJammed = obj.Channel.channelNum-(obj.state(3)+obj.state(4));
            n_Jammed = obj.state(3)+obj.state(4);
            
            seq_Data_1 = obj.Channel.seq_unJammed(randperm(n_unJammed,n_Data_1));
            seq_temp1 = setdiff(obj.Channel.seq_unJammed,seq_Data_1);
            seq_Control_1 = seq_temp1(randperm(numel(seq_temp1),n_Control_1));
            
            seq_Data_2 = obj.Channel.seq_Jammed(randperm(n_Jammed,n_Data_2));
            seq_temp2 = setdiff(obj.Channel.seq_Jammed,seq_Data_2);
            seq_Control_2 = seq_temp2(randperm(numel(seq_temp2),n_Control_2));
            
            seq_Attacked_1 = obj.Channel.seq_unJammed(randperm(n_unJammed,n_Attack_1));
            seq_Attacked_2 = obj.Channel.seq_Jammed(randperm(n_Jammed,n_Attack_2));
            
            seq_Control = union(seq_Control_1,seq_Control_2);
            seq_Data = union(seq_Data_1,seq_Data_2);
            seq_Attacked = union(seq_Attacked_1,seq_Attacked_2);
            
            seq_Control_Jammed = intersect(seq_Control,seq_Attacked);
            seq_Data_Jammed = intersect(seq_Data,seq_Attacked);
            
            obj.state(3) = numel(seq_Control_Jammed);
            obj.state(4) = numel(seq_Data_Jammed);
            
            obj.Channel.seq_unJammed = union(seq_Control_Jammed,seq_Data_Jammed);
            obj.Channel.seq_Jammed = setdiff(obj.Channel.seq_whole,obj.Channel.seq_unJammed);
            
        end
        
        function reward = GetReward()
        % relative to state, SU action, Attack Action
            
        end
        
    end
    
end

