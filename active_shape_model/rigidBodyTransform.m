function [pts] = rigidBodyTransform(inputPts, theta, dx,dy)
init_rot = [cos(theta), -1*sin(theta);
            sin(theta), cos(theta)];
[a, ptsSize] = size(inputPts(1,:));
centerX = sum(inputPts(1,:)) / ptsSize;
centerY = sum(inputPts(2,:)) / ptsSize;

x = inputPts(1,:) - centerX;
y = inputPts(2,:) - centerY;

newPts = [x;y];

pts = init_rot * newPts;

pts(1,:) = pts(1,:) + dx;
pts(2,:) = pts(2,:) + dy;

end