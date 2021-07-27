% This file was adapted from code provided by Kurt Lunsford and Carl
% Jentsch. All errors are ours.

function VARbs = doMBBbootstrap(VAR,nboot,clevel,BlockSize)

nBlock = ceil(VAR.T/BlockSize);

        % create the blocks and centerings
        Blocks = zeros(BlockSize,VAR.n,VAR.T-BlockSize+1);
        MBlocks = zeros(BlockSize,VAR.k,VAR.T-BlockSize+1);
        for j = 1:VAR.T-BlockSize+1
            Blocks(:,:,j)  = VAR.res(j:BlockSize+j-1,:);
            MBlocks(:,:,j) = VAR.m(j:BlockSize+j-1,:);
        end
     
        %center the bootstrapped VAR errors
        centering = zeros(BlockSize,VAR.n);
        for j = 1:BlockSize
            centering(j,:) = mean(VAR.res(j:VAR.T-BlockSize+j,:),1);
        end
        centering = repmat(centering,[nBlock,1]);
        centering = centering(1:VAR.T,:);

        %center the bootstrapped proxy variables
        Mcentering = zeros(BlockSize,VAR.k);
        if VAR.k == 2
            for j = 1:BlockSize
                subM = VAR.m(j:VAR.T-BlockSize+j,:);
                Mcentering(j,:) = [mean(subM((subM(:,1) ~= 0),1),1),...
                    mean(subM((subM(:,2) ~= 0),2),1)];
            end
        elseif VAR.k == 1
            for j = 1:BlockSize
                subM = VAR.m(j:VAR.T-BlockSize+j,:);
                Mcentering(j,:) = [mean(subM((subM(:,1) ~= 0),1),1)];
            end
        end
            
        Mcentering = repmat(Mcentering,[nBlock,1]);
        Mcentering = Mcentering(1:VAR.T,:);
       
    
       
     jj=1;
     while jj<nboot+1
         
            %draw bootstrapped residuals and proxies
            index = ceil((VAR.T - BlockSize + 1)*rand(nBlock,1));
            U_boot = zeros(nBlock*BlockSize,VAR.n);
            M_boot = zeros(nBlock*BlockSize,VAR.k);
            for j = 1:nBlock
                U_boot(1+BlockSize*(j-1):BlockSize*j,:) = Blocks(:,:,index(j,1));
                M_boot(1+BlockSize*(j-1):BlockSize*j,:) = MBlocks(:,:,index(j,1));
            end
            U_boot = U_boot(1:VAR.T,:);
            M_boot = M_boot(1:VAR.T,:);

          % center the bootstrapped residuals and proxies

            U_boot = U_boot - centering;      

            for j = 1:VAR.k
                M_boot((M_boot(:,j)~=0),j) =...
                    M_boot((M_boot(:,j)~=0),j) - Mcentering((M_boot(:,j)~=0),j);
            end
                       
            resb  = U_boot';
            varsb = zeros(VAR.p+VAR.T,VAR.n);
            varsb(1:VAR.p,:)=VAR.vars(1:VAR.p,:);
         
            for j=VAR.p+1:VAR.p+VAR.T
            lvars = (varsb(j-1:-1:j-VAR.p,:))';
            varsb(j,:) = lvars(:)'*VAR.bet(1:VAR.p*VAR.n,:)+VAR.DET(j,:)*VAR.bet(VAR.p*VAR.n+1:end,:)+resb(:,j-VAR.p)';     
            end

            VARBS = VAR;
            VARBS.vars = varsb;
        
            VARBS.proxies = [VAR.proxies(1:VAR.p,:); M_boot];
            VARBS = doProxySVAR(VARBS);
            try
                [~,What,~] = CovAhat_Sigmahat_Gamma(VARBS.p,VARBS.X(:,[end end-size(VARBS.DET,2)+1:end-1 1:VARBS.n*VARBS.p]),VARBS.m,VARBS.res',VARBS.NWlags);                
                Gamma       = VARBS.res'*VARBS.m./VARBS.T; 
                VARbs.Waldstat_bs(jj,1) = (((VARBS.T^.5)*Gamma(1,1))^2)/What(((VARBS.n^2)*VARBS.p)+1,((VARBS.n^2)*VARBS.p)+1);
            catch
            end

         for i=1:size(VARBS.irs,3) 
         irs = VARBS.irs(:,:,i);
         IRS(:,jj,i) = irs(:);
         end
         
        jj=jj+1;   
     end  
        
% Confidence Bands 
%%%%%%%%%%%%%%%%%%

 for jj = 1:length(clevel)
     for i=1:size(IRS,3)  
     VARbs.irsH(:,:,jj,i)=reshape(quantile(IRS(:,:,i)',(1-clevel(jj)/100)/2),VAR.irhor, size(VAR.irs,2));
     VARbs.irsL(:,:,jj,i)=reshape(quantile(IRS(:,:,i)',1-(1-clevel(jj)/100)/2),VAR.irhor, size(VAR.irs,2));
     virs = VAR.irs(:,:,i);
     IRSm = mean(IRS,2);
     VARbs.irsM = reshape(IRSm,[41,7]);
     VARbs.irsHhall(:,:,i,jj)=VAR.irs(:,:,i)-reshape(quantile(IRS(:,:,i)'-(virs(:)*ones(1,nboot))',(1-clevel(jj)/100)/2),VAR.irhor, size(VAR.irs,2));
     VARbs.irsLhall(:,:,i,jj)=VAR.irs(:,:,i)-reshape(quantile(IRS(:,:,i)'-(virs(:)*ones(1,nboot))',1-(1-clevel(jj)/100)/2),VAR.irhor, size(VAR.irs,2));

     end
 end
