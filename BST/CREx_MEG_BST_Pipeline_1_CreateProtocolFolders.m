function CREx_MEG_BST_Pipeline_1_CreateProtocolFolders   
% Example of script for Brainstorm software
% 1 - create a protocol and new sujets
% 2 - import 4D MEG Files per Run
% Author: Valérie Chanoine, Research Engineer at Brain and Language
% Institute (http://www.blri.fr/)
% Partners: Jean-Michel Badier and Christian Bénar from 
% MEG Center of Marseille (Timone Hospital,  France)
% Date: April 10, 2015


    %%======= FILES TO IMPORT =======
    RawDataDir  = 'F:\blog_CREX\MEG\rawData';
    AnatDir     = fullfile(RawDataDir, 'IRM');
    DataDir     = fullfile(RawDataDir, 'MEG');
    
    SubjectName = {'NV_001_A1', 'NV_002_A2'};
  

 	%% ===== START BRAINSTORM =====
    if ~brainstorm('status')
        brainstorm nogui
    end
 
    %% ======= CREATE PROTOCOL =======
    % The protocol name has to be a valid folder name (no spaces, no weird characters...)
    ProtocolName = 'Blog_tutorial';

    % Delete existing protocol
    gui_brainstorm('DeleteProtocol', ProtocolName);
    % Create new protocol
    gui_brainstorm('CreateProtocol', ProtocolName, 0, 0);
 
    
    
    % Loop on subjects
    for ixSub=1:numel(SubjectName)

        
        %% ===== CREATE SUBJECT ===== 
        UseDefaultAnat = 0;
        UseDefaultChannel = 0;
        db_add_subject(SubjectName{ixSub}, [], UseDefaultAnat, UseDefaultChannel);


        %% ===== DEFINE MEG RECORDINGS ===== 
        SubNameDir = fullfile(DataDir, SubjectName{ixSub}, 'NV_1');

        RawFiles =  {...
            fullfile(SubNameDir, '1', 'c,rfDC_bp0p3_300_run1'),...
            fullfile(SubNameDir, '2', 'c,rfDC_bp0p3_300_run2'),...
            fullfile(SubNameDir, '3', 'c,rfDC_bp0p3_300_run3'),...
            fullfile(SubNameDir, '4', 'c,rfDC_bp0p3_300_run4'),...
            fullfile(SubNameDir, '5', 'c,rfDC_bp0p3_300_run5'),...
            fullfile(SubNameDir, '6', 'c,rfDC_bp0p3_300_run6')...
            }
        
        
        %% ===== IMPORT MEG RECORDINGS =====    
        % Import options
        ImportOptions = db_template('ImportOptions');
        ImportOptions.ChannelReplace  = 1;
        ImportOptions.ChannelAlign    = 0;
        ImportOptions.DisplayMessages = 0;
        ImportOptions.EventsMode      = 'ask';
        ImportOptions.EventsTrackMode = 'value';      

        OutputFiles = import_raw(RawFiles, '4D', ixSub, ImportOptions);
    end
    
end