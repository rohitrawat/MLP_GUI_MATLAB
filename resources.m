function value = resources(ID)

switch(ID);
    case 'N'
        value = 'Inputs (N)';
    case 'M'
        value = 'Outputs/Classes (M)';
    case 'Nh'
        value = 'RBF Size (Nh)';
    case 'Nit'
        value = 'Training Iterations (Nit)';
%     case 'DisableValidation'
%         value = false;
%     case 'Extra'
%         value = '';
end
