function [Z, delt,RelDiff,delt_all] = CPIT_regression(Y,Sx,Rx,Wsc,Wsi,opt,alpha_sc,alpha_si)
% X----> Y
opt.kesi = 0.1;
opt.kesi_delt = 0.1;
ss_Z = 0.01;
ss_delt = ss_Z;
opt.SGDMw = 0.5;
lamda = opt.lamda;
Niter = opt.Niter;
N_inner = opt.N_inner;
mu = 0.4;
[M,N] = size(Y);
R = zeros(M,N);% initialization
Z = Y;
delt = zeros(M,N);% initialization
Sx = Sx-diag(diag(Sx));
Rx = Rx-diag(diag(Rx));
Wsc = Wsc-diag(diag(Wsc));
Wsi = Wsi-diag(diag(Wsi));
T_att  = 4 * LaplacianMatrix(Sx);% 4*Lx
T_deltatt = 4 * LaplacianMatrix(Wsc);% 4*Lsi

for i=1:Niter
    kesi = opt.kesi;
    distZ = (pdist2(Z',Z')).^2;
    value_att = sum(sum(Sx.*distZ));   
    kesi_delt = opt.kesi_delt;
    distDelt = (pdist2(delt',delt')).^2;
    value_RepS = sum(sum(Rx./(kesi+distZ)));
    valueDelt_RepS = sum(sum(Wsi./(kesi_delt+distDelt)));
    betaz_w(i) = value_att/(value_RepS+eps);
    alpha_si_w(i) = value_att/(valueDelt_RepS+eps);   
    if i > 10 && betaz_w(i) > betaz_w(i-1)
        break
    end
    if i<= Niter/4
        beta_adj = opt.beta * betaz_w(i)/10;
        alpha_sc_adj = alpha_sc/10;
        alpha_si_adj = alpha_si * alpha_si_w(i)/10;
    elseif i<= Niter/2
        beta_adj = opt.beta * betaz_w(i)/4;
        alpha_sc_adj = alpha_sc/4;
        alpha_si_adj = alpha_si * alpha_si_w(i)/4;
    elseif i<= Niter*0.75
        beta_adj = opt.beta * betaz_w(i)/2;
        alpha_sc_adj = alpha_sc/2;
        alpha_si_adj = alpha_si * alpha_si_w(i)/2;
    else
        beta_adj = opt.beta * betaz_w(i)/1;
        alpha_sc_adj = alpha_sc/1;
        alpha_si_adj = alpha_si * alpha_si_w(i)/1;
    end
    delt_old = delt;
    v = 0;
    for j = 1:N_inner
        distZ = (pdist2(Z',Z')).^2;  
        T_rep  = 4 * LaplacianMatrix(Rx./((kesi+distZ).^2));
        Tx = T_att - beta_adj*T_rep;
        Gradient_Z = Z*(Tx + mu * eye(N)) - (mu * (Y + delt) - R) ;
        v = opt.SGDMw*v + (1-opt.SGDMw)*Gradient_Z;
        Z = Z - ss_Z*v;
    end
    v = 0;
    for j = 1:N_inner
        distDelt = (pdist2(delt',delt')).^2;
        T_deltrep  = 4 * LaplacianMatrix(Wsi./((kesi_delt+distDelt).^2));
        Tdeltx = alpha_sc_adj*T_deltatt - alpha_si_adj*T_deltrep;
        Gradient_delt1 = delt*(Tdeltx + mu * eye(N)) -R + mu * (Y - Z);
        ddelt = sqrt(sum(delt.^2,1));
        Gradient_delt2 = repmat(lamda./(ddelt+eps),[size(delt,1),1]).*delt;
        Gradient_delt = Gradient_delt1 + Gradient_delt2;
        v = opt.SGDMw*v + (1-opt.SGDMw)*Gradient_delt;
        delt = delt - ss_delt*v;
    end
    R = R + mu * (Z - Y - delt); % W update
    delt_all(:,:,i) = delt;
    RelDiff(i) = norm(delt - delt_old,'fro')/norm(delt,'fro');
    if i > 3 && RelDiff(i) < 1e-2
        break
    end
end