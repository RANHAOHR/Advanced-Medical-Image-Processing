function phi_x_y=sum_phi(X_vec,C_vec)

phi_x_y = C_vec(1) * X_vec(2)^2 + C_vec(2) * X_vec(1)^2 + C_vec(3) * X_vec(1) * X_vec(2) + C_vec(4) * X_vec(2) + C_vec(5) * X_vec(1) + C_vec(6);
end