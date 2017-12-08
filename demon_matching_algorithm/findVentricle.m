function new_ventricle =findVentricle(target_image)

load('/Users/ranhao/Desktop/test_image/ThirionTest4_L3_2017.mat'); %Test_nine_polyn,Test_nine_spline
load('/Users/ranhao/Desktop/test_image/ventricle.mat'); %Test_nine_polyn,Test_nine_spline

static_image = target_image;
dynamic_image = dynamic;

[N_row,N_col] = size(static_image);

test= zeros(N_row, N_col);
[ventricle] = roipoly(test,x_ventricle, y_ventricle );
ventricle = ventricle*255;

alpha = 0.1;
space = 1 / (2^numlevel);

%------------- initilization ---------------------
init_x = N_row * space;
init_y = N_col * space;
Vx = ones(init_x,init_y)*0.0000001;
Vy = ones(init_x,init_y)*0.0000001;
std = 5;
support = 19;
thresh = 80;

%------------set the pyrimid ---------------
for i = 1 : numlevel+1
    %------------ update ---------------
    scale = space * 2^(i-1);    
    std = std - 0.01*(i-1);
    
    if scale ~= 1
        blur_S = imgaussfilt(static_image, std,'FilterSize',support);
        blur_S = imresize(blur_S, scale);
        [N_row, N_col] = size(blur_S);
        [Sx,Sy] = gradient(double(blur_S)); %get gradient
        delta_S = Sx.^2 + Sy.^2;
        [X,Y] = meshgrid(1:N_col, 1:N_row);

        blur_D = imgaussfilt(dynamic_image, std,'FilterSize',support);
        blur_D = imresize(blur_D, scale);
        new_D = interp2(X,Y,blur_D,(Vx+X),(Vy+Y),'spline');  
      
        blur_ventricle = imgaussfilt(ventricle, std,'FilterSize',support);
        blur_ventricle = imresize(blur_ventricle, scale);
    else
        blur_S = imresize(static_image, scale);
        [N_row, N_col] = size(blur_S);
        [Sx,Sy] = gradient(double(blur_S)); %get gradient
        delta_S = Sx.^2 + Sy.^2;
        [X,Y] = meshgrid(1:N_col, 1:N_row);

        blur_D = imresize(dynamic_image, scale);
        new_D = interp2(X,Y,blur_D,(Vx+X),(Vy+Y),'spline');
        
        blur_ventricle = imresize(ventricle, scale);

    end
    
    for nn = 1:thresh
        delta_SD = (blur_S - new_D);
        delta_Vx = (delta_SD .* Sx) ./ (delta_S + alpha * delta_SD.^2);
        delta_Vy = (delta_SD .* Sy) ./ (delta_S + alpha * delta_SD.^2);

        delta_Vx(isnan(delta_Vx)) = 0;
        delta_Vy(isnan(delta_Vy)) = 0;

        blur_dVx_ = imgaussfilt(delta_Vx, 15);
        blur_dVy_ = imgaussfilt(delta_Vy, 15);

        Vx = Vx + blur_dVx_;
        Vy = Vy + blur_dVy_;

        new_D = interp2(X,Y,blur_D,(Vx+X),(Vy+Y),'spline');
        new_ventricle = interp2(X,Y,blur_ventricle,(Vx+X),(Vy+Y),'spline');
        
    end

    Vx = imresize(Vx*2,2);
    Vy = imresize(Vy*2,2);
   
    thresh = thresh - 20;
end
    
figure(2);
image(new_ventricle);
colormap(gray);

end