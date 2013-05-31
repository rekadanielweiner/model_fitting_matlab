function [Xin, Xfit, Lfit] = parameterRecovery_v1(m, e)

% [Xin, Xfit] = parameterRecovery_v1(m, e)
% 
% simple simulate and fit 

% sample random parameters
Xin = m.sample_randomParameters;
m.setParameters(Xin);

% simulate
d = simulate(m, e);

% fit
[Xfit, Lfit] = fit_simple(m, d);
