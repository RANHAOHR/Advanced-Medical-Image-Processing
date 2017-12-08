function outputImage = thresh_reddi(target_image)

outputImage = target_image;

%saturate
outputImage(outputImage < 0) = 0;
outputImage(outputImage > 255) = 255;

%get rid of the white part
outputImage(outputImage > 30) = 120;
image(outputImage);
colormap(gray(256)); 

%creat normalized histogram
[N_row,N_col] = size(outputImage);
total_N = N_row * N_col;

hist_itensity = zeros(256,1); %notice from 1 to 256
for row = 1:N_row
    for col = 1:N_col
        temp_intensity = ceil( outputImage(row, col) + 1 );  %has to puls 1 since matrix starts from 1
        hist_itensity(temp_intensity) =  hist_itensity(temp_intensity) + 1;
    end
end

hist_itensity=hist_itensity/total_N;

temp_error = [10,10];

max_iens = max(max(outputImage));

k1 = uint32(max_iens)/3;
k2 = uint32(max_iens)*2/3;

k_1_thresh = k1(:,:,1);
k_2_thresh = k2(:,:,1);
while (abs(temp_error(1)) > 1)
            temp_thresh = [k_1_thresh, k_2_thresh];
            temp_error = error_func(temp_thresh, hist_itensity);

            k_1_thresh = k_1_thresh + temp_error(1);
            k_2_thresh = k_2_thresh + temp_error(2);
end

k1 = k_1_thresh -1;
k2 = k_2_thresh -1;

for i = 1:N_row
    for j = 1:N_col

        if outputImage(i,j) > k2
            outputImage(i,j) = 255;
        elseif (outputImage(i,j) > k1) && (outputImage(i,j) <k2)
            outputImage(i,j) = 125;
        else
            outputImage(i,j) = 0;
        end

    end

end
