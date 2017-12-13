clear all;
close all;
clc;

hand_images = cell(10,1);
for i = 1:10
    file_name = [num2str(i),'.tif'];
    FileName = ['/Users/ranhao/Downloads/ActiveShape2016/',file_name];
    hand_original = imread(FileName);
    hand_images{i} = hand_original;
end

hand_model = cell(10,1);

% figure(1);
% for i = 1:5
%     imshow(hand_images{i,1});
% 
%     hold on;
%     button = 1;
%     x_vec = [];
%     y_vec = [];
%     count = 0;
%     while button == 1
%         [current_x,current_y, button] = ginput(1);
% 
%         if button == 3
%             line([x_vec(count),x_vec(1)],[y_vec(count), y_vec(1)]);
%             break;
%         end
%         count = count + 1;
%         x_vec = [x_vec;current_x];
%         y_vec = [y_vec;current_y];
%         line(x_vec, y_vec);
%     end
%     
%     hand_model{i,1} = [x_vec, y_vec];
%     disp('next hand');
% end
% 
% disp('finished first five');
% 
% figure(2);
% for i = 6:10
%     imshow(hand_images{i,1});
% 
%     hold on;
%     button = 1;
%     x_vec = [];
%     y_vec = [];
%     count = 0;
%     while button == 1
%         [current_x,current_y, button] = ginput(1);
% 
%         if button == 3
%             line([x_vec(count),x_vec(1)],[y_vec(count), y_vec(1)]);
%             break;
%         end
%         count = count + 1;
%         x_vec = [x_vec;current_x];
%         y_vec = [y_vec;current_y];
%         line(x_vec, y_vec);
%     end
%     
%     hand_model{i,1} = [x_vec, y_vec];
%     disp('next hand');
% end
% 
% disp('finished');

%---------- create a test hand model -------------
figure(3);
image(hand_images{10,1});
colormap(gray(256));
[hand,test_x,test_y] = roipoly;
ptsize = size(test_x,1);
xy = [test_x,test_y];
xy = xy(1:ptsize-1,:);
save('/Users/ranhao/Desktop/test_image/hand_Testpoints2.mat','xy');