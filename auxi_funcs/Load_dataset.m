if strcmp(dataset,'dataset#1') == 1 % MCD of multispectral VS. multispectral
    image_t1 = imread('Italy_1.bmp');
    image_t2 = imread('Italy_2.bmp');
    gt = imread('Italy_gt.bmp');
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
    opt.beta_t1 =  5; % t1--->t2
    opt.beta_t2 =   30; % t2--->t1
    opt.alpha_sct1 =  32; % t1--->t2
    opt.alpha_sct2 =  32; % t2--->t1
    opt.alfa = 0.1; % CM Segmentation parameter
elseif strcmp(dataset,'dataset#2') == 1 % MCD of multispectral VS. multispectral
    image_t1 = imread('Img7-Bc.tif');
    image_t2 = imread('Img7-Ac.tif');
    gt = imread('Img7-C.tif');
    ratio = 4;
    image_t1 = image_t1(1:ratio:end,1:ratio:end,:);
    image_t2 = image_t2(1:ratio:end,1:ratio:end,:);
    gt = gt(1:ratio:end,1:ratio:end,:);
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
    opt.beta_t1 =  5; % t1--->t2
    opt.beta_t2 =   5; % t2--->t1
    opt.alpha_sct1 =  4; % t1--->t2
    opt.alpha_sct2 =  4; % t2--->t1
    opt.alfa = 0.05; % CM Segmentation parameter
elseif strcmp(dataset,'dataset#3') == 1 % MCD of SAR VS. Optical
    image_t1 = imread('shuguang_1.bmp');
    image_t2 = imread('shuguang_2.bmp');
    gt = imread('shuguang_gt.bmp');
    opt.type_t1 = 'sar';
    opt.type_t2 = 'optical';
    opt.beta_t1 =  5; % t1--->t2
    opt.beta_t2 =   5; % t2--->t1
    opt.alpha_sct1 =  4; % t1--->t2
    opt.alpha_sct2 =  32; % t2--->t1
    opt.alfa = 0.05; % CM Segmentation parameter
elseif strcmp(dataset,'dataset#4') == 1 % MCD of SAR VS. Optical
    load('California.mat')
    image_t2_temp = image_t1;
    image_t1 = image_t2;
    image_t2 = image_t2_temp;
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
    opt.beta_t1 =  5; % t1--->t2
    opt.beta_t2 =   30; % t2--->t1
    opt.alpha_sct1 =  32; % t1--->t2
    opt.alpha_sct2 =  32; % t2--->t1
    opt.alfa = 0.2; % CM Segmentation parameter
elseif strcmp(dataset,'dataset#5') == 1 % MCD of Optical VS. SAR
    image_t1 = imread('Img5-Bc.tif');
    image_t2 = imread('Img5-A.tif');
    gt = imread('Img5-C.tif');
    ratio = 4;
    image_t1 = image_t1(1:ratio:end,1:ratio:end,:);
    image_t2 = image_t2(1:ratio:end,1:ratio:end,:);
    gt = gt(1:ratio:end,1:ratio:end,:);
    opt.type_t1 = 'optical';
    opt.type_t2 = 'sar';
    opt.beta_t1 =  5; % t1--->t2
    opt.beta_t2 =   30; % t2--->t1
    opt.alpha_sct1 =  32; % t1--->t2
    opt.alpha_sct2 =  32; % t2--->t1
    opt.alfa = 0.05; % CM Segmentation parameter
else
    image_t1 = imread('image_t1.tif');
    image_t2 = imread('image_t2.tif');
    gt = imread('gt.tif');
    opt.type_t1 = 'optical'; % type of image_t1
    opt.type_t2 = 'sar'; % type of image_t2
    opt.beta_t1 =  5; % t1--->t2
    opt.beta_t2 =   5; % t2--->t1
    opt.alpha_sct1 =  32; % t1--->t2
    opt.alpha_sct2 =  32; % t2--->t1
    opt.alfa = 0.05; % CM Segmentation parameter
end
Ref_gt = double(gt(:,:,1));
Ref_gt = Ref_gt/max(Ref_gt(:));
%% plot images
figure;
if strcmp(dataset,'dataset#4') == 1
    subplot(331);imshow(image_t1(:,:,[4 3 2])+1,[]);title('imaget1')
    subplot(332);imshow(image_t2,[-1 1]);title('imaget2')
    subplot(333);imshow(Ref_gt,[]);title('Refgt')
else
    subplot(131);imshow(image_t1);title('imaget1')
    subplot(132);imshow(image_t2);title('imaget2')
    subplot(133);imshow(Ref_gt,[]);title('Refgt')
end
