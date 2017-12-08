function error=class_error_func(x,y_object,input_param,class_size)

weights = input_param(1:class_size);
sigmas = input_param(class_size +1 : 2 *class_size);
means = input_param(2 *class_size +1 : 3 *class_size);

y_actual= complex_gaussian_3(x,weights,sigmas,means);

error = norm((y_object - y_actual),2);

plot(x,y_object,'--g','LineWidth',2);
hold on;
plot(x,y_actual,'-r','LineWidth',2);
pause(0.007);
hold off;
end