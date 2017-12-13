function [updatePoints, transformMatrix] = pointBaseRegistration(offsetPts, x_vec, y_vec)
    %---------------- ICP -------------------
    transformMatrix = eye(3,3);
    
    targetPoints = [x_vec;y_vec];
    updatePoints = offsetPts;

    [a, updatePtsSize] = size(updatePoints(1,:));
    closePointVec = zeros(2, updatePtsSize);
    
    for k = 1:50
        
        for i = 1:updatePtsSize
            currentPt = squeeze(updatePoints(:,i));
            closePointVec(:,i) = getCloestPoint(currentPt, targetPoints);
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
        
        newMat = eye(3,3);
        newMat(1:2,1:2) = rot;
        newMat(1:2,3) = t_vec;
        
        transformMatrix = newMat * transformMatrix;
        
%         plot(updatePoints(1,:), updatePoints(2,:),'y*','Linewidth',3);
%         hold on;
%         pause(0.1);
    end

end