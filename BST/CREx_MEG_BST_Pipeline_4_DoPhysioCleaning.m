function BST_Pipeline_4_DoPhysioCleaning

    % Example of script for Brainstorm software
    % Detect eye blinks and heartbeats on all runs do SSP processes
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
               
    
        %% ===== Process: Detect heartbeats ==== 
        sFilesOut = bst_process('CallProcess', 'process_evt_detect_ecg',...
            sFiles, [],...
            'channelname', 'ECG', ...
            'timewindow', [],...
            'eventname', 'cardiac');

        %% ===== Process: Detect eye blinks ==== 
        sFilesOut = bst_process('CallProcess', 'process_evt_detect_eog',...
            sFiles, [], ...
            'channelname', 'VEOG',...
            'timewindow', [],...
            'eventname', 'blink');

        %% ===== Process: SSP ECG: cardiac ==== 
        sFilesOut = bst_process('CallProcess', 'process_ssp2_ecg',...
            sFiles, sFiles,...
            'eventname', 'cardiac',...
            'sensortypes', 'MEG', ...
            'usessp', 1,...
            'select',  1);

        %% ===== Process: SSP EOG: blink ==== 
        sFilesOut = bst_process('CallProcess', 'process_ssp2_eog',...
            sFiles, sFiles,...
            'eventname', 'blink',...
            'sensortypes', 'MEG',...
            'usessp', 1, ...
            'select', 1);  
                 
    end
    % Save and display report
    ReportFile = bst_report('Save', sFilesOut);
    bst_report('Open', ReportFile);  
end


  

  
   
