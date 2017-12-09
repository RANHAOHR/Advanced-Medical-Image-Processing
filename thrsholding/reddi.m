close all;
set(0,'defaultfigurecolor','w') 


figure(1);

inputImage = testima;
imshow(inputImage);

hold off;

%creat normalized histogram
[N_row,N_col] = size(inputImage);
total_N = N_row * N_col;

hist_itensity = zeros(256,1); %notice from 1 to 256
for row = 1:N_row
    for col = 1:N_col
        temp_intensity = ceil( inputImage(row, col) + 1 );  %has to puls 1 since matrix starts from 1
        hist_itensity(temp_intensity) =  hist_itensity(temp_intensity) + 1;
    end
end

hist_itensity=hist_itensity/total_N;
figure(2);
bar(hist_itensity);
hold off;

% compute delta_b, and compute error function

res = zeros(1,2);

figure(3)
bar(hist_itensity);
temp_error = [10,10];

max_iens = max(max(inputImage));

k1 = uint32(max_iens)/3;
k2 = uint32(max_iens)*2/3;

k_1_thresh = k1(:,:,1);
k_2_thresh = k2(:,:,1);
while (abs(temp_error(1)) > 1)
            temp_thresh = [k_1_thresh, k_2_thresh];
            temp_error = error_func(temp_thresh, hist_itensity);

            k_1_thresh = k_1_thresh + temp_error(1);
            k_2_thresh = k_2_thresh + temp_error(2);
            
            line([k_1_thresh,k_1_thresh],[0,0.05]);
            line([k_2_thresh,k_2_thresh],[0,0.05]);
            pause(0.1);
end

k1 = k_1_thresh -1
k2 = k_2_thresh -1

%show test results

hold on;
plot([k1,k1],[0,0.05],'r');
hold on;
plot([k2,k2],[0,0.05],'r');
hold off;
pause(0.1);

for i = 1:N_row
    for j = 1:N_col

        if inputImage(i,j) > k2
            inputImage(i,j) = 255;
        elseif (inputImage(i,j) > k1) && (inputImage(i,j) <k2)
            inputImage(i,j) = 125;
        else
            inputImage(i,j) = 0;
        end

    end

end

hold off;

figure(4);
imshow(inputImage);  
