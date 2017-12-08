function norm_hist_itensity=histogram_uint8(input_image)

    [N_row,N_col] = size(input_image);
    total_N = N_row * N_col;
    hist_itensity = zeros(256,1); % notice from 1 to 256
    for row = 1:N_row
        for col = 1:N_col
            temp_intensity = input_image(row, col) + 1;  %has to plus 1 since matrix starts from 1
            hist_itensity(temp_intensity) =  hist_itensity(temp_intensity) + 1;    
        end
    end

    norm_hist_itensity=hist_itensity/total_N;

end