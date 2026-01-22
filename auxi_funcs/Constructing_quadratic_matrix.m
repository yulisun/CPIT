function [Wsc,Wsi] = Constructing_quadratic_matrix_CP(t1_feature,t2_feature,S_t1,R_t1,S_t2,R_t2)
dist_t1 = pdist2(t1_feature',t1_feature','squaredeuclidean');
dist_t2 = pdist2(t2_feature',t2_feature','squaredeuclidean');
S_t1 = sign(S_t1);
S_t2 = sign(S_t2);
R_t1 = sign(R_t1);
R_t2 = sign(R_t2);

Sdist_t1 = S_t1.*dist_t1;
Sdist_t2 = S_t2.*dist_t2;
Rdist_t1 = R_t1.*dist_t1;
Rdist_t2 = R_t2.*dist_t2;
mxdist_t1 = max(dist_t1(:));
mxdist_t2 = max(dist_t2(:));
Rdist_t1(Rdist_t1==0) = mxdist_t1;
Rdist_t2(Rdist_t2==0) = mxdist_t2;
N = size(t1_feature,2);
f1 = zeros(N);
f3 = zeros(N);
f2 = zeros(N);
f4 = zeros(N);
f5 = zeros(N);
f6 = zeros(N);
for i = 1: N
    thS_x(i) = max(Sdist_t1(i,:)); 
    thS_y(i) = max(Sdist_t2(i,:));
    thR_x(i) = min(Rdist_t1(i,:));
    thR_y(i) = min(Rdist_t2(i,:));
end
%%
signS_t1 = sign(-dist_t2 + repmat(thS_y',[1 N])); % dist_y< rho1
signS_t1 = (signS_t1+1)/2;
signS_t2 = sign(-dist_t1 + repmat(thS_x',[1 N]));
signS_t2 = (signS_t2+1)/2;
f1 = S_t1&signS_t1 ; 
f2 = S_t2&signS_t2;
%%
signR_t1 = sign(dist_t2 - repmat(thR_y',[1 N])); % dist_y> rho2
signR_t1 = (signR_t1+1)/2;
signR_t2 = sign(dist_t1 - repmat(thR_x',[1 N]));
signR_t2 = (signR_t2+1)/2;
f3 =  double(S_t1&signR_t1);
f4 =  double(S_t2&signR_t2);
f5 =  double(R_t1&signS_t1);
f6 =  double(R_t2&signS_t2);
%%
f1 = f1.*exp(-dist_t2) ;
f2 = f2.*exp(-dist_t1) ;
for i = 1:N
    sum1 = max(sum(f1(i,:)),1);
    f1(i,:) = f1(i,:)/sum1;
    sum2 = max(sum(f2(i,:)),1);
    f2(i,:) = f2(i,:)/sum2;
    sum3 = max(sum(f3(i,:)),1);
    f3(i,:) = f3(i,:)/sum3;
    sum4 = max(sum(f4(i,:)),1);
    f4(i,:) = f4(i,:)/sum4;
    sum5 = max(sum(f5(i,:)),1);
    f5(i,:) = f5(i,:)/sum5;
    sum6 = max(sum(f6(i,:)),1);
    f6(i,:) = f6(i,:)/sum6;
end
Wsc = f1  +   f2;
Wsi = f3 + f4 + f5 + f6;


