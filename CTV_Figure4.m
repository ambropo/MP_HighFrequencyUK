%--------------------------------------------------------------------------%
%               Replication codes for Figure 1 of                          %
%       "Monetary Policy Transmission in the United Kingdom:               % 
%            A High Frequency Identification Approach""                    %     
%            by A. Cesa-Bianchi, G.Thwaites, and A. Vicondoa               %
%                             January, 2020                                %
%                                                                          %
%--------------------------------------------------------------------------%
% This code replicates the results in Cesa-Bianchi, G. Thwaites, and A. 
% Vicondoa (2020) "Monetary Policy Transmission in the United Kingdom: A 
% High Frequency Identification Approach" fortcoming in the European 
% Economic Review
%--------------------------------------------------------------------------%
% BEFORE RUNNING THE CODE: 
% Please make sure to add the folder "Codes" and all its subfolders to your 
% Matlab path. The code has been tested with Matlab R2018b.
%--------------------------------------------------------------------------%


% Import the series of monetary policy surprises
[xlsdata, xlstext] = xlsread('CTV_DATA.xlsx','Shocks_Long');
dataIV = Num2NaN(xlsdata);
vnamesIV = xlstext(1,2:end);
[nobs, nvar] = size(dataIV);

DATAplot2 = [dataIV(:,2) dataIV(:,1)];
vnames = [vnamesIV(2) vnamesIV(1)];

nticks = 10;
fo = 1975.0;

figure(7)
FigSize(28,10)
ylabel('Percent')
[ax,h1,h2] = plotyy(1:size(DATAplot2,1),DATAplot2(:,1),1:size(DATAplot2,1),DATAplot2(:,2)); hold on;
plot(zeros(size(DATAplot2,1)),'-k'); hold on
set(h1,'LineWidth',1.5); set(h1,'LineStyle','-','Color',rgb('blue'),'LineWidth',1)
DatesPlot(fo,size(DATAplot2,1),nticks,'m');  
set(h2,'LineWidth',1); set(h2,'LineStyle','-','Color',rgb('red'),'LineWidth',1.5)
set(gcf,'CurrentAxes',ax(2)); 
DatesPlot(fo,size(DATAplot2,1),nticks,'m');  
set(ax,{'ycolor'},{'k';'k'})
set(gcf, 'Color', 'w');
opt = LegOption; opt.handle = [h1 h2]; LegPlot({'Narrative (Cloyne and Hurtgen, 2016)','High frequency (this paper)'},opt);
SaveFigure('Figure_4',1);