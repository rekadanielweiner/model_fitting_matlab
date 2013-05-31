function [Xin, Xfit, Lfit] = simAndFit_v1(m_sim, m_fit, e)

% [Xin, Xfit] = parameterRecovery_v1(m, e)
% 
% simple simulate and fit 

% sample random parameters
Xin = m_sim.sample_randomParameters;
m_sim.setParameters(Xin);

% simulate
d = simulate(m_sim, e);

% fit
[Xfit, Lfit] = fit_simple(m_fit, d);
