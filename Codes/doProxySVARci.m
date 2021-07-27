function VARci = doProxySVARci(VAR,clevel,method,nboot,BlockSize)

% Dimension of VARci.irsH and VARci.irsL: 
% 1: horizon 2: # of variables 3: clevel 4: shock (if more than one shock with instrument)

VARci.irsL = NaN*zeros([size(VAR.irs) length(clevel)]);
VARci.irsH = NaN*zeros([size(VAR.irs) length(clevel)]);

% Inference:
% method  1: Mertens and Ravn (2013) wild bootstrap 
%         2: Montiel-Olea Stock Watson (2016) bootstrap
%         3: Delta Method 
%         4: Montiel-Olea Stock Watson (2016) asy weak IV
%         5: Jentsch and Lunsford Moving Block Bootstrap

% Newey West Lags
try 
    NWlags = VAR.NWlags;
catch
    NWlags = floor(4*(((length(VAR.vars)-VAR.p)/100)^(2/9)));
end

if method == 1
    VARci = doWildbootstrap(VAR,nboot,clevel);
elseif method == 2
    VARci = doMSWbootstrap(VAR,nboot,clevel,NWlags);   
elseif method == 3
    if VAR.k==1
        VARci = doDeltaMethod(VAR,clevel,NWlags);
    elseif VAR.k==2
        VARci = doDeltaMethod_2shock(VAR,clevel,NWlags);
    end
elseif method == 4 
    if VAR.k==1
    VARci = doMSWwivrobust(VAR,clevel,NWlags); % Not available for k>1
    else
        fprintf('Invalid inference option for k>1 \n')
    end
elseif method == 5
    VARci = doMBBbootstrap(VAR,nboot,clevel,BlockSize);
elseif method == 6
    VARci = doMBBbootstrap_adj(VAR,nboot,clevel,BlockSize); 
end

irsL = reshape(VARci.irsL(:),VAR.irhor,VAR.n,1 + (VAR.k==2)*3,length(clevel)); 
irsH = reshape(VARci.irsH(:),VAR.irhor,VAR.n,1 + (VAR.k==2)*3,length(clevel));

if VAR.k == 1
[~,What,~] = CovAhat_Sigmahat_Gamma(VAR.p,VAR.X(:,[end end-size(VAR.DET,2)+1:end-1 1:VAR.n*VAR.p]),VAR.m,VAR.res',NWlags);                
 Gamma       = VAR.res'*VAR.m./VAR.T; 
VARci.Waldstat = (((VAR.T^.5)*Gamma(1,1))^2)/What(((VAR.n^2)*VAR.p)+1,((VAR.n^2)*VAR.p)+1);
end
