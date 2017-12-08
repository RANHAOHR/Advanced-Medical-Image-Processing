function [close_point] = getCloestPoint(inputPt, targetPts)
    [a,ptsSize] = size(targetPts(1,:)); %containing the initial point as loop
    tempClosePt = zeros(2,1);
    minDist = 1000;
    close_point = targetPts(:,1);
    
    for j = 1:ptsSize-1
        u = (inputPt(1) - targetPts(1,j))*(targetPts(1,j+1) - targetPts(1,j)) + (inputPt(2) - targetPts(2,j))*(targetPts(2,j+1) - targetPts(2,j));
        u = u / ((targetPts(1,j+1) - targetPts(1,j))^2 + (targetPts(2,j+1) - targetPts(2,j))^2);
        if u < 0
            u = 0;
        elseif u > 1
            u = 1;
        end
        tempClosePt(1) = targetPts(1,j) + u * (targetPts(1,j+1) - targetPts(1,j)); %x
        tempClosePt(2) = targetPts(2,j) + u * (targetPts(2,j+1) - targetPts(2,j)); %y
        
        dist = norm(inputPt - tempClosePt);
        if dist < minDist
            minDist = dist;
            close_point = tempClosePt;
        end
            
    end

end