clear all;
close all;
clc;

disp('To load the image, please put the file name');
file_name = input('Please enter the file name:','s');
FileName = ['/Volumes/NO NAME/',file_name];

load(FileName);

c_vec = [1e-6,1e-6,1e-6,1e-7,1e-7,1e-7];
means = input('Please enter the mean vector:');
sigmas = input('Please enter the sigmas vector:');
p_wi = input('Please enter the p_wi vector:');

% starting 
figure(1);
inputImage = ima_att;

inputImage = double(inputImage);

[x,y] = meshgrid(1:1:256, 1:1:256);
subplot(2,2,1);
mesh(x,y,inputImage);

subplot(2,2,2);
image(inputImage);
colormap(jet(256));

%create normalized histogram
int_image = uint8(inputImage);
norm_hist_itensity=histogram_uint8(int_image);
x = 1:256;

subplot(2,2,3:4);
plot(x,norm_hist_itensity,'-r');

disp('Showing original image, Enter return to proceed');
pause;

% main part starts %%%%
figure(2);
y_original = inputImage(:,128);
[size_x, b] = size(y_original);
x_axis = 1:size_x;

yy_original = inputImage(128,:);

[N_row,N_col] = size(inputImage);
M = N_row * N_col;
image_vec = reshape(inputImage,M, 1);

for time =1:50
    
    sum_phi_vec = zeros(M,1);

    for row = 1:N_row
        for col = 1:N_col
            int = row + N_col * (col-1);
            x_vec = [row, col];
            sum_phi_vec(int) = sum_phi(x_vec,c_vec);
        end
    end

    X = 1:M;
    class_size = 2;

    y_indi= zeros(M,class_size);
    for i = 1:class_size
        y_indi(:,i) = gaussian_func(image_vec,means(i),sigmas(i),sum_phi_vec);
    end

    %first get w_j_i%%%
    sum_p_gi_wj = zeros(M,1);
    
    for j = 1:class_size 
        temp_p_gi = y_indi(:,j) * p_wi(j);
        sum_p_gi_wj = sum_p_gi_wj + temp_p_gi;
    end
     
    p_wj_gi = zeros(M,class_size);
    for j = 1:class_size
        p_wj_gi(:,j) = y_indi(:,j) * p_wi(j) ./sum_p_gi_wj;
    end

    alpha_j_i = zeros(M,class_size);

    for j = 1:class_size

        p_wi(j) = (1/M) * sum(p_wj_gi(:,j));
        means(j) = sum(p_wj_gi(:,j) .* (image_vec - sum_phi_vec))/sum(p_wj_gi(:,j));
        sigmas(j) = sum(p_wj_gi(:,j) .* (image_vec - sum_phi_vec - means(j)).^2)/sum(p_wj_gi(:,j));

        alpha_j_i(:,j) = p_wj_gi(:,j) / sigmas(j);
    end

    w_i = sum(alpha_j_i,2);
    g_ = alpha_j_i(:,1) * means(1)  + alpha_j_i(:,2) * means(2);
    g_bar = g_ ./ w_i;

    phi_matrix = zeros(M,6);
    phi_matrix_trans = zeros(M,6);
    for row = 1:N_row
        for col = 1:N_col
            ind = row + N_col * (col -1);
            x_vec = [row,col];

            phi_matrix_trans(ind,:) = [x_vec(2)^2, x_vec(1)^2, x_vec(2) * x_vec(1), x_vec(2), x_vec(1), 1];
            phi_matrix(ind,:) = w_i(ind)*[x_vec(2)^2, x_vec(1)^2, x_vec(2) * x_vec(1), x_vec(2), x_vec(1), 1];
        end
    end

    y_bar = w_i .*(image_vec - g_bar);
    c_vec = (phi_matrix_trans' * phi_matrix)^(-1) * phi_matrix_trans' * y_bar;
    
    subplot(3,2,1);
    plot(x_axis,y_original);
    title('original image(:,128)');

    result_image = image_vec - sum_phi_vec;
    final = reshape(result_image, 256,256);
    y_final = final(:,128);

    subplot(3,2,2);
    plot(x_axis,y_final);
    title('corrected image(:,128)');

    subplot(3,2,3);
    plot(x_axis,yy_original);
    title('original image(128,:)');

    subplot(3,2,4);
    yy = final(128,:);
    plot(x_axis,yy);
    title('corrected image(128,:)');
    pause(0.1);
end

for row = 1:N_row
    for col = 1:N_col
        ind = row + N_col * (col -1);
        x_vec = [row, col];
        sum_phi_vec(ind) = sum_phi(x_vec,c_vec);
    end
end
correction_surface = reshape(sum_phi_vec, 256,256);
correction_y = correction_surface(:,128);
correction_yy = correction_surface(128,:);

subplot(3,2,5);
plot(x_axis,correction_y);
title('corrected surface(:,128)');

subplot(3,2,6);
plot(x_axis,correction_yy);
title('corrected surface (128,:)');

figure(3);
subplot(2,2,1);
% make uint8
final = uint8(final);
correct_intensity = histogram_uint8(final);
plot(x,norm_hist_itensity);
hold on;
plot(x,correct_intensity,'-r');
title('corrected and original histogram');

subplot(2,2,2);
mesh(x,y,correction_surface);
title('estimate surface');

subplot(2,2,3);
image(inputImage);
colormap(jet(256));
title('original image');

subplot(2,2,4);
% final = uint8(final);
image(final);
colormap(jet(256));
title('corrected image');