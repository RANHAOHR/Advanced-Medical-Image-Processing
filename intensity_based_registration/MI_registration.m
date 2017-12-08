clear all;
close all;
clc;

disp('To load the image, please put the file name');
file_name = input('Please enter the file name:','s'); 
FileName = ['/Volumes/NO NAME/',file_name];

load(FileName);

%load('/Users/ranhao/Desktop/test_image/MItestimages.mat');

figure(1);
origi_image = mitest;
target_image = mitestrot;

subplot(2,2,1);
image(origi_image);
colormap(gray);
subplot(2,2,2);
image(target_image);
colormap(gray);

%define threshold:
low_thresh = 20;
high_thresh = 250;

initTheta = 500000;
bin = 64;

global jointHistogram;
%----------create MI values --------
func = @(theta)mutual_information_func(target_image,origi_image,theta, bin,low_thresh, high_thresh);
results = fminsearch(func,initTheta)