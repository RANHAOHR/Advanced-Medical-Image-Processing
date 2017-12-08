% This is file is to threshold input image into 2 or 3 classes
clear all;
close all;
clc;

testima = imread('/Users/ranhao/Desktop/test_image/cameraman.jpg');

%loading image
% disp('To load the image, please put the path and file name');
% driveName = input('Please enter your DRIVE name:','s');
% file_name = input('Please enter the file name:','s');
% 
% FileName = ['/Volumes/',driveName,'/',file_name]
% load(FileName);
% disp('Choose 2-class Ostu please enter 1, Choose 3-class Reddi, please enter 2');
% prompt = 'Please Enter ';
% method = input(prompt);
method = 2;
if method == 1
    disp('2-class Ostu thresholding');
    ostu;
elseif method ==2
    disp('3-class Reddi thresholding');
    reddi;
else
    disp('Please only enter 1 or 2 for thresholding methods');
    return
end
        

