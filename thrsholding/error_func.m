function ret = error_func(threshs, hist_itensity)

k1 = ceil(threshs(1));
k2 = ceil(threshs(2));

% get mean of dark
w_k1 = 0;
mu_k1 = 0.0;
for i=1:k1
    w_k1 = w_k1 + hist_itensity(i);
    mu_k1 = mu_k1 + (i-1)*hist_itensity(i);
end
m_D = mu_k1 / w_k1;
% get mean of medium
w_km = 0;
mu_km = 0;
for i=k1:k2
    w_km = w_km + hist_itensity(i);
    mu_km = mu_km + (i-1)*hist_itensity(i);
end
m_M = mu_km / w_km;

% get mean of bright
w_k2 = 0;
mu_k2 = 0;
for i=k2:256
    w_k2 = w_k2 + hist_itensity(i);
    mu_k2 = mu_k2 + (i-1)*hist_itensity(i);
end
m_B = mu_k2 / w_k2;

% compute error

error_1 = (m_D + m_M) /2 -k1;
error_2 = (m_M + m_B) /2 -k2;

ret = [error_1,error_2];
end

