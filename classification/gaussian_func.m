function res=gaussian_func(x,mean,dev)
res = (1/sqrt(dev *2*pi))*exp(-1 * (x-mean).^2 /(2*dev));
end