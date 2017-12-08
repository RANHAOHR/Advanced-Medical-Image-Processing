function res=complex_gaussian_3(x,weights,sigmas,means)

    [a,class_size] = size(means);
    y = zeros(256,class_size);
    for k = 1:class_size
        y(:,k) = gaussian_func(x,means(k),sigmas(k));
    end

    res = zeros(256,1);
    for k = 1:class_size
        res = weights(k) * y(:,k) + res;
    end
end