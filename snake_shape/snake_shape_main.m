clear all;
close all;
clc;

% disp('To load the image, please put the file name');
% file_name = input('Please enter the file name:','s');
% FileName = ['/Volumes/NO NAME/',file_name];
% 
% load(FileName);

load('/Users/ranhao/Desktop/test_image/binim_example.mat');

if max(max(binim)) ==1
    binim = binim * 255;
end

forcetype = 3;
support = 15; %
std = 5;
Niter = 200;
Nsample = 100;

alpha = 0.001; %stretching coeff
beta = 0.001; %bending coeff
gamma = 1; %intergrate A
extcoef = 6;
balcoef = 0.0;
itergvf = 500;

snake_shape(binim, forcetype, std, support, Niter, Nsample, alpha, beta, gamma, extcoef, balcoef, itergvf);

% binim == edge image
% forcetype; 1 --> gradient, 2 --> distance, 3 --> GVF
% std and support are parameters for the gaussian filter used to smooth the
% image and produce the gradient-based force field
% Niter; number of iterations for snake loop
% nsample; number of points around the contour
% alpha; stretching coeff
% beta; bending coeff
% gamma; integration step
% extcoef; multiplication factor for the external force term
% balcoef; multiplicative term for the balloon force
% itergvf; the number of iterations used to create the GVF when forcetype = 3