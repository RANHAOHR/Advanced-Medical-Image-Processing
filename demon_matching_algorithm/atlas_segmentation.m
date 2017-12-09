clear all;
close all;
clc;

% disp('To load the image, please put the file name');
% file_name = input('Please enter the file name:','s'); 
% FileName = ['/Volumes/NO NAME/',file_name];
% 
% load(FileName);

%load the templates
load('/Users/ranhao/Desktop/test_image/ThirionTest4_L1_2017.mat'); %ThirionTest5_L3_2017

figure(1);
target_image = static;

image(target_image);
colormap(gray(256));
% [head,x_ventricle,y_ventricle] = roipoly;

center_ventricle = 2;
[contourVentricleX, contourVentricleY] =  detectVentricle(target_image, center_ventricle);
disp('press ENTER to continue');
pause;

[contourCavityX, contourCavityY, contourHeadX, contourHeadY] = detectHeadCavity(target_image);

figure(22);
image(target_image);
colormap(gray(256));
hold on;

plot(contourVentricleX, contourVentricleY,'g-','linewidth',2);
plot(contourHeadX, contourHeadY,'g-','linewidth',2);
plot(contourCavityX, contourCavityY,'g-','linewidth',2);
