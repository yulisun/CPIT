function [Im_t1,DI_t1,delt_t1,Im_t2,DI_t2,delt_t2,CM]  = CPIT_main(image_t1,image_t2,opt)
%% Preprocessing
[image_t1,norm_par_t1] = image_normlized(image_t1,opt.type_t1);
[image_t2,norm_par_t2] = image_normlized(image_t2,opt.type_t2);
image_t1 = double(image_t1);
image_t2 = double(image_t2);
h = fspecial('average',5);
image_t1 = imfilter(image_t1, h,'symmetric');
image_t2 = imfilter(image_t2, h,'symmetric');
[Cosup,~] = GMMSP_Cosegmentation(image_t1,image_t2,opt.Ns);
[t1_feature,t2_feature,norm_par] = Prcfeature_extraction(Cosup,image_t1,image_t2); %feature extraction
fprintf(['Superpixle Cosegmentation is completed...... ' '\n'])
%% Relationships representation
opt.kmax =round(sqrt(size(t1_feature,2))*1);
opt.kF = opt.kmax*5;
[S_t1,R_t1] = Graph_construction(t1_feature,opt);
[S_t2,R_t2] = Graph_construction (t2_feature,opt);
[Wsc,Wsi] = Constructing_quadratic_matrix(t1_feature,t2_feature,S_t1,R_t1,S_t2,R_t2);
fprintf(['Structure representation is completed...... ' '\n'])
%% Image transformation
opt.lamda = 0.1;
opt.alpha_sit1 =  0.25;
opt.alpha_sit2 =  0.25;
alpha_sc = opt.alpha_sct1;
alpha_si=  opt.alpha_sit1;
opt.beta = opt.beta_t1;
[regression_t1, delt_t1,~,~] = CPIT_regression(t2_feature,S_t1,R_t1,Wsc,Wsi,opt,alpha_sc,alpha_si);% t1--->t2
fprintf(['Forward CPIT regression is completed...... ' '\n'])
alpha_sc = opt.alpha_sct2;
alpha_si=  opt.alpha_sit2;
opt.beta = opt.beta_t2;
[regression_t2, delt_t2,~,~] = CPIT_regression(t1_feature,S_t2,R_t2,Wsc,Wsi,opt,alpha_sc,alpha_si);
fprintf(['Backward CPIT regression is completed...... ' '\n'])
%% Change extraction
DI_t1  = suplabel2DI(Cosup,sum(delt_t1.^2,1));
[Im_t1,~,~] = suplabel2ImFeature(Cosup,regression_t1,size(image_t2,3));% t1--->t2
Im_t1 = DenormImage(Im_t1,norm_par(size(image_t1,3)+1:end));
if strcmp(opt.type_t2,'optical') == 1
    Im_t1 = Im_t1*(norm_par_t2(2)-norm_par_t2(1))+norm_par_t2(1);
elseif strcmp(opt.type_t2,'sar') == 1
    Im_t1 = Im_t1*(norm_par_t2(2)-norm_par_t2(1))+norm_par_t2(1);
    Im_t1 = exp(Im_t1)-1;
end

DI_t2  = suplabel2DI(Cosup,sum(delt_t2.^2,1));
[Im_t2,~,~] = suplabel2ImFeature(Cosup,regression_t2,size(image_t1,3));% t2--->t1
Im_t2 = DenormImage(Im_t2,norm_par(1:size(image_t1,3)));
if strcmp(opt.type_t1,'optical') == 1
    Im_t2 = Im_t2*(norm_par_t1(2)-norm_par_t1(1))+norm_par_t1(1);
elseif strcmp(opt.type_t1,'sar') == 1
    Im_t2 = Im_t2*(norm_par_t1(2)-norm_par_t1(1))+norm_par_t1(1);
    Im_t2 = exp(Im_t2)-1;
end

fx = sqrt(sum(delt_t1.^2,1));
fy = sqrt(sum(delt_t2.^2,1));
[CM_int,~] = MRF_CoSegmentation(Cosup,opt.alfa,t1_feature,t2_feature,fx,fy);
opt.Se = strel('disk', 3);
CM_int = imclose(CM_int,opt.Se);
CM = imopen(CM_int,opt.Se);
fprintf(['Change extraction is completed...... ' '\n'])