figure(1);
inputImage = testima;

imshow(inputImage);
hold off;
%create normalized histogram
figure(2);
[N_row,N_col] = size(inputImage);
total_N = N_row * N_col;

hist_itensity = zeros(256,1); %notice from 1 to 256
for row = 1:N_row
    for col = 1:N_col
        temp_intensity = inputImage(row, col) + 1;  %has to plus 1 since matrix starts from 1
        hist_itensity(temp_intensity) =  hist_itensity(temp_intensity) + 1;
    end
end

hist_itensity=hist_itensity/total_N;
x = 1:256;
plot(x,hist_itensity,'-r');

% starting function
means = input('Please enter the mean vector:');
sigmas = input('Please enter the sigmas vector:');
weights = input('Please enter the p_wi vector:');

[a, class_size] = size(means);

param_init = [weights,sigmas,means];
y_init = complex_gaussian_3(x,weights,sigmas,means);
plot(x,y_init,'r');
hold on;

figure(3);
func = @(param)class_error_func(x,hist_itensity,param,class_size);

%optimization functions
% results = fminsearch(func,param_init)

weight_b = [0;1];
sigma_b = [0;1000];
mean_b = [0;255];

bounds = [];

for i = 1:class_size
    bounds = [bounds,weight_b];
end

for i = 1:class_size
    bounds = [bounds,sigma_b];
end

for i = 1:class_size
    bounds = [bounds,mean_b];
end

ub = bounds(2,:);
lb = bounds(1,:);
A = [];
b = [];
Aeq = [];
beq = [];

results = fmincon(func,param_init,A,b,Aeq,beq,lb,ub)
