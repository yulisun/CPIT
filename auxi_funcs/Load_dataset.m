if strcmp(dataset,'dataset#1') == 1 % MCD of multispectral VS. multispectral
    image_t1 = imread('Italy_1.bmp');
    image_t2 = imread('Italy_2.bmp');
    gt = imread('Italy_gt.bmp');
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
elseif strcmp(dataset,'dataset#2') == 1 % MCD of multispectral VS. multispectral
    image_t1 = imread('Img7-Bc.tif');
    image_t2 = imread('Img7-Ac.tif');
    gt = imread('Img7-C.tif');
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
elseif strcmp(dataset,'dataset#3') == 1 % MCD of SAR VS. Optical
    image_t1 = imread('shuguang_1.bmp');
    image_t2 = imread('shuguang_2.bmp');
    gt = imread('shuguang_gt.bmp');
    opt.type_t1 = 'sar';
    opt.type_t2 = 'optical';
elseif strcmp(dataset,'dataset#4') == 1 % MCD of SAR VS. Optical
    load('California.mat')
    image_t2_temp = image_t1;
    image_t1 = image_t2;
    image_t2 = image_t2_temp;
    opt.type_t1 = 'optical';
    opt.type_t2 = 'optical';
elseif strcmp(dataset,'dataset#5') == 1 % MCD of Optical VS. SAR
    image_t1 = imread('Img5-Bc.tif');
    image_t2 = imread('Img5-A.tif');
    gt = imread('Img5-C.tif');
    opt.type_t1 = 'optical';
    opt.type_t2 = 'sar';
end
Ref_gt = double(gt(:,:,1));
Ref_gt = Ref_gt/max(Ref_gt(:));
%% plot images
figure;
subplot(131);imshow(image_t1);title('imaget1')
subplot(132);imshow(image_t2);title('imaget2')
subplot(133);imshow(Ref_gt,[]);title('Refgt')
