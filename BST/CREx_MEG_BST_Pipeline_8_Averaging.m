function BST_Pipeline_8_Averaging

    % Example of script for Brainstorm software
    % Averaging
    % Author: Valérie Chanoine, Research Engineer at Brain and Language
    % Research Institute (http://www.blri.fr/)
    % Partners: Jean-Michel Badier and Christian Bénar from 
    % MEG Center of Marseille (Timone Hospital,  France)
    % Date: April 12, 2015


    %%======= DEFINE PARAMETERS =======
    sFiles_data = {};
 
    DatabaseDir     = fullfile('C:\Users\chanoine\BLRI\brainstorm_db\Blog_tutorial\data');    
    SubjectName = {'NV_002_A2'};
    %SubjectName = {'NV_001_A1','NV_002_A2'};
    EventName   = { 'TRIGGER__530', 'TRIGGER__514'};  

    
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
        sFiles = {sStudy.Data.FileName};

        % Get bad trials 
        s = load(fullfile(DatabaseDir, sStudy.FileName)); 
        badTrials = s.BadTrials;

        % Add full path 
        sFiles_badTrials = strcat([SubjectName{ixSub} '/' EventName{iEvent} '/'], badTrials);

        % Remove bad trials from data matrix 
        sFiles_badTrials=sFiles_badTrials'; 
        sFiles_data{iEvent} = setdiff(sFiles,sFiles_badTrials);

        % Process: Average: By condition (subject average)
        sFilesOut = bst_process('CallProcess', 'process_average', ... 
            sFiles_data{iEvent}, [], ... 
            'avgtype', 3, ... 
            'avg_func', 1, ...  % Arithmetic average: mean(x) 
            'keepevents', 0);
        end

    end
    % Save and display report
    ReportFile = bst_report('Save', sFilesOut);
    bst_report('Open', ReportFile);  
end


  

  
   
