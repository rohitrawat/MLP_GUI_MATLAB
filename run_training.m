function run_training()

p = fileparts(mfilename('fullpath'));
cd(p);

addpath(fullfile(pwd,'hwo_molf_pruning'));

required_modules = {'training_gui', 'testing_gui', 'resources', 'training_program_interface', 'testing_program_interface'};
for f=1:length(required_modules)
    if(~exist(fullfile(pwd, [required_modules{f} '.m']), 'file') && ~exist(fullfile(pwd, [required_modules{f} '.p']), 'file'))
        message = {['Missing module ' required_modules{f}]; 
            'Please ensure that you unzipped all the files in the archive';
            'The current folder is:';
            pwd;
            'Please change the current folder to where all the files exist.'};
        disp(message);
        msgbox(message);
        return;
    end
end

addpath(fullfile(pwd,resources('CodeDirectory')));

training_gui();
