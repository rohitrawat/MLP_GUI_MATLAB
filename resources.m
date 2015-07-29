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
    case 'Info'
        value = {'MLP Training Program',
            '',
            'Algorithm: MOLF-ADAPT',
            'Author: Rohit Rawat & Jignesh Patel'};
    
    % Advanced settings: Do not modify unless you know what you are doing!
    case 'DisableValidation'
        value = false;  % leave false. if true, validation file cannot be specified.
    case 'Extra'
        value = '';  % leave empty '', otherwise set to what the Extra input should be called
end
