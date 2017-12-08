clear all;
close all;
clc;

% disp('To load the image, please put the file name');
% file_name = input('Please enter the file name:','s'); 
% FileName = ['/Volumes/NO NAME/',file_name];
% 
% load(FileName);

load('/Users/ranhao/Desktop/test_image/Test_nine_spline.mat'); %Test_nine_polyn,Test_nine_spline

figure(1);
origi_image = source;
target_image = target;

subplot(2,2,1);
image(origi_image);
colormap(gray(256));
hold on;
plot(xc1, yc1,'g*','Linewidth',7);

subplot(2,2,2);
image(target_image);
colormap(gray(256));
hold on;
plot(xc2, yc2,'g*','Linewidth',7);

[a,ptSize] = size(xc1);
X = 1:256;
Y = 1:256;
%-----------polynomial based method-------------
if method == 1
    Wx = zeros(6,1);
    Wy = zeros(6,1);
    A = zeros(ptSize, 6);
    A(:,1) = 1;
    for i = 1:ptSize
        A(i,2) = xc2(i);
        A(i,3) = yc2(i);
        A(i,4) = xc2(i)*yc2(i);
        A(i,5) = xc2(i)^2;
        A(i,6) = yc2(i)^2;
    end

    pseudoA = (A'*A)^(-1)*(A');
    Wx = pseudoA * xc1';
    Wy = pseudoA * yc1';

    source_mat = zeros(256*256, 6);
    for i = 1:256
        for j = 1:256
            source_vec = [1, j, i, i*j, j^2, i^2];
            source_mat(j+(i-1)*256,:) = source_vec;
        end
    end

    x1 = source_mat * Wx;
    y1 = source_mat * Wy;
    intensity = interp2(X,Y,origi_image,x1, y1);
    regist_image = intensity;
    regist_image = reshape(regist_image, 256,256)';

    subplot(2,2,3);
    image(regist_image);
    colormap(gray(256));
    
    subplot(2,2,4);
    deformMap = draw_deform_map(256,256,5);
    
    x1 = source_mat * Wx;
    y1 = source_mat * Wy;
    intensity = interp2(X,Y,deformMap,x1, y1);
    new_deform = intensity;
    new_deform = reshape(new_deform, 256,256)';

    image(new_deform);
    colormap(gray);
end

%------------- thin-plate spline -------------
if method == 2
    matrixSize = 3+ptSize;
    Wx = zeros(matrixSize,1);
    Wy = zeros(matrixSize,1);
    A = zeros(matrixSize, matrixSize);

    upper_left = zeros(ptSize, 3);
    upper_left(:,1) = 1;
    upper_left(:,2) = xc2';
    upper_left(:,3) = yc2';

    % compute r_mat
    up_mat = zeros(ptSize, ptSize);
    for i = 1: ptSize
        for j = i+1:ptSize
            value = (xc2(i) - xc2(j))^2 + (yc2(i) - yc2(j))^2;
            up_mat(i,j) = value * log(value);
        end  
    end
    down_mat = up_mat';
    r_mat = up_mat + down_mat;

    down_right = zeros(2,ptSize);
    down_right(1,:) = 1;
    down_right(2,:) = xc2;
    down_right(3,:) = yc2;

    A(1:ptSize, 1:3) = upper_left;
    A(1:ptSize, 4:matrixSize) = r_mat;
    A(ptSize+1: matrixSize, 4:matrixSize) = down_right;

    Wx = A^(-1) * [xc1,0,0,0]';
    Wy = A^(-1) * [yc1,0,0,0]';

    source_mat = zeros(256*256, matrixSize);
    for i = 1:256
        for j = 1:256
            r_value = (j - xc2).^2  + (i - yc2).^2;
            r_vec = r_value .* log(r_value);
            source_mat(j+(i-1)*256,:) = [1, j, i, r_vec];
        end
    end

    x1 = source_mat * Wx;
    y1 = source_mat * Wy;
    intensity = interp2(X,Y,origi_image,x1, y1);
    regist_image = intensity;
    regist_image = reshape(regist_image, 256,256)';

    subplot(2,2,3);
    image(regist_image);
    colormap(gray(256));

    subplot(2,2,4);
    deformMap = draw_deform_map(256,256,5);
    intensity = interp2(X,Y,deformMap,x1, y1);
    new_deform = intensity;
    new_deform = reshape(new_deform, 256,256)';

    image(new_deform);
    colormap(gray(256));
end