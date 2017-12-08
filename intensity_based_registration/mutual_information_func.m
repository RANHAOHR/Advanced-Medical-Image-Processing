function [MI_value]=mutual_information_func(origi_image, target_image,theta,bin, low_thresh, high_thresh)
    global jointHistogram;
    candidate_image = imrotate(origi_image, theta,'crop');
    show_candicate = candidate_image;
    
    interval = 256 / bin;
    candidate_image = candidate_image / interval;
    target_image = target_image / interval;
    
    low_thresh = floor(low_thresh / interval);
    high_thresh = floor(high_thresh / interval);

    candidate_image = floor(candidate_image);
    target_image = floor(target_image);
    candidate_image(candidate_image < low_thresh)= 0;
    candidate_image(candidate_image > high_thresh)= bin + 1;
    
    target_image(target_image < low_thresh)= 0;
    target_image(target_image > high_thresh)= bin + 1;
    jointHistogram = zeros(bin,bin);
    for row = 1:bin
        for col = 1:bin
            jointHistogram(row, col) = sum(sum(candidate_image==row & target_image==col));
        end
    end

    show_hist = jointHistogram;
 
    jointHistogram = jointHistogram + 1e-20;
    jointHistogram = jointHistogram / sum(sum(jointHistogram));
    % ------- entropy of the candidate image -----------
    [x_size, y_size] = size(jointHistogram);
    H_x = 0;
    for i = 1:x_size
        p_x = sum(jointHistogram(i,:));
        H_x = H_x - p_x * log2(p_x);
    end

    % ------- entropy of the target image -----------
    H_y = 0;
    for j = 1:y_size
        p_y = sum(jointHistogram(:,j)) ;
        H_y = H_y - p_y * log2(p_y);
    end
    % ------- joint entropy -----------
    H_xy = 0;
    for i = 1:x_size
        for j = 1:y_size
            H_xy = H_xy - jointHistogram(i,j) * log2(jointHistogram(i,j));
        end
    end
    
    MI_value = H_x + H_y - H_xy;
    MI_value = 1 / MI_value;
    
    subplot(2,2,3);
    image(show_candicate);
    colormap(gray);
    
    subplot(2,2,4);
    image(double(show_hist));
    colormap(gray);
    
    pause(0.05);
end