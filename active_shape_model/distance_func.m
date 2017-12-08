function distance=distance_func(inputParam, contourPts, distMap)
    hold on;

    theta = inputParam(1)*1000;
    inputX = inputParam(2);
    inputY = inputParam(3);

    newPts = rigidBodyTransform(contourPts, theta, inputX, inputY);
    plot(newPts(1,:), newPts(2,:),'g*','Linewidth',10);
    plot(newPts(1,:), newPts(2,:),'g-','Linewidth',1);

    [a,ptsSize] = size(newPts);
    % satuation: dont; want any NAN in distance
    for j = 1: ptsSize
        if newPts(1,j) < 1
            newPts(1,j) = 1;
        elseif newPts(1,j) > 256
            newPts(1,j) = 256;
        end

        if newPts(2,j) < 1
            newPts(2,j) = 1;
        elseif newPts(2,j) > 256
            newPts(2,j) = 256;
        end
    end

    [mesh_X,mesh_Y] = meshgrid(1:256,1:256);

    interpDistMap = interp2(mesh_X,mesh_Y,double(distMap),newPts(1,:),newPts(2,:));
    distance = norm(interpDistMap);
    pause(0.1);
    hold on;
end