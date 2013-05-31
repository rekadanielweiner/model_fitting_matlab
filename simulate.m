function out = simulate(m, e)

% [Om, Oe, Sm, Se] = simulate(e, m)
% 
% Simulate model m performing experiment e
% 
% out is a structure with four parts (at the moment)
%   Om is observable output of model (e.g. choices, RTs etc ...)
%   Oe is observable output of experiment (e.g. stimuli on screen etc ...)
%   Sm is hidden state of model (e.g. action values etc ...)
%   Se is hidden state of task (e.g. trial number etc ...)

e.initialize;
m.initialize;

out(1:e.T) = struct('Om', nan, 'Oe', nan, 'Sm', nan, 'Se', nan);

count = 1;
while ~e.doneFlag
    
    e.update;
    m.update;
    
    % record output and latent states of model and experiment
    % TODO - preallocate these
    out(count).Om = m.O;
    out(count).Oe = e.O;
    
    out(count).Sm = m.S;
    out(count).Se = e.S;
    
    count = count + 1;
    
end