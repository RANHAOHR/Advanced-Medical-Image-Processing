clear all;
close all;
clc;

disp('To load the image, please put the file name');
file_name = input('Please enter the file name:','s');
FileName = ['/Volumes/NO NAME/',file_name];

load(FileName);

disp('Choose EM please enter 1, Choose fmincon please enter 2')
prompt = 'Please Enter ';
method = input(prompt);

if method == 1
    disp('EM ');
    Maximum_likelihood_estimate;
elseif method ==2
    disp('fmincon optimization');
    simple_function_fitting;
else
    disp('Please only enter 1 or 2 for classification methods');
    return
end