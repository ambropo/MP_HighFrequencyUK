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
[xlsdata, xlstext] = xlsread('CTV_DATA.xlsx','HFI_surprise');
dataIV = Num2NaN(xlsdata);
vnamesIV = xlstext(1,2:end);
[nobs, nvar] = size(dataIV);


% Plot the series of monetary policy surprises
DATAplot = dataIV(216:end,1);
nticks = 20;
fo = 1997+5/12;
fo1 = 2015;
date = fo:1/12:fo1;

FigSize(26,12)
plot(date',DATAplot,'-','LineWidth',1.5,'Color','b'); hold on
plot(date',zeros,'-k'); hold on
axis tight; hold on
ylabel('Percent')
SaveFigure('Figure1',1);
