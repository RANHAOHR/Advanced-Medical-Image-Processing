function [contourVentricleX, contourVentricleY] = detectVentricle(dynamic_image, centered)

    %--------------- get the coarse guess of ventricle -------------------
    if centered ==1
        areaOfInterest = dynamic_image;
        areaOfInterest(areaOfInterest < 12 & areaOfInterest ~= 0) = 255;
        areaOfInterest(areaOfInterest == 0) = 255;
        areaOfInterest(areaOfInterest ~= 255) = 0;
        [N_row,N_col] = size(areaOfInterest);

        centerX = N_row / 2;
        centerY = N_col / 2;

        ubX = centerX + 40;
        ubY = centerY + 40;
        lbX = centerX - 40;
        lbY = centerY - 40;

        for i = 1: N_row
            for j = 1:N_col
                if i > lbX && i < ubX && j > lbY && j < ubY
                else
                    areaOfInterest(i,j) = 0;
                end   
            end
        end
        
    else
        areaOfInterest = findVentricle(dynamic_image);
        areaOfInterest(areaOfInterest < 250) = 0;
        areaOfInterest(areaOfInterest >= 250) = 255;  
    end
% 
%     [nrow, ncol]=find(areaOfInterest == 255); 
%     centerX = mean(ncol);
%     centerY = mean(nrow);
%     
%     load('/Users/ranhao/Desktop/test_image/newVentricle.mat');
%     figure(3);
%     image(areaOfInterest);
%     colormap(gray(256));
%     hold on;
%     plot(x_ventricle, y_ventricle,'r-','linewidth',1);
%     hold on;
%     pause;
%     
%     x_ventricle = x_ventricle - mean(x_ventricle);
%     y_ventricle = y_ventricle - mean(y_ventricle);
%     
%     x_ventricle = x_ventricle + centerX;
%     y_ventricle = y_ventricle + centerY;
% 
%     plot(x_ventricle, y_ventricle,'b-','linewidth',1);

%--------------- or directly use the template of ventricle -------------------
    figure(3);
    image(areaOfInterest);
    colormap(gray(256));
    hold on;
    areaOfInterest = imfill(areaOfInterest, 'holes');
    BoundShape = bwboundaries(areaOfInterest);
    x_ventricle = BoundShape{1}(:,2);
    y_ventricle = BoundShape{1}(:,1);
    
    plot(x_ventricle, y_ventricle,'b-','linewidth',1);
    pause;
    
    %--------------- start snake shape -------------------
    
    %just to seperate the ventricle and the rest
    dynamic_image(dynamic_image > 50) = 255;
    dynamic_image(dynamic_image < 50) = 0;
    
    blur_image = imgaussfilt(dynamic_image, 3,'FilterSize',9);

    figure(4);
    edge_map = edge(blur_image,'Canny',0.1);

    edge_map = edge_map * 255;
    image(edge_map);
    colormap(gray(256));
    
    forcetype = 3;
    support = 15; %
    std = 5;
    Niter = 160;
    Nsample = 270;
    
    alpha = 0.01; %stretching coeff
    beta = 0.01; %bending coeff
    gamma = 1; %intergrate A
    extcoef = 6;
    balcoef = 0.01;
    itergvf = 260;
  
    [contourVentricleX, contourVentricleY] = snake_shape(edge_map, forcetype, std, support, Niter, Nsample, alpha, beta, gamma, extcoef, balcoef, itergvf, x_ventricle, y_ventricle);

end