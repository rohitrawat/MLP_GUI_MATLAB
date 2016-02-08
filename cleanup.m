temp_files = {};
result_files = {};

for i=1:length(temp_files)
    if(exist(temp_files{i}, 'file'))
        delete(temp_files{i});
    end
end

delete(get(0,'CurrentFigure'));
