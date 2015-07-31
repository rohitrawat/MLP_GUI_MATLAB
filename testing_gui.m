function testing_gui
% MLP GUI
% Rohit Rawat
% July 28, 2015
% rohitrawat@gmail.com

   testing_file = '';
   weights_file = '';
   lastDir = '';
   
   pre_fill = false;
   if(exist('history.mat', 'file'))
       load('history.mat', 'testing_file', 'weights_file', 'lastDir', 'file_type');
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
   vTotalHeight = 275;
   
   %  Create and then hide the GUI as it is being constructed.
   f = figure('Visible','off','Position',[10,10,hTotalWidth,vTotalHeight],'Name',resources('TestTitle'),'NumberTitle','off','Menubar','none','Color',[0.8 0.8 0.8]);
   
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
   [htextTstFile tr bl] = makeControl(tl, labelWidths, 'text', 'Testing File');
   [heditTstFile tr bl] = makeControl(tr, 3*labelWidths, 'edit', '');
   [hbuttonBrowseTstFile tr bl] = makeControl(tr, buttonWidths, 'pushbutton', 'Select File..', @browse_Callback);
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextWtsFile tr bl] = makeControl(tl, labelWidths, 'text', 'Weights File');
   [heditWtsFile tr bl] = makeControl(tr, 3*labelWidths, 'edit', '');
   [hbuttonBrowseWtsFile tr bl] = makeControl(tr, buttonWidths, 'pushbutton', 'Select File..', @browse_Callback);
   
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
   [hcheckHasOutputs tr bl] = makeControl(tl, round(labelWidths*1.5), 'checkbox', 'Desired Outputs Present', @hasOutputs_Callback);
   [hcheckSaveOutputs tr bl] = makeControl(tr, round(labelWidths*1.5), 'checkbox', 'Save Processing Results');
   set(hcheckHasOutputs, 'Value', true);
   set(hcheckSaveOutputs, 'Value', true);

   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [hbuttonTest tr bl] = makeControl(tl, buttonWidths, 'pushbutton', 'Run Test', @test_Callback);
   [htextStatus1 tr bl] = makeControl(tr, round(labelWidths/2), 'text', 'Status:');
   [htextStatus tr bl] = makeControl(tr, labelWidths, 'text', 'Ready.');
   set(htextStatus, 'HorizontalAlignment', 'left');
   set(hbuttonTest, 'FontWeight', 'bold');
   
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextTstErr tr bl] = makeControl(tl, labelWidths, 'text', 'Testing Error');
   [heditTstErr tr bl] = makeControl(tr, labelWidths, 'edit', '');
   set(heditTstErr, 'Enable', 'off');

   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [hbuttonHelp tr bl] = makeControl(tl, buttonWidths, 'pushbutton', 'Help', @help_Callback);
   [hbuttonHelp tr bl] = makeControl(tr, buttonWidths, 'pushbutton', 'About', @about_Callback);

   if(pre_fill)
       set(heditTstFile, 'String', testing_file);
       set(heditWtsFile, 'String', weights_file);
       if(file_type == 1)
           set(hradioTypeReg, 'Value', 1);
           set(hradioTypeCls, 'Value', 0);
       else
           set(hradioTypeReg, 'Value', 0);
           set(hradioTypeCls, 'Value', 1);
       end
       hasOutputs_Callback();
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
         case hbuttonBrowseTstFile
            dtitle = 'Select testing file..';
         case hbuttonBrowseWtsFile
            dtitle = 'Select weights file..';
         end
         [FileName,PathName] = uigetfile(fullfile(lastDir,'*.*'), dtitle); %lastDir
         if(FileName==0)
             return;
         end
         lastDir = PathName;
         filename = fullfile(PathName,FileName);
         switch source;
         case hbuttonBrowseTstFile
            testing_file = filename;
            set(heditTstFile, 'String', filename);
         case hbuttonBrowseWtsFile
            weights_file = filename;
            set(heditWtsFile, 'String', filename);
         end
      end
  
    function hasOutputs_Callback(source,eventdata)
        hasOutputs = get(hcheckHasOutputs, 'Value');
        if(hasOutputs)
            set(hcheckSaveOutputs, 'Enable', 'on');
        else
            set(hcheckSaveOutputs, 'Value', true);
            set(hcheckSaveOutputs, 'Enable', 'off');
        end
    end
  
   % Train button callback.
 
   function test_Callback(source,eventdata) 
        testing_file = get(heditTstFile, 'String');
        if(exist(testing_file, 'file') == 0)
            msgbox(sprintf('Testing file does not exist:\n%s', testing_file));
            return;
        end
        
        weights_file = get(heditWtsFile, 'String');
        if(exist(weights_file, 'file') == 0)
            msgbox(sprintf('Weights file does not exist:\n%s', weights_file));
            return;
        end

        desired_outputs_present = get(hcheckHasOutputs, 'Value');
        write_processing_results = get(hcheckSaveOutputs, 'Value');
        
        file_type = get(hradioTypeReg, 'Value');

        save('history.mat', '-append', 'testing_file');
        
        if(file_type == 1)
            set(htextTstErr, 'String', 'Testing Error (MSE)');
        else
            set(htextTstErr, 'String', 'Testing Error (% error)');
        end
        
%         old_path = path;
%         addpath(fullfile('..','hwo_molf_pruning'));
        set(htextStatus, 'String', 'Working...');
        drawnow;
        try
            [E_test] = testing_program_interface(testing_file, weights_file, desired_outputs_present, write_processing_results, file_type);
            set(htextStatus, 'String', 'Ready.');
            if(desired_outputs_present)
                set(heditTstErr, 'String', num2str(E_test));
            else
                set(heditTstErr, 'String', 'NA');
            end
            set(hbuttonTest,  'Visible', 'on');
        catch err
            % Display any other errors as usual.            
            set(htextStatus, 'String', 'Error! See console.');
            set(heditTstErr, 'String', 'failed');
%             path(old_path);
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

   function about_Callback(source,eventdata)
       message = [{'Image Processing and Neural Networks Lab'; 'The University of Texas at Arlington'; ''}; resources('Info'); {''; 'GUI Author: Rohit Rawat'}];
       msgbox(message);
   end

 
end
