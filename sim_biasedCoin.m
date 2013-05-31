classdef sim_biasedCoin < handle
    
    properties
        
        k       % number of parameters
        b       % bias
        expt    % handle for experiment
        S       % state of the model (nothing)
        O       % observable output (choice)
        rs      % random stream
        pNames  % name of parameters
        UB      % upper bound on parameters for sampling random parameters
        LB      % lower bound on parameters for sampling random parameters
        
    end
    
    methods
        
        function obj = sim_biasedCoin
            obj.k = 1;
            obj.pNames = {'bias'};
            obj.setRandomSeed(cputime*10000);
            obj.UB = 1;
            obj.LB = 0;
        end
        
        function setRandomSeed(obj, rSeed)
            obj.rs = RandStream('mcg16807','Seed',rSeed);
        end
        
        function initialize(obj)
            obj.S = nan;
        end
        
        function setParameters(obj, b)
            obj.b = b;
        end
        
        function set_experiment(obj, expt)
            
            % note in this case expt is irrelevant but in an RL example,
            % where the task and the "subject" interact in meaningful ways
            % expt will play an important role
            obj.expt = expt;
            
        end
        
        function update(obj)
            
            % make a choice
            obj.O = rand(obj.rs) < obj.b;
            
        end
        
        function x0 = sample_randomParameters(obj)
            
            % starting parameter value for fit
            x0 = rand(obj.rs, 1,length(obj.UB)) .* (obj.UB-obj.LB) + obj.LB;

        end
        
        
        
    end
    
end