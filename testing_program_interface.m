function [E_test] = testing_program_interface(testing_file, weights_file, desired_outputs_present, write_processing_results, file_type)

if(file_type == 1)
    % call the program for regression case here:
    [E_test] = mlp_PROCESSING(weights_file, testing_file, desired_outputs_present, write_processing_results)
else
    % call the program for classification case here:
    [E_test] = mlp_PROCESSING_CLASS(weights_file, testing_file, desired_outputs_present, write_processing_results)
end
