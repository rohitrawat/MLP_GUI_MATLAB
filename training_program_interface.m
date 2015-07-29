function [E_t_best E_v_best] = training_program_interface(training_file, N, M, Nh, Nit, validation_file, file_type)

if(file_type == 1)
    % call the program for regression case here:
    [E_t_best E_v_best Nh_best Nit_best Wi_best Wo_best lambda] = mlp_TRAIN(training_file, N, M, Nh, Nit, validation_file);
else
    % call the program for classification case here:
    [E_t_best E_v_best Nh_best Nit_best Wi_best Wo_best lambda] = mlp_TRAIN_CLASS(training_file, N, M, Nh, Nit, validation_file);
end
