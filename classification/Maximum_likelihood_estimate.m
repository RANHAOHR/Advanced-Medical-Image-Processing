figure(1);
inputImage = testima;

imshow(inputImage);
hold off;
%create normalized histogram
[N_row,N_col] = size(inputImage);

hist_itensity = zeros(256,1); %notice from 1 to 256
for row = 1:N_row
    for col = 1:N_col
        temp_intensity = inputImage(row, col) + 1;  %has to plus 1 since matrix starts from 1
        hist_itensity(temp_intensity) =  hist_itensity(temp_intensity) + 1;
    end
end

% hist_itensity=hist_itensity;%/total_N;
figure(2);
x = 1:256;
plot(x,hist_itensity,'-r');

%initialization, just guess
means = input('Please enter the mean vector:');
sigmas = input('Please enter the sigmas vector:');
p_wi = input('Please enter the p_wi vector:');

%main part starts%%%%%%%%%%%%%%%%%%%%%%%%
error = 10;
delta_error = 10;

M = sum(hist_itensity);

figure(3);
norm_hist_itensity = hist_itensity / (N_row * N_col);

[a , class_size] = size(means);
while((error > 0.001) && (delta_error >0.00005 ))
    
    old_means = means;
    old_sigmas = sigmas;
    old_p_wi = p_wi;
    old_error = error;
    
    y_indi= zeros(256,class_size);
    for i = 1:class_size
        y_indi(:,i) = gaussian_func(x,means(i),sigmas(i));
    end
%     y_indi(:,1) = gaussian_func(x,means(1),sigmas(1));
%     y_indi(:,2) = gaussian_func(x,means(2),sigmas(2));
%     y_indi(:,3) = gaussian_func(x,means(3),sigmas(3));

    %first get w_j_i
    sum_p_gi_wj = zeros(256,1);
    for i = 1:256
        for j = 1:class_size
            sum_p_gi_wj(i) = sum_p_gi_wj(i) + y_indi(i,j) * p_wi(j);
        end
    end

    p_wj_gi = zeros(256,class_size);

    for i = 1:256
        for j = 1:class_size
            p_wj_gi(i,j) = y_indi(i,j) * p_wi(j) /sum_p_gi_wj(i);
        end
    end
    
   for j = 1:class_size
        %get equation 14
        p_wi(j) = (1/M) *sum(p_wj_gi(:,j).* hist_itensity); %use histogram to sum the M

        %get equation 15
        means(j) = sum(p_wj_gi(:,j).* hist_itensity.*[1:256]') / (M* p_wi(j)); 

        %get equation 16
        intensity = [1:256]';
        sigmas(j) = sum(p_wj_gi(:,j).* hist_itensity.*(intensity-means(j)).^2) / (M* p_wi(j)); 

   end

    error = norm(means - old_means) + norm(sigmas - old_sigmas) + norm(p_wi - old_p_wi)
    delta_error = abs(error - old_error);
    %show results
    y_test = complex_gaussian_3(x,p_wi,sigmas,means);
    plot(x,norm_hist_itensity,'-r');
    hold on;
    plot(x,y_test,'--','Linewidth',2);
    hold off;
    pause(0.02);
    
end

display('mean vec is');
display(means);
display('sigam vec is');
display(sigmas);
display('p_wi vec is');
display(p_wi);