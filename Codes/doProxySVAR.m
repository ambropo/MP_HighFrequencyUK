function VAR = doProxySVAR(VAR)

X      = lagmatrix(VAR.vars,1:VAR.p);
X      = X(VAR.p+1:end,:);
Y      = VAR.vars(VAR.p+1:end,:);

VAR.m  = VAR.proxies(VAR.p+1:end,:);

[VAR.T,VAR.n] = size(Y);
VAR.k         = size(VAR.m,2);

% A. Run VAR
%%%%%%%%%%%%
VAR.bet   = [X VAR.DET(VAR.p+1:end,:)]\Y; 
VAR.res   = Y-[X VAR.DET(VAR.p+1:end,:)]*VAR.bet;
VAR.Sigma = (VAR.res'*VAR.res)/(VAR.T-size(VAR.bet,1));
VAR.X     = [X VAR.DET(VAR.p+1:end,:)];
VAR.OLS   = OLSmodel(VAR.res(:,1),VAR.m,1);

% B. Narrative Identification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AL          = VAR.bet(1:end-size(VAR.DET,2),:)';
Sigma       = VAR.Sigma;
Gamma       = VAR.res'*VAR.m./VAR.T;

VAR.irs     = doIRFs(AL,Sigma,Gamma,VAR,-1);






