function  [newX, newY] = snake_shape(binim, forcetype, std, support, Niter, Nsample, alpha, beta, gamma, extcoef, balcoef, itergvf,x_vec,y_vec)

[N_row,N_col] = size(binim);
inputImage = binim;
external_image = inputImage;

c_A = zeros(5);
c_A(1) = beta;
c_A(2) = -4*beta-alpha;
c_A(3) = 6*beta + 2*alpha;
c_A(4) = -4*beta-alpha;
c_A(5) = beta;

A = eye(Nsample)*c_A(3);
for i = 1:Nsample-1
    A(i,i+1) = c_A(4);
end
A(Nsample,1) = c_A(4);
for i = 1:Nsample-2
    A(i,i+2) = c_A(5);
end
A(Nsample-1,1) = c_A(5);
A(Nsample,2) = c_A(5);
for i = 2:Nsample
    A(i,i-1) = c_A(2);
end
A(1,Nsample) = c_A(2);
for i = 3:Nsample
    A(i,i-2) = c_A(1);
end
A(1,Nsample-1) = c_A(1);
A(2,Nsample) = c_A(1);

Internal_matrix = (eye(Nsample) + gamma*A)^(-1);
% --------------------- METHOD: Gradient -------------------------

if forcetype == 1
    smooth_image = imgaussfilt(external_image, std,'FilterSize',support);
    [dX,dY] = gradient(double(smooth_image));
    figure(10);
    quiver(dX,dY);
end
% ---------------- METHOD: Distance Transfrom -------------------
if forcetype == 2
    dist_transform = bwdist(external_image);
    [dX,dY] = gradient(dist_transform); % opposite direction?
    dX = -dX;
    dY = -dY;
    figure(10);
    quiver(dX,dY);
%     mesh(1:N_row,1:N_col,dist_transform);
%     pause;
end
% ---------------- METHOD: GVF -------------------
if forcetype == 3
    figure(10);
    delta_t = 1;
    r = 0.2;

    dmax = max(max(external_image));
    dmin = min(min(external_image));
    external_image = (external_image - dmin) / (dmax- dmin);
    [dX, dY] = gradient(double(external_image));
    
    b_xy = dX.^2 + dY.^2;
    cx_ = b_xy .* dX;
    cy_ = b_xy .* dY;

    u_matrix = dX;
    v_matrix = dY;

    for i = 1:itergvf

        u_i_right = circshift(u_matrix ,[0,1]);
        u_j_down = circshift(u_matrix ,[1,0]);
        u_j_up = circshift(u_matrix ,[-1,0]);
        u_i_left = circshift(u_matrix ,[0,-1]);

        v_i_right = circshift(v_matrix ,[0,1]);
        v_j_down = circshift(v_matrix ,[1,0]);
        v_j_up = circshift(v_matrix ,[-1,0]);
        v_i_left = circshift(v_matrix ,[0,-1]);

        u_matrix = u_matrix .* (ones(N_row,N_col) - b_xy *delta_t)+ r*(u_i_right+ u_j_down+u_i_left + u_j_up -4*u_matrix) + cx_ * delta_t;
        v_matrix = v_matrix .* (ones(N_row,N_col) - b_xy *delta_t)+ r*(v_i_right+ v_j_down+v_i_left + v_j_up -4*v_matrix) + cy_ * delta_t;
        quiver(u_matrix,v_matrix);
        pause(0.1);
    end
    dX = u_matrix;
    dY = v_matrix;
end

% ---------------- Get Input -------------------

[interpo_x, interpo_y] = resampling(Nsample, x_vec, y_vec);

% ---------------- METHOD: Ballon force -------------------
n_x = zeros(Nsample,1);
n_y = zeros(Nsample,1);
delta_x = interpo_x(2) - interpo_x(Nsample);
delta_y = interpo_y(2) - interpo_y(Nsample);
delta_l = sqrt(delta_x^2 + delta_y^2);
n_x(1) = delta_y / delta_l;
n_y(1) = -delta_x / delta_l;
for i = 2:Nsample
    delta_x = interpo_x(i+1) - interpo_x(i-1);
    delta_y = interpo_y(i+1) - interpo_y(i-1);

    delta_l = sqrt(delta_x^2 + delta_y^2);

    n_x(i) = delta_y / delta_l;
    n_y(i) = -delta_x / delta_l;
end

%main part start
figure(20);
image(inputImage);
colormap(jet(256));
hold on;

[mesh_X, mesh_Y] = meshgrid(1:N_col,1:N_row);

newX = x_vec;
newY = y_vec;

for n=1:Niter
    
    [interpo_x, interpo_y] = resampling(Nsample, newX, newY);
    X = interpo_x(1:Nsample)';
    Y = interpo_y(1:Nsample)'; 

    external_x = interp2(mesh_X,mesh_Y,dX,X,Y);
    external_y = interp2(mesh_X,mesh_Y,dY,X,Y);
    
    X = Internal_matrix * (X + extcoef * external_x + balcoef * n_x);
    Y = Internal_matrix * (Y + extcoef * external_y + balcoef * n_y);

    newX = [X;X(1)];
    newY = [Y;Y(1)];
    
    plot(newX, newY,'r-','linewidth',1);
    hold on;
    pause(0.1);
end
figure(21)
image(inputImage);
colormap(jet(256));
hold on;
plot(newX, newY,'g-','linewidth',2);
 
