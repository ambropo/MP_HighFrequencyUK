% Plot the IRFs

% Set the units of each variable for the plot (vertical axis)
display1= cell2mat(values(VAR.MAP,plotdisplay));
ti = {'Pctg. Points'; 'Percent'; 'Pctg. Points'; 'Percent'; 'Basis Points'; 'Basis Points'; 'Basis Points';'Percent';};

% Plot the IRF to a monetary policy shock (Figure 2)
if size(VAR.vars,2)==7
figure(nr)
FigSize(16,20)
for nvar = 1:length(display1)
    subplot(4,2,nvar)
    H = PlotSwathe(VARci.irsM(:,display1(nvar),shock), [VARci.irsH(:,display1(nvar)) VARci.irsL(:,display1(nvar))], rgb('black')); hold on; 
    plot(zeros(VAR.irhor-1),'--k','LineWidth',0.5)
    title(VARvnames_long{nvar})
    ylabel(ti{nvar})
    axis tight
    set(gca,'Layer','top')
end
end
SaveFigure(sname,1)

% Plot the IRF to a monetary policy shock of the additional variables
% (Figure 3)
if size(VAR.vars,2)>7
figure(nr)
H = PlotSwathe(VARci.irsM(:,VAR.n,shock), [VARci.irsH(:,VAR.n) VARci.irsL(:,VAR.n)], rgb('black')); hold on; 
    plot(zeros(VAR.irhor-1),'--k','LineWidth',0.5)
    title(VARvnames_long{VAR.n},'FontSize',18)
    ylabel(ti{VAR.n},'FontSize',16)
    set(gca,'XTick',0:10:VAR.irhor,'FontSize',16)
    %set([ti2]);
    %set([ti],);
    axis tight
set(gca,'Layer','top')
SaveFigure([sname '_one'],1)
end