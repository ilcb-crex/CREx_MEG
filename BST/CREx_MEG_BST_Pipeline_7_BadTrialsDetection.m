function BST_Pipeline_7_BadTrialsDetection

    % Example of script for Brainstorm software
    % Detection of Bad trials using peak-to-peak amplitude threshold
    % Author: Valérie Chanoine, Research Engineer at Brain and Language
    % Research Institute (http://www.blri.fr/)
    % Partners: Jean-Michel Badier and Christian Bénar from 
    % MEG Center of Marseille (Timone Hospital,  France)
    % Date: April 12, 2015


    %%======= DEFINE PARAMETERS =======
    SubjectName = {'NV_001_A1', 'NV_002_A2'};
    EventName   = { 'TRIGGER__530', 'TRIGGER__514'};  
    sFiles_data = {};
    MEGGRAD     = 3000;
    
    
 	%% ===== START BRAINSTORM =====
    if ~brainstorm('status')
        brainstorm nogui
    end
 
    %% ===== START A NEW BRAINSTORM REPORT  ===== 
    bst_report('Start');  
     
    % Loop on subjects
    for ixSub=1:numel(SubjectName) 
        
     % Loop on events    
        for iEvent=1:numel(EventName)

        % Get all data files per event 
        sStudy =  bst_get('StudyWithCondition', [SubjectName{ixSub} '/' EventName{iEvent} ]); 
        sFiles_data = {sStudy.Data.FileName};

        % Process: Detect bad trials: Peak-to-peak  MEGGRAD(0-3000)
        sFilesOut = bst_process('CallProcess', 'process_detectbad', ...
            sFiles_data, [], ...
            'timewindow', [], ...
            'meggrad', [0, MEGGRAD], ...
            'megmag', [0, 0], ...
            'eeg', [0, 0], ...
            'eog', [0, 0], ...
            'ecg', [0, 0], ...
            'rejectmode', 2);  % Reject the entire trial

        end

    end
    % Save and display report
    ReportFile = bst_report('Save', sFilesOut);
    bst_report('Open', ReportFile);  
end


  

  
   
