clear all;
close all;
clc;
% disp('To load the image, please put the file name');
% file_name = input('Please enter the file name:','s'); 
% FileName = ['/Volumes/NO NAME/',file_name];
% 
% load(FileName);

 load('/Users/ranhao/Desktop/test_image/RegistParam.mat');
method =2;
pointBaseRegistration(method,noisem,nsample,theta,shiftx,shifty,xc,yc)
