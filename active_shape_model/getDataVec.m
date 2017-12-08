function [dataVec] = getDataVec(inputVec)
    ptsSize = size(inputVec,2);
    dataVec = [];
    
    for i = 1:ptsSize
        dataVec = [dataVec ; inputVec(:,i)];
    end

end