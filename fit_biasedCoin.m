classdef fit_biasedCoin < handle
    
    properties
        
        k       % number of parameters
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
        
        function obj = fit_biasedCoin()
            obj.k = 1;
            obj.UB = 1;
            obj.LB = 0;
            obj.pNames = {'bias'};
            obj.setRandomSeed(cputime*10000);
        end
        
        function setRandomSeed(obj, rSeed)
            % note this is the random seed for simulation only - if you
            % want to use random numbers for the fit stuff use a different
            % random stream!
            obj.rs = RandStream('mcg16807','Seed',rSeed);
        end
        
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