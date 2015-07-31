function value = resources(ID)

switch(ID);
    case 'N'
        value = 'Inputs (N)';
    case 'M'
        value = 'Outputs/Classes (M)';
    case 'Nh'
        value = 'Hidden Units (Nh)';
    case 'Nit'
        value = 'Training Iterations (Nit)';
    case 'weights_file'
        value = 'weights.txt';
    case 'TrainTitle'
        value = 'MLP Training Program';
    case 'TestTitle'
        value = 'MLP Testing Program';
    case 'CodeDirectory'
        value = '../hwo_molf_pruning';
    case 'Info'
        value = {'MLP Training Program',
            '',
            'Algorithm: MOLF-ADAPT',
            '', % add details about the algorithm here
            'Author: Rohit Rawat & Jignesh Patel'}; % specify author names here
    
    % Advanced settings: Do not modify unless you know what you are doing!
    case 'DisableValidation'
        value = false;  % leave false. if true, validation file cannot be specified.
    case 'Extra'
        value = '';  % leave empty '', otherwise set to what the Extra input should be called
    case 'ExtraValue'
        value = 1;  % set to what the Extra input should be pre-loaded with
    otherwise
        value = 'Undefined!';
end
