%--------------------------------------------------------------------------%
%                         Replication codes for                            %
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

clear all; clear session; close all; clc
warning off all
addpath(genpath('Codes'))


%% Specify the Figure to replicate
% Select 1 if you want to replicate the figure
prepare_data=1;
Figure1=1;
Figure2=1;
Figure3=1;
Figure4=1;
Figure5=1;

%% Create the data set for estimation
if prepare_data==1
     [xlsdata, xlstext] = xlsread('CTV_DATA.xlsx','HFI');
     data = Num2NaN(xlsdata);
     vnames = xlstext(1,2:end);
     dates = xlstext(2:end,1);
     [xlsdata, xlstext] = xlsread('CTV_DATA.xlsx','HFI_surprise');
     dataIV = Num2NaN(xlsdata);
     vnamesIV = xlstext(1,2:end);
     save DATA.mat
end

%% Produce Figures
% Produce Figure 1
if Figure1==1
   CTV_Figure1
end

% Produce Figure 2
if Figure2==1
   CTV_Figure2
end

% Produce Figure 3
if Figure3==1
    CTV_Figure3a
    CTV_Figure3b
    CTV_Figure3c
    CTV_Figure3d
end

% Produce Figure 4
if Figure4==1
    CTV_Figure4
end

% Produce Figure 5
if Figure5==1
    CTV_Figure5
end