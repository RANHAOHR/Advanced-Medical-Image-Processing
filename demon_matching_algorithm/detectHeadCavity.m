function [contourCavityX, contourCavityY, contourHeadX, contourHeadY] = detectHeadCavity(dynamic_image)

    [N_row,N_col] = size(dynamic_image);
    %get the threshed iamge of the brain
    figure(5);
    threshed_head = thresh_reddi(dynamic_image);
    
    figure(6);
    image(threshed_head);
    colormap(gray(256));    
    pause;
    
    %get the contour of head using Canny
    figure(7);
    headEdge = imgaussfilt(threshed_head, 3,'FilterSize',9); 
    headEdge = edge(headEdge,'Canny',0.1);
    headEdge = headEdge * 255;
    image(headEdge);
    colormap(gray(256));

    forcetype = 2;
    support = 15; %
    std = 5;
    Niter = 140;
    Nsample = 150;

    alpha = 0.01; %stretching coeff
    beta = 0.01; %bending coeff
    gamma = 1; %intergrate A
    extcoef = 1.5;
    balcoef = 0.0;
    itergvf = 500;

    %get head first, generate an outer snake
    edge_space = 5;
    y_head = zeros(8,1);
    y_head(1) = edge_space;
    y_head(2) = edge_space;
    y_head(3) = edge_space;
    y_head(4) = N_row / 2;
    y_head(5) = N_row - edge_space;
    y_head(6) = N_row - edge_space;
    y_head(7) = N_row - edge_space;
    y_head(8) = N_row / 2;
    
    x_head = zeros(8,1);
    x_head(1) = edge_space;
    x_head(2) = N_col / 2;
    x_head(3) = N_col - edge_space;
    x_head(4) = N_col - edge_space;
    x_head(5) = N_col - edge_space;
    x_head(6) = N_col / 2;
    x_head(7) = edge_space;
    x_head(8) = edge_space;
    
    x_cavity = x_head;
    y_cavity = y_head;
    
    [contourHeadX, contourHeadY] = snake_shape(headEdge, forcetype, std, support, Niter, Nsample, alpha, beta, gamma, extcoef, balcoef, itergvf, x_head,y_head);    
    disp('press ENTER to continue');
    pause;
    
    empty = zeros(N_row, N_col);
    [contour] = roipoly(empty, contourHeadX, contourHeadY);

    contour = 1 - contour;
    dist_trans = bwdist(contour);

    dist_trans(dist_trans > 2) = 0; %get rid of the inside of the distance map
    dist_trans(dist_trans ~= 0) = 255;
    dist_trans = imgaussfilt(dist_trans, 1.5,'FilterSize',5); 
    figure(8);
    image(dist_trans);
    colormap(gray(256));

    %get rid of the outer contour and leave the cavity
    headEdge = headEdge - dist_trans;
    headEdge(headEdge < 255) = 0;
    
    figure(9);
    image(headEdge);
    colormap(gray(256));

    [contourCavityX, contourCavityY] = snake_shape(headEdge, forcetype, std, support, Niter, Nsample, alpha, beta, gamma, extcoef, balcoef, itergvf, x_cavity,y_cavity);

end