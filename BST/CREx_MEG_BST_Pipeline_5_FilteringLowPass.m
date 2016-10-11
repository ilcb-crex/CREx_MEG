function BST_Pipeline_5_FilteringLowPass

    % Example of script for Brainstorm software
    % Filtering low pass of 40 Hz
    % Author: Valérie Chanoine, Research Engineer at Brain and Language
    % Research Institute (http://www.blri.fr/)
    % Partners: Jean-Michel Badier and Christian Bénar from 
    % MEG Center of Marseille (Timone Hospital,  France)
    % Date: April 10, 2015


    %%======= FILES TO IMPORT =======
    SubjectName = {'NV_001_A1', 'NV_002_A2'};
   
    
 	%% ===== START BRAINSTORM =====
    if ~brainstorm('status')
        brainstorm nogui
    end
 
    %% ===== START A NEW BRAINSTORM REPORT  ===== 
    bst_report('Start');  
  
    % Loop on subjects
    for ixSub=1:numel(SubjectName) 
        
     
        %% ===== DEFINE MEG RECORDINGS ===== 

        % Get Raw File
        sFiles = {...
                [ SubjectName{ixSub} '/@rawc_rfDC_bp0p3_300_run1/data_0raw_c,rfDC_bp0p3_300_run1.mat'], ...
                [ SubjectName{ixSub} '/@rawc_rfDC_bp0p3_300_run2/data_0raw_c,rfDC_bp0p3_300_run2.mat'], ...
                [ SubjectName{ixSub} '/@rawc_rfDC_bp0p3_300_run3/data_0raw_c,rfDC_bp0p3_300_run3.mat'], ...
                [ SubjectName{ixSub} '/@rawc_rfDC_bp0p3_300_run4/data_0raw_c,rfDC_bp0p3_300_run4.mat'], ...
                [ SubjectName{ixSub} '/@rawc_rfDC_bp0p3_300_run5/data_0raw_c,rfDC_bp0p3_300_run5.mat'], ...
                [ SubjectName{ixSub} '/@rawc_rfDC_bp0p3_300_run6/data_0raw_c,rfDC_bp0p3_300_run6.mat']};   
               
    
        %% ===== Process: Low-pass: 40 Hz ==== 
        sFilesOut = bst_process('CallProcess', 'process_bandpass', ...
            sFiles, [], ...
            'highpass', 0, ...
            'lowpass', 40, ...
            'mirror', 1, ...
            'sensortypes', 'MEG', ...
            'read_all', 1);
                   
    
    end
    % Save and display report
    ReportFile = bst_report('Save', sFilesOut);
    bst_report('Open', ReportFile);  
end


  

  
   
