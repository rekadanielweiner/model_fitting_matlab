classdef fit_oneBackCoin < handle
    
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
        
        function obj = fit_oneBackCoin()
            obj.k = 2;
            obj.UB = [1 1];
            obj.LB = [0 0];
            obj.pNames = {'b0' 'b1'};
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
            x0 = rand(obj.rs, 1,length(obj.UB)) .* (obj.UB-obj.LB) + obj.LB;

        end
        
        function [L, latents] = lik(obj, X, D)
            
            b0 = X(1);
            b1 = X(2);
            d = [D.Om];
            
            chi = 2*d(1:end-1) + d(2:end);
            
            % 0 0 - occurs with prob 1-b0
            n00 = sum(chi==0);
            
            % 0 1 - occurs with prob b0
            n01 = sum(chi==1);
            
            % 1 0 - occurs with prob 1-b1
            n10 = sum(chi==2);
            
            % 1 1 - occurs with prob b1
            n11 = sum(chi==3);
            
            % log likelihood
            L = n00 * log(1-b0) ...
                + n01 * log(b0) ...
                + n10 * log(1-b1) ...
                + n11 * log(b1); 
            % last term is because first trial is always 0.5
            latents = [];
            
        end
        
    end
    
end