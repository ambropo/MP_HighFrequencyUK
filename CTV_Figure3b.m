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

load DATA

% Specify the sample for estimation
fo_txt = '1992m1';
fo = find(strcmp(fo_txt,dates));
fo1_txt = '2015m1';
fo1 = find(strcmp(fo1_txt,dates));

% Specify the variable for the VAR
sname = 'Figure_3b';
VARvnames_long = {'One-Year Rate';'CPI';'Unemployment';'Exchange Rate';'Corporate Spread';'Mortgage Spread';'BAA Corporate Spread - US'; 'Credit';};
VARvnames      = {'i_1YR';'CPI';'unempl';'fxbis';'corp_spread';'mortg_spread';'us_baa';'cred';};

% Specify the external instrument
IVvnames_long = {'Sterling Future';};
IVvnames      = {'cm2'};
IVnvar        = length(IVvnames);

% Observations
VARnvar = length(VARvnames);
nobs = size(data(fo:fo1,:),1);
dates = dates(fo:fo1);
for ii=1:length(vnamesIV)
    DATA.(vnamesIV{ii}) = dataIV(fo:fo1,ii);
end
for ii=1:length(vnames)
    DATA.(vnames{ii}) = data(fo:fo1,ii);
end

% Create matrices of variables for the VAR
ENDO = nan(nobs,VARnvar);
for ii=1:VARnvar
    ENDO(:,ii) = DATA.(VARvnames{ii});
end

% Create matrices of variables for the instrument
IV = nan(nobs,IVnvar);
for ii=1:IVnvar
    IV(:,ii) = DATA.(IVvnames{ii});
end
IV(isnan(IV)) = 0;

DATASET.TSERIES = ENDO; 
DATASET.LABEL   = VARvnames_long;
DATASET.UNIT    = ones(1,length(VARvnames_long)); 
DATASET.FIGLABELS= VARvnames_long;
DATASET.MAP = containers.Map(DATASET.LABEL,1:size(DATASET.TSERIES,2));

% VAR specification
%%%%%%%%%%%%%%%%%%%%
VAR.p = 2;                  % Number of lags 
VAR.irhor  = 41;            % Impulse Response Horizon
VAR.select_vars = VARvnames_long;
VAR.vars = ENDO;
VAR.MAP = containers.Map([VAR.select_vars],[1:size(VAR.vars,2)]);
VAR.proxies = IV;
VAR.DET = ones(length(VAR.vars),1); % Deterministic Terms

% ESTIMATE THE PROXY-SVAR TO OBTAIN THE DIFFERENT CONFIDENCE INTERVALS
VAR        = doProxySVAR(VAR);

% Back up the reduced form residuals for the F-test
%sname2 = strcat('RES_',sname);
%xlswrite(sname2,[VAR.res VAR.proxies(VAR.p+1:end)]);

% Inference:
%%%%%%%%%%%%
nboot     = 5000;        % Number of Bootstrap Samples
clevel    = 68;          % Bootstrap Percentile Shown
BlockSize = floor(5.03*length(VAR.vars).^0.25); % size of blocks in the MBB bootstrap
seed      = 2;           % seed for random number generator
rng(seed);               % iniate the random number generator

VARci_mbb      = doProxySVARci(VAR,clevel,6,nboot,BlockSize);

shocksize = -0.25;
VAR.irs   = shocksize*VAR.irs;

legendflag = 1;
shock = 1;
plotdisplay = VARvnames_long;
VARci.irsL = shocksize*VARci_mbb.irsL(:,:,shock);
VARci.irsH = shocksize*VARci_mbb.irsH(:,:,shock);
VARci.irsM = shocksize*VARci_mbb.irsM(:,:,shock);
xlab_text='horizon (months)';
nr=4;
do_IRS_Figure



