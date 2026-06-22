clear all;
close all
addpath(genpath(pwd));
%% load dataset
% dataset#1 to dataset#5
dataset = 'dataset#1';
Load_dataset % For other datasets, we recommend a similar pre-processing as in "Load_dataset"
fprintf(['\n Data loading is completed...... ' '\n'])

%% Parameter setting
% With different parameter settings, the results will be a little different
% Ns: the number of superpxiels,  Ns = 2500 is recommended.
opt.Ns = 2500;
opt.Niter = 20;
opt.N_inner = 10;

%% CPIT
fprintf(['\n CPIT is running...... ' '\n'])
time = clock;
[Im_t1,DI_t1,delt_t1,Im_t2,DI_t2,delt_t2,CM] = CPIT_main(image_t1,image_t2,opt);
fprintf(['\n' '====================================================================== ' ])
fprintf('\n');fprintf('The total computational time of CPIT is %i \n' ,etime(clock,time));
fprintf([ '====================================================================== ' ])

%% Displaying results
fprintf(['\n Displaying the results...... ' '\n'])

figure;
subplot(131);imshow(remove_outlier(DI_t1),[]);title('forward DI')
subplot(132);imshow(remove_outlier(DI_t2),[]);title('backward DI')
subplot(133);imshow(CM);title('change map')

[tp,fp,tn,fn,fplv,fnlv,~,~,OA,kappa,imw]=performance(CM,Ref_gt);
F1 = 2*tp/(2*tp + fp + fn);
result_CM = 'CM: OA is %4.3f; kappa is %4.3f; F1 is %4.3f \n';
fprintf(result_CM,OA,kappa,F1)

