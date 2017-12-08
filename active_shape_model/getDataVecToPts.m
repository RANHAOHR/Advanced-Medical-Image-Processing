function [handPts] = getDataVecToPts(eigenVec)
    ptsSize = size(eigenVec,1);
    handPts = [];
    
    for i = 1:2:ptsSize
        handPts = [handPts, eigenVec(i:i+1,1)];
    end

end