function  [grid]= draw_deform_map(X,Y,space)
    grid = zeros(X,Y);
    grid(1:space:X,:) = 255;
    grid(:,1:space:Y) = 255;
end