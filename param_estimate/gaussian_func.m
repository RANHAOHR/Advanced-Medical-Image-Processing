function res=gaussian_func(x,mean,dev,phi_vec)

    res = (1/sqrt(dev *2*pi))*exp(-1 * (x - mean - phi_vec).^2 /(2*dev));
end