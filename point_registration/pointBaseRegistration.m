function pointBaseRegistration(method,noisem,nsample,theta,shiftx,shifty,xc,yc)

inputImage = zeros(256,256);
[row, col] = size(inputImage);

edge_map = roipoly(inputImage, xc, yc);
edge_map = imcomplement(edge_map);
inputContour = bwdist(edge_map);

for i = 1:row
    for j =1:col
        if inputContour(i,j) > 1
            inputContour(i,j) = 0;
        elseif inputContour(i,j) == 1
                inputContour(i,j) = 255;
        end
    end
end
figure(1);
image(inputContour);
colormap(jet(256));
hold on;

x_vec = xc;
y_vec = yc;

[a,ptsSize] = size(x_vec);
center_x = sum(x_vec) / ptsSize;
center_y = sum(y_vec) / ptsSize;

% center_x = 128;
% center_y = 128;

samplePoints =resampling(nsample, x_vec, y_vec);
[r,c] = size(samplePoints);
samplePoints = samplePoints + noisem*randn(r,c);

% %----------------initial set up-------------------
offset_theta = theta;
offsetX = center_x + shiftx;
offsetY = center_y + shifty;

offsetPts = rigidBodyTransform(samplePoints, offset_theta, offsetX, offsetY);
plot(offsetPts(1,:), offsetPts(2,:),'g*','Linewidth',10);

distMap = bwdist(inputContour);
disp('Enter to start');
pause;
% %----------------fmincon to optimize the distance-------------------
if method ==1 
    initParam = [theta-0.3, center_x, center_y];
    func = @(initParam)distance_func(initParam, offsetPts, distMap);
    
%     ub = [pi,256,256];
%     lb = [-pi,0,0];
%     A = [];
%     b = [];
%     Aeq = [];
%     beq = [];

    figure(2);
    image(distMap);
    colormap(jet(256));
    hold on;
%     results = fmincon(func,initParam,A,b,Aeq,beq,lb,ub)
    results = fminsearch(func,initParam)

    finalPts = rigidBodyTransform(offsetPts, results(1)*1000, results(2), results(3));
    figure(3);
    image(distMap);
    colormap(jet(256));
    hold on;
    plot(finalPts(1,:), finalPts(2,:),'y*','Linewidth',5);
    plot(finalPts(1,:), finalPts(2,:),'y-','Linewidth',1);
end
%---------------- ICP -------------------
if method ==2
    targetPoints = [x_vec;y_vec];
    updatePoints = offsetPts;

    [a, updatePtsSize] = size(updatePoints(1,:));
    closePointVec = zeros(2, updatePtsSize);
    figure(4);
    image(inputContour);
    colormap(jet(256));
    hold on;
    for k = 1:150
        for i = 1:updatePtsSize
            currentPt = squeeze(updatePoints(:,i));
            closePointVec(:,i) = getCloestPoint(currentPt,targetPoints);
        end

        %demean: Point based registration
        meanUpdatePts = [sum(updatePoints(1,:)) / updatePtsSize; sum(updatePoints(2,:)) / updatePtsSize];
        updatePts_demean(1,:) = updatePoints(1,:) - meanUpdatePts(1);
        updatePts_demean(2,:) = updatePoints(2,:) - meanUpdatePts(2);

        meanClosePts = [sum(closePointVec(1,:)) / updatePtsSize; sum(closePointVec(2,:)) / updatePtsSize];
        closePts_demean(1,:) = closePointVec(1,:) - meanClosePts(1);
        closePts_demean(2,:) = closePointVec(2,:) - meanClosePts(2);

        H = updatePts_demean * closePts_demean';
        [U,S,V] = svd(H);

        rot = V*U';
        t_vec = meanClosePts - rot * meanUpdatePts;

        updatePoints = rot * updatePoints;
        for i = 1:updatePtsSize
            updatePoints(:,i) = updatePoints(:,i) + t_vec;
        end
        plot(updatePoints(1,:), updatePoints(2,:),'y*','Linewidth',3);
        hold on;
        pause(0.1);
    end

    figure(5);
    image(inputContour);
    colormap(jet(256));
    hold on;
    plot(updatePoints(1,:), updatePoints(2,:),'g*','Linewidth',3);
    plot(updatePoints(1,:), updatePoints(2,:),'g-','Linewidth',0.5);
end