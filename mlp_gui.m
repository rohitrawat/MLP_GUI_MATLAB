function mlp_gui
% MLP GUI
% Rohit Rawat
% July 28, 2015
% rohitrawat@gmail.com

   training_file = '';
   validation_file = '';
   testing_file = '';
   weights_file = '';
   lastDir = '';
   
   pre_fill = false;
   if(exist('history.mat', 'file'))
       load('history.mat');
       pre_fill = true;
   else
       lastDir = pwd;
   end
 
   vOrigin = 15;
   vHeight = 25;
   vGap = 10;
   hOrigin = 10;
   hGap = 10;
   hTotalWidth = 800;
   vTotalHeight = 475;
   
   %  Create and then hide the GUI as it is being constructed.
   f = figure('Visible','off','Position',[10,10,hTotalWidth,vTotalHeight],'Name',resources('TrainTitle'),'NumberTitle','off','Menubar','none','Color',[0.8 0.8 0.8]);
   
   labelWidths = 150;
   buttonWidths = 150;
   
    function [h tr bl] = makeControl(tl, sz, style, string, callback)
        if(nargin < 5)
            callback = [];
        end
        if(numel(sz)==1)
            sz = [sz vHeight];
        end
        if(strcmpi(style, 'edit'))
            color = [1 1 1];
        else
            color = [0.8 0.8 0.8];
        end
        h = uicontrol('Style',style,'String',string,...
          'Position',[tl(1),vTotalHeight-tl(2)-sz(2),sz(1),sz(2)],...
          'Callback',callback,'BackgroundColor',color);
        tr = tl+[sz(1)+hGap 0];
        bl = tl+[0 sz(2)+vGap];
    end
   
   row = 1;
   tl = [hOrigin vOrigin+(row-1)*vHeight];
   [htextTrgFile tr bl] = makeControl(tl, labelWidths, 'text', 'Training File');
   [heditTrgFile tr bl] = makeControl(tr, 3*labelWidths, 'edit', '');
   [hbuttonBrowseTrgFile tr bl] = makeControl(tr, buttonWidths, 'pushbutton', 'Select File..', @browse_Callback);
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [hcheckValFile tr bl] = makeControl(tl, round(labelWidths), 'checkbox', 'Use Validation File', @valfileOn_Callback);
   [heditValFile tr bl] = makeControl(tr, 3*labelWidths, 'edit', '');
   [hbuttonBrowseValFile tr bl] = makeControl(tr, buttonWidths, 'pushbutton', 'Select File..', @browse_Callback);
   set(hcheckValFile, 'Value', 1);
   
   if(resources('DisableValidation'))
       set(hcheckValFile,  'Visible', 'off');
       set(heditValFile,  'Visible', 'off');
       set(hbuttonBrowseValFile,  'Visible', 'off');
       valfileOn = false;
       validation_file = '';
       set(hcheckValFile, 'Value', 0);
       set(heditValFile,  'String', '');
   end
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextType tr bl] = makeControl(tl, labelWidths, 'text', 'File Type');
%    bg = uibuttongroup('Visible', 'off', 'Units', 'pixels', 'Position',[[tr(1) vTotalHeight-tr(2)] 3*labelWidths vHeight*2]);
   bg = uibuttongroup('Visible', 'off', 'Units', 'pixels', 'Position',[0 0 1 1]); % did not work at correct locations
   [hradioTypeReg tr bl] = makeControl(tr, labelWidths, 'radiobutton', 'Regression');
   [hradioTypeCls tr bl] = makeControl(tr, buttonWidths, 'radiobutton', 'Classification');
   set(hradioTypeReg, 'parent', bg);
   set(hradioTypeReg, 'Value', 1);
   set(hradioTypeCls, 'parent', bg);
   set(bg, 'Visible', 'on');
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextInputs tr bl] = makeControl(tl, labelWidths, 'text', resources('N'));
   [heditInputs tr bl] = makeControl(tr, labelWidths, 'edit', '');
 
   message = [{'Image Processing and Neural Networks Lab'; ''}; resources('Info'); {''; 'GUI Author: Rohit Rawat'}];
   [htextInfo tr bl] = makeControl(tr+[50 30], [350 200], 'text', message);

   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextOutputs tr bl] = makeControl(tl, labelWidths, 'text', resources('M'));
   [heditOutputs tr bl] = makeControl(tr, labelWidths, 'edit', '');
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextNh tr bl] = makeControl(tl, labelWidths, 'text', resources('Nh'));
   [heditNh tr bl] = makeControl(tr, labelWidths, 'edit', '');
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextNit tr bl] = makeControl(tl, labelWidths, 'text', resources('Nit'));
   [heditNit tr bl] = makeControl(tr, labelWidths, 'edit', '');
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextExtra tr bl] = makeControl(tl, labelWidths, 'text', resources('Extra'));
   [heditExtra tr bl] = makeControl(tr, labelWidths, 'edit', '0');
   if(length(resources('Extra'))==0)
       set(htextExtra,  'Visible', 'off');
       set(heditExtra,  'Visible', 'off');
   end
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [hbuttonTrain tr bl] = makeControl(tl, buttonWidths, 'pushbutton', 'Train', @train_Callback);
   [htextStatus1 tr bl] = makeControl(tr, round(labelWidths/2), 'text', 'Status:');
   [htextStatus tr bl] = makeControl(tr, labelWidths, 'text', 'Ready.');
   set(htextStatus, 'HorizontalAlignment', 'left');
   
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [hbuttonTest tr bl] = makeControl(tl, buttonWidths, 'pushbutton', 'Open Testing Program', @test_Callback);
   set(hbuttonTest,  'Visible', 'off');
   
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextTrgErr tr bl] = makeControl(tl, labelWidths, 'text', 'Training Error');
   [heditTrgErr tr bl] = makeControl(tr, labelWidths, 'edit', '');
   set(heditTrgErr, 'Enable', 'off');
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextValErr tr bl] = makeControl(tl, labelWidths, 'text', 'Validation Error');
   [heditValErr tr bl] = makeControl(tr, labelWidths, 'edit', '');
   set(heditValErr, 'Enable', 'off');
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [hbuttonHelp tr bl] = makeControl(tl, buttonWidths, 'pushbutton', 'Help', @help_Callback);

   if(pre_fill)
       set(heditTrgFile, 'String', training_file);
       set(heditValFile, 'String', validation_file);
       if(file_type == 1)
           set(hradioTypeReg, 'Value', 1);
           set(hradioTypeCls, 'Value', 0);
       else
           set(hradioTypeReg, 'Value', 0);
           set(hradioTypeCls, 'Value', 1);
       end
       
       set(heditInputs, 'String', num2str(N));
       set(heditOutputs, 'String', num2str(M));
       set(heditNh, 'String', num2str(Nh));
       set(heditNit, 'String', num2str(Nit));
       set(hcheckValFile, 'Value', valfileOn);
       valfileOn_Callback();
   end
 
