clear

defaultPlotParameters

% setup experiment
E = expt_coinTossTask;
E.T = 100;

% setup model
M{1}.sim = sim_biasedCoin;
M{1}.fit = fit_biasedCoin;
M{2}.sim = sim_oneBackCoin;
M{2}.fit = fit_oneBackCoin;

for i = 1:length(M)
    M{i}.sim.set_experiment(E);
end


%% parameter recovery =====================================================
m_sim = M{2}.sim;
m_fit = M{2}.fit;

%%
for i = 1:100
    m_sim.setRandomSeed(i);
    [Xin(i,:), Xfit(i,:)] = simAndFit_v1(m_sim, m_fit, E);
end

%%
figure(1); clf;
global orange
wg = ones(size(Xin,2)+1,1)*0.1;
wg(end) = 0.1;
wg(1) = 0.1;
ax = easy_gridOfEqualFigures([0.1 0.05], wg);

for j = 1:size(Xin,2)
    
    axes(ax(j)); hold on;
    plot([m_sim.LB m_sim.UB], [m_sim.LB m_sim.UB], 'k--')
    l = plot(Xin(:,j), Xfit(:,j),'.');
    set(l, 'color', orange)
    xlabel([m_sim.pNames{j} ' (sim)'])
    ylabel([m_fit.pNames{j} ' (fit)'])
    
end

%% confusion matrix =======================================================
nRepeats = 100;
for n = 1:nRepeats
    for i = 1:length(M)
        for j = 1:length(M)
            M{i}.sim.setRandomSeed(n);
            [~, ~, L(i,j,n)] = simAndFit_v1(M{i}.sim, M{j}.fit, E);
            BIC(i,j,n) = -2*L(i,j,n) + M{j}.fit.k * log(E.T);
        end
    end
end
%%
for i = 1:size(BIC,1)
    for n = 1:size(BIC,3)
        mdl(n,i) = i;
        [~, wins(n,i)] = min(BIC(i,:,n));
        
    end
end
C = sparse(zeros(length(M)));
for i =1:size(wins,2)
    C = C + sparse(mdl(:,i), wins(:,i),1, length(M), length(M));
end
C = C ./ repmat(sum(C,2), [1 size(C,2)]);

%%
figure(1); clf;
% set(gcf, 'position', [811   415   859   441]);
% dw = 0.08;
% [ax] = easy_gridOfEqualFigures([0.03 0.17 0.15], [0.09 0.12 0.12 0.02]);

figure(1); clf;

t = imageTextMatrix(round(C*100)/100);
% hold on;
l = addFacetLines(C);
set(l, 'linewidth', 1)
ylabel('simulated model')
xlabel('fit model')
set(t, 'fontsize', 20);

set(gca, 'ydir', 'reverse', ...
    'xtick', [1:2], ...
    'ytick', [1:2], ...
    'xticklabel', {'biased' '1-back'}, ...
    'yticklabel', {'biased' '1-back'}, ...
    'xaxislocation', 'top')

% addABCs(ax, [-0.05 0.05])