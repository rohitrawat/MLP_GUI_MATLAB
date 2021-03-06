function [E_t_best E_v_best] = training_program_interface(training_file, N, M, Nh, Nit, validation_file, file_type, Extra)
%TRAINING_PROGRAM_INTERFACE Wrapper for the training program.
%
%  This program is a wrapper for the real training program. It receives
%  input from the GUI and uses them to call the training code. This allows
%  the same GUI to be used with different kinds of training algorithms by
%  simply modifying this file.
%
%  See also RESOURCES, RUN_TRAINING.

%  Rohit Rawat (rohitrawat@gmail.com), 08-23-2015
%  $Revision: 1 $ $Date: 23-Aug-2015 15:50:31 $

E_t_best = NaN;
E_v_best = NaN;
if(file_type == 1)
    error('This RBF code is only for classification.');
else
    % call the program for classification case here:
    h = gcf;
    disp('Please wait for the processing to finish..');
    disp('You can press Ctr-C in this window to stop the processing.');
    commandwindow;
    [E_t_best] = rbf_train(training_file, N, M, Nit, resources('weights_file'), validation_file);
    E_v_best = NaN;
    figure(h);
end
