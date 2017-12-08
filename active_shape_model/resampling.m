function [output_pts] =resampling(Nsample, x_vec, y_vec)
    length = 0;
    [a,pts_size] = size(x_vec);
    for i=1:(pts_size-1)
        dist = sqrt((x_vec(i) - x_vec(i+1))^2 + (y_vec(i) - y_vec(i+1))^2);
        length = length + dist;
    end

    delta_length = length / Nsample;
    % interpolation
    l_total = [0];
    total_dist = 0;
    delta_vec = 0:delta_length:length;
    for i=1:(pts_size-1)
        temp_dist = sqrt((x_vec(i) - x_vec(i+1))^2 + (y_vec(i) - y_vec(i+1))^2);
        total_dist = total_dist + temp_dist;
        l_total = [l_total, total_dist];
    end

    interpo_x = interp1(l_total,x_vec,delta_vec);
    interpo_y = interp1(l_total,y_vec,delta_vec);
    
    output_pts = [interpo_x;interpo_y];
end