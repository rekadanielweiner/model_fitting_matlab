classdef sim_oneBackCoin < handle
    
    properties
        
        k       % number of parameters
        b1      % bias after win
        b0      % bias after loss
        expt    % handle for experiment
        S       % state of the model (nothing)
        O       % observable output (choice)
        rs      % random stream
        pNames  % name of parameters
        UB      % upper bound on parameters for sampling random parameters
        LB      % lower bound on parameters for sampling random parameters
        
    end
    
    methods
        
        function obj = sim_oneBackCoin();
            obj.k = 2;
            obj.pNames = {'b0' 'b1'};
            obj.setRandomSeed(cputime*10000);
            obj.UB = [1 1];
            obj.LB = [0 0];
        end
        
        function setRandomSeed(obj, rSeed)
            obj.rs = RandStream('mcg16807','Seed',rSeed);
        end
        
        function initialize(obj)
            obj.O = nan;
            
        end
        
        function setParameters(obj, X)
            obj.b0 = X(1);
            obj.b1 = X(2);
        end
        
        function set_experiment(obj, expt)
            
            % note in this case expt is irrelevant but in an RL example,
            % where the task and the "subject" interact in meaningful ways
            % expt will play an important role
            obj.expt = expt;
            
        end
        
        function update(obj)
            
            
            if obj.O == 1
                
                % last trial was a win so choose with prob b1
                O_new = rand(obj.rs) < obj.b1;
                
            else
                % last trial was a lose so choose with prob b0
                O_new = rand(obj.rs) < obj.b0;
            
            end
            obj.O = O_new;
            
        end
        
        function x0 = sample_randomParameters(obj)
            
            % starting parameter value for fit
            x0 = rand(obj.rs, 1,length(obj.UB)) .* (obj.UB-obj.LB) + obj.LB;

        end
        
        
        
    end
    
end