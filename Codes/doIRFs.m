function IRFs = doIRFs(AL,Sigma,Gamma,VAR,scale)

if VAR.k==1
    DT          = scale*Gamma/Gamma(1);
   
elseif VAR.k==2 
    Gammap1     = Gamma(1:VAR.k,1:VAR.k)';
    Gammap2     = Gamma(VAR.k+1:VAR.n,1:VAR.k)';
    b21ib11     = (Gammap1\Gammap2)';
    Sig11       = Sigma(1:VAR.k,1:VAR.k);
    Sig21       = Sigma(VAR.k+1:VAR.n,1:VAR.k);
    Sig22       = Sigma(VAR.k+1:VAR.n,VAR.k+1:VAR.n);
    ZZp         = b21ib11*Sig11*b21ib11'-(Sig21*b21ib11'+b21ib11*Sig21')+Sig22;
    b12b12p     = (Sig21- b21ib11*Sig11)'*(ZZp\(Sig21- b21ib11*Sig11));
    b11b11p     = Sig11-b12b12p;
    b22b22p     = Sig22+b21ib11*(b12b12p-Sig11)*b21ib11';
    b12ib22     = ((Sig21- b21ib11*Sig11)'+b12b12p*b21ib11')/(b22b22p');
    b11iSig     = eye(VAR.k)/(eye(VAR.k)-b12ib22*b21ib11);
    b21iSig     = b21ib11*b11iSig;

    SigmaTSigmaTp = b11iSig\b11b11p/b11iSig';

 % Lower Triangular  
 s1 = sqrt(SigmaTSigmaTp(1,1));
 a  = SigmaTSigmaTp(2,1)/s1;
 s2 = sqrt(SigmaTSigmaTp(2,2)-a^2);
 SigmaTl = [s1 0 ; a s2];
 
 dtl     = [b11iSig;b21iSig]*SigmaTl;
 DT(:,:,2)     = scale*dtl(:,1)./dtl(1,1);
 DT(:,:,4)     = scale*dtl(:,2)./dtl(2,2);

 % Upper Triangular 
 s2 = sqrt(SigmaTSigmaTp(2,2));
 b  = SigmaTSigmaTp(1,2)/s2;
 s1 = sqrt(SigmaTSigmaTp(1,1)-b^2);
 SigmaTu = [s1 b; 0 s2];
 
 dtu     = [b11iSig;b21iSig]*SigmaTu;
 DT(:,:,1)     = scale*dtu(:,1)./dtu(1,1);
 DT(:,:,3)     = scale*dtu(:,2)./dtu(2,2);
end


irs = zeros(VAR.p+VAR.irhor,VAR.n,size(DT,2));
 for jj = 1:size(DT,3)
     irs(VAR.p+1,:,jj) = DT(:,jj);
     for tt=2:VAR.irhor
     lvars = (irs(VAR.p+tt-1:-1:tt,:,jj))';
     irs(VAR.p+tt,:,jj) = lvars(:)'*AL(:,1:VAR.p*VAR.n)';     
     end
 end

IRFs = irs(VAR.p+1:end,:,:); 