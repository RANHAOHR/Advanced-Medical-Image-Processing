close all;
set(0,'defaultfigurecolor','w') 

figure(1);
% inputImage = imread('/Users/ranhao/Desktop/cameraman.jpg');
inputImage = testima;
imshow(inputImage);
hold off;
%creat normalized histogram
figure(2);
[N_row,N_col] = size(inputImage);
total_N = N_row * N_col;

hist_itensity = zeros(256,1); %notice from 1 to 256
for row = 1:N_row
    for col = 1:N_col
        temp_intensity = inputImage(row, col) + 1;  %has to puls 1 since matrix starts from 1
        hist_itensity(temp_intensity) =  hist_itensity(temp_intensity) + 1;
    end
end

%-----or joint histogram --------
%     edge = low_thresh : (high_thresh - low_thresh) / bin :high_thresh; 
%     jointHistogram = histcounts2(target_image,candidate_image, edge, edge);

hist_itensity=hist_itensity/total_N;
bar(hist_itensity);
hold off;
%compute delta_b, argmax(k)delta_b

%get mu_T: total mean level of the original picture
mu_T = 0.0;
for i =1:256 %has to start from 1, remember to reduce back to 0
    mu_T = mu_T + (i-1) * hist_itensity(i);
end

%find the max thresh
opti_delta_B = 0.0;
opti_thresh = 0.0;
for i_thresh = 1:256
    w_k = 0;
    mu_k = 0;
    for j = 1:i_thresh
        w_k = w_k + hist_itensity(j);
        mu_k = mu_k + (j-1)* hist_itensity(j);
    end
    
    delta_B = (mu_T * w_k - mu_k)^2 / (w_k - w_k * w_k);
    if delta_B > opti_delta_B
        opti_delta_B = delta_B;
        opti_thresh = i_thresh -1;
    end
    
end

%show threshold in histogram
disp(['Optimal threshold is: ' num2str(opti_thresh)]);

figure(3)
bar(hist_itensity);
hold on;
plot([opti_thresh,opti_thresh],[0,0.05],'r');
%show thresholding results
for i = 1:N_row
    for j = 1:N_col

        if inputImage(i,j) > opti_thresh

            inputImage(i,j) = 255;

        else
            inputImage(i,j) = 0;

        end

    end

end
figure(4);
imshow(inputImage);
