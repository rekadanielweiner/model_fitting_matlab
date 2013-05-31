classdef expt_coinTossTask < handle % I always like to inherit from the handle class
    
    properties
        O           % observable output of task (nothing in this case)
        S           % state of the task (current trial number)
        T           % total number of trials
        doneFlag    % indicator telling you when the task is done
    end
    
    methods
        
        function obj = expt_coinTossTask
            % constructor function
        end
        
        function initialize(obj, pars)
            
            obj.doneFlag = false;
            obj.S = 0;
            obj.O = 0;
            
        end
        
        function update(obj)
            
            obj.S = obj.S + 1;
            if obj.S == obj.T
                obj.doneFlag = true;
            end
            
        end
        
    end
    
    
end