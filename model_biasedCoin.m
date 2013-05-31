classdef model_biasedCoin < handle
    
    properties
        
        k       % number of parameters
        b       % bias
        expt    % handle for experiment
        S       % state of the model (nothing)
        O       % observable output (choice)
        rs      % random stream for simulation
        pNames  % name of parameters
        
        % fit parameters for fmincon 
        % TODO - may want to create a dummy class with these as properties
        % and inherit from it
        A       % linear constraint A*X <= B
        B       % linear constraint A*X <= B
        Aeq     % linear equalities Aeq*X = Beq
        Beq     % linear equalities Aeq*X = Beq
        UB      % upper bound on parameters for fit
        LB      % lower bound on parameters for fit
        NLcon   % non linear constraint
        
    end
    
    methods
        
        function obj = model_biasedCoin
            obj.k = 1;
            obj.UB = 1;
            obj.LB = 0;
            obj.pNames = {'bias'};
        end
        
        function setRandomSeed(obj, rSeed)
            % note this is the random seed for simulation only - if you
            % want to use random numbers for the fit stuff use a different
            % random stream!
            obj.rs = RandStream('mcg16807','Seed',rSeed);
        end
        
        % simulation functions --------------------------------------------
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
        
        % fit functions ---------------------------------------------------
        function x0 = sample_randomParameters(obj)
            
            % starting parameter value for fit
            x0 = rand(1,length(obj.UB)) .* (obj.UB-obj.LB) + obj.LB;

        end
        
        function [L, latents] = lik(obj, b, D)
            
            % [L, latents] = lik(obj, b, D)
            %
            % likelihood for biased coin
            
            d = [D.Om];
            
            % compute log likelihood that coin with bias b generated the 
            % data (up to an additive constant)
            N1 = sum(d==1);
            N0 = sum(d==0);
            L = (N1 * log(b) + N0 * log(1-b));
            latents = [];
            
        end
        
    end
    
end