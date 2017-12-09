clear all;
close all;
clc;

% disp('To load the image, please put the file name');
% file_name = input('Please enter the file name:','s'); 
% FileName = ['/Volumes/NO NAME/',file_name];
% 
% load(FileName);

load('/Users/ranhao/Desktop/test_image/ThirionTest5_L3_2017.mat'); %Test_nine_polyn,Test_nine_spline

figure(1);
static_image = static;
dynamic_image = dynamic;

[N_row,N_col] = size(static_image);
subplot(2,2,1);
image(static_image);
colormap(gray(256));

subplot(2,2,2);
image(dynamic_image);
colormap(gray(256));

alpha = 0.1;
space = 1 / (2^numlevel);

%------------- initilization ---------------------
init_Ysize = N_col * space;
init_Xsize = N_row * space;
Vx = ones(init_Xsize,init_Ysize)*0.0000001;
Vy = ones(init_Xsize,init_Ysize)*0.0000001;
std = 5;
support = 19;
%--------- static -----------
blur_S = imgaussfilt(static_image, std,'FilterSize',support);
blur_S = imresize(blur_S, space);
[N_row, N_col] = size(blur_S);
[Sx,Sy] = gradient(double(blur_S)); %get gradient
delta_S = Sx.^2 + Sy.^2;
[X,Y] = meshgrid(1:N_col, 1:N_row);

%---------dynamic-----------
blur_D = imgaussfilt(dynamic_image, std,'FilterSize',support);
blur_D = imresize(blur_D, space);
new_D = interp2(X,Y,blur_D,(Vx+X),(Vy+Y),'spline');
thresh = 100;

%------------set the pyrimid ---------------
for i = 1 : numlevel+1

    for nn = 1:thresh
        delta_SD = (blur_S - new_D);
        delta_Vx = (delta_SD .* Sx) ./ (delta_S + alpha * delta_SD.^2);
        delta_Vy = (delta_SD .* Sy) ./ (delta_S + alpha * delta_SD.^2);

        delta_Vx(isnan(delta_Vx)) = 0;
        delta_Vy(isnan(delta_Vy)) = 0;

        blur_dVx_ = imgaussfilt(delta_Vx, 15);
        blur_dVy_ = imgaussfilt(delta_Vy, 15);

        Vx = Vx + blur_dVx_;
        Vy = Vy + blur_dVy_;

        new_D = interp2(X,Y,blur_D,(Vx+X),(Vy+Y),'spline');
        
        subplot(2,2,3);
        image(new_D);
        colormap(gray);

        diff_image = new_D - blur_S;
        subplot(2,2,4);
        image(diff_image);
        colormap(gray);
        
        pause(0.1);
    end

    Vx = imresize(Vx*2,2);
    Vy = imresize(Vy*2,2);
   
    %------------ update ---------------
    scale = space * 2^(i);    
    std = std - 0.01*i;
    
    if scale ~= 1
        blur_S = imgaussfilt(static_image, std,'FilterSize',support);
        blur_S = imresize(blur_S, scale);
        [N_row, N_col] = size(blur_S);
        [Sx,Sy] = gradient(double(blur_S)); %get gradient
        delta_S = Sx.^2 + Sy.^2;
        [X,Y] = meshgrid(1:N_col, 1:N_row);

        blur_D = imgaussfilt(dynamic_image, std,'FilterSize',support);
        blur_D = imresize(blur_D, scale);
        new_D = interp2(X,Y,blur_D,(Vx+X),(Vy+Y),'spline');  
    else
        blur_S = imresize(static_image, scale);
        [N_row, N_col] = size(blur_S);
        [Sx,Sy] = gradient(double(blur_S)); %get gradient
        delta_S = Sx.^2 + Sy.^2;
        [X,Y] = meshgrid(1:N_col, 1:N_row);

        blur_D = imresize(dynamic_image, scale);
        new_D = interp2(X,Y,blur_D,(Vx+X),(Vy+Y),'spline');
    end
    
    thresh = thresh - 20;
end



