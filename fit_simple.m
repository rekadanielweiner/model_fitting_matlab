function [Xfit, Lfit] = fit_simple(m, d)

% [Xfit, Lfit] = fit_simple(m, d)
%
% fit data d with model m

% define objective function (-ve likelihood so we can use fmincon)
obFunc = @(x) -m.lik(x, d);

% starting parameter value for fit
x0 = m.sample_randomParameters;

% options for fit
options = optimset('algorithm', 'interior-point', 'display', 'off');

% now call fmincon
[Xfit, Lfit] = fmincon(obFunc, x0, m.A, m.B, m.Aeq, m.Beq, m.LB, m.UB, m.NLcon, options);
Lfit = -Lfit;