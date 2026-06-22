function [Sp_en,R_en] = Graph_construction (X,opt)
X = X';
N = size(X,1);
S = zeros(N,N);
R = zeros(N,N);
[idx,distX] = knnsearch(X,X,'k',N);
Kn = opt.kmax;
Kf = opt.kF;
idx_att = idx(:,1:Kn);
idx_rep = fliplr(idx(:,end-Kf+1:end));
for i = 1:N
    id_x = idx_att(i,1:Kn);
    di = distX(i,1:Kn);
    k=Kn-1;
    W = (di(Kn)-di)/(k*di(Kn)-sum(di(1:k))+eps);
    S(i,id_x) = W;
end
for i = 1:N
    id_x = idx_rep(i,1:Kf);
    R(i,id_x) = 1;
end
Sp=sparse(S);
Sp_en = Sp + Sp * Sp + Sp* Sp* Sp;
Rp = sparse(R);
R_en = Rp + Sp_en*Rp + Rp*Sp_en;
R_en = full(R_en);
R_en = sign(R_en);
Sp_en = full(Sp_en);
for i = 1:N
    sumRen = sum(R_en(i,:));
    R_en(i,:) = R_en(i,:)/sumRen;
    sumSen = sum(Sp_en(i,:));
    Sp_en(i,:) = Sp_en(i,:)/sumSen;
end
