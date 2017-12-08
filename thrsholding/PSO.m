function res=PSO(init_threshs, hist_itensity)

opti_function=@error_func;

%initialization
D = 2;
bound_1 = [100,160];
bound_2 = [120,200];

Num = 500;  % number of particles 1000
c1 = 2; % flying weights according to the local best
c2 = 2; % flying weights according to the global best
MaxIter = 5;  % max iteration
w = 0.75;  % speed weight

x = zeros(Num,D);
velocity = zeros(Num,D);
local_best_paticles = zeros(Num,D);

local_error = zeros(Num,1);

init_k1 = init_threshs(1);
init_k2 = init_threshs(2);

%
for i=1:Num

    x(i,1)=bound_1(1)+rand*(bound_1(2)-bound_1(1));
    x(i,2)=bound_2(1)+rand*(bound_2(2)-bound_2(1));  
     
    for j = 1:D
       velocity(i,j)=rand; 
    end
end

%initialize local variables
for i=1:Num
    local_error(i)=opti_function(x(i,:), hist_itensity);
    local_best_paticles(i,:)=x(i,:);
end

global_best=x(1,:);
for i=2:Num
    if opti_function(global_best,hist_itensity)>opti_function(x(i,:),hist_itensity)
        global_best=x(i,:);
    end
end

%start main

for t=1:MaxIter
    for i=1:Num
        velocity(i,:)=w*velocity(i,:)+c1*rand*(local_best_paticles(i,:)-x(i,:))+c2*rand*(global_best-x(i,:));
        x(i,:)=x(i,:)+velocity(i,:);
        %boundry check if necessary
        if x(i,1) > bound_1(2) || x(i,1) < bound_1(1)
            x(i,1)=bound_1(1)+rand*(bound_1(2)-bound_1(1));
        end
        if x(i,2) > bound_2(2) || x(i,2) < bound_2(1)
            x(i,2)=bound_2(1)+rand*(bound_2(2)-bound_2(1));
        end   
        
        temp_error = opti_function(x(i,:), hist_itensity);
        if local_error(i) > temp_error
            local_error(i)= temp_error;
            local_best_paticles(i,:)=x(i,:);
        end
        
        if local_error(i) <opti_function(global_best, hist_itensity)
            global_best=local_best_paticles(i,:);
        end
        
        hold on;
        plot([global_best(1),global_best(1)],[0,0.05],'g');
        hold on;
        plot([global_best(2),global_best(2)],[0,0.05],'g');
        
    end
%     i_error = opti_function(global_best, hist_itensity);
    res = global_best;
    pause(0.1);
end

end