%    ha = axes('Units','Pixels','Position',[50,60,200,185]); 
%    align([hsurf,hmesh,hcontour,htext,hpopup],'Center','None');
   
   % Initialize the GUI.
   % Change units to normalized so components resize 
   % automatically.
%    set([f,ha,hsurf,hmesh,hcontour,htext,hpopup],...
%    'Units','normalized');
   % Move the GUI to the center of the screen.
   movegui(f,'center')
   % Make the GUI visible.
   set(f,'Visible','on');
 
   %  Callbacks for simple_gui. These callbacks automatically
   %  have access to component handles and initialized data 
   %  because they are nested at a lower level.
 
   %  Browse button callback.
      function browse_Callback(source,eventdata) 
         % Determine the browse button
         switch source;
         case hbuttonBrowseTrgFile
            dtitle = 'Select training file..';
         case hbuttonBrowseValFile
            dtitle = 'Select validation file..';
         end
         [FileName,PathName] = uigetfile(fullfile(lastDir,'*.*'), dtitle); %lastDir
         if(FileName==0)
             return;
         end
         lastDir = PathName;
         filename = fullfile(PathName,FileName);
         switch source;
         case hbuttonBrowseTrgFile
            training_file = filename;
            set(heditTrgFile, 'String', filename);
         case hbuttonBrowseValFile
            validation_file = filename;
            set(heditValFile, 'String', filename);
         end
      end
  
    function valfileOn_Callback(source,eventdata)
        valfileOn = get(hcheckValFile, 'Value');
        if(valfileOn)
            set(heditValFile, 'Visible', 'on');
            set(hbuttonBrowseValFile, 'Visible', 'on');
        else
            set(heditValFile, 'Visible', 'off');
            set(hbuttonBrowseValFile, 'Visible', 'off');
        end
    end
  
   % Train button callback.
 
   function train_Callback(source,eventdata) 
        training_file = get(heditTrgFile, 'String');
        if(exist(training_file, 'file') == 0)
            msgbox(sprintf('Training file does not exist:\n%s', training_file));
            return;
        end
        
        valfileOn = get(hcheckValFile, 'Value');
        if(valfileOn)
            validation_file = get(heditValFile, 'String');
            if(exist(validation_file, 'file') == 0)
                msgbox(sprintf('Validation file does not exist:\n%s', validation_file));
                return;
            end
        else
            validation_file = '';
        end
        
        file_type = get(hradioTypeReg, 'Value');
        strN = get(heditInputs, 'String');
        N = str2double(strN);
        if(isnan(N) || N<1 || N>10000)
            msgbox(sprintf('N is invalid:\n%d', N));
            return;
        end
        strM = get(heditOutputs, 'String');
        M = str2double(strM);
        if(isnan(M) || M<1 || M>10000)
            msgbox(sprintf('M is invalid:\n%d', M));
            return;
        end
        strNh = get(heditNh, 'String');
        Nh = str2double(strNh);
        if(isnan(Nh) || Nh<1 || Nh>10000)
            msgbox(sprintf('Nh is invalid:\n%d', Nh));
            return;
        end
        strNit = get(heditNit, 'String');
        Nit = str2double(strNit);
        if(isnan(Nit) || Nit<1 || Nit>10000)
            msgbox(sprintf('Nit is invalid:\n%d', Nit));
            return;
        end
        strExtra = get(heditExtra, 'String');
        Extra = str2double(strExtra);
        if(isnan(Extra))
            msgbox(sprintf('%s is invalid:\n%d', resources('Extra'), Extra));
            return;
        end
        
        weights_file = resources('weights_file');

        save('history.mat', 'training_file', 'N', 'M', 'Nh', 'Nit', 'validation_file', 'lastDir', 'file_type', 'valfileOn', 'testing_file', 'weights_file');
        
        if(file_type == 1)
            set(htextTrgErr, 'String', 'Training Error (MSE)');
            set(htextValErr, 'String', 'Validation Error (MSE)');
        else
            set(htextTrgErr, 'String', 'Training Error (% error)');
            set(htextValErr, 'String', 'Validation Error (% error)');
        end
        
        old_path = path;
        addpath(fullfile('..','hwo_molf_pruning'));
        set(htextStatus, 'String', 'Working...');
        drawnow;
        try
            [E_t_best E_v_best] = training_program_interface(training_file, N, M, Nh, Nit, validation_file, file_type, Extra);
            set(htextStatus, 'String', 'Ready.');
            set(heditTrgErr, 'String', num2str(E_t_best));
            set(heditValErr, 'String', num2str(E_v_best));
            set(hbuttonTest,  'Visible', 'on');
        catch err
            % Display any other errors as usual.            
            set(htextStatus, 'String', 'Error! See console.');
            set(heditTrgErr, 'String', 'failed');
            set(heditValErr, 'String', 'failed');
            path(old_path);
            disp(err);
            disp(err.message);
            for i=1:length(err.stack)
                fprintf('In %s, function: %s, line %d\n', err.stack(i).file, err.stack(i).name, err.stack(i).line);
            end
            disp(err.identifier);
            if(strcmp(err.stack(1).name, 'read_approx_file') || strcmp(err.stack(1).name, 'read_class_file'))
                msgbox('There was a problem reading in the file. Check that you specified the correct number of inputs and outputs, selected the correct file type, and the file uses space delimiters only. See the console for details.');
            else
                msgbox('There was a problem. See the console for details.');
            end
        end
   end

   function test_Callback(source,eventdata)
       testing_gui();
   end

   function help_Callback(source,eventdata)
       if(exist(fullfile(pwd,'README.HTML'), 'file'))
           open('README.HTML');
       elseif(exist(fullfile(pwd,'README.MD'), 'file'))
           edit('README.MD');
       elseif(exist(fullfile(pwd,'README.TXT'), 'file'))
           edit('README.TXT');
       else
           msgbox('Readme not found.');
       end
   end

 
end
