function BST_Pipeline_2_ImportMRI

    % Example of script for Brainstorm software
    % Import anatomy folder from FreeSurfer folder
    % BE CAREFULL !!! AFTER IMPORT, YOU MUST DEFINE FICUCIALS ON MRI FILES
    % Author: Valérie Chanoine, Research Engineer at Brain and Language
    % Research Institute (http://www.blri.fr/)
    % Partners: Jean-Michel Badier and Christian Bénar from 
    % MEG Center of Marseille (Timone Hospital,  France)
    % Date: April 10, 2015


    %%======= FILES TO IMPORT =======
    RawDataDir  = 'F:\blog_CREX\MEG\rawData';
    AnatDir     = fullfile(RawDataDir, 'IRM');
    
    SubjectName = {'NV_001_A1', 'NV_002_A2'};
    
 	%% ===== START BRAINSTORM =====
    if ~brainstorm('status')
        brainstorm nogui
    end
 
    %% ===== START A NEW BRAINSTORM REPORT  ===== 
    bst_report('Start');  
  
    % Loop on subjects
    for ixSub=1:numel(SubjectName) 
    
       %% ===== Process: Import anatomy folder ===== % Process: Import anatomy folder
        sFilesOut = bst_process('CallProcess', 'process_import_anatomy', [], [], ... 
            'subjectname', SubjectName{ixSub}, ... 
            'mrifile',     {AnatDir, 'FreeSurfer'}, ... 
            'nvertices',   15000);   
    
    end
    % Save and display report
    ReportFile = bst_report('Save', sFilesOut);
    bst_report('Open', ReportFile);  
end


  

  
   
