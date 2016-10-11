function CREx_MEG_ConvertERFsFromBST2FT
% Script to convert Event-Related Fields (ERFs) data structure from
% Brainstorm to Fieldtrip including only good trials and channels) 
% Note : The current protocol must be the first one in the protocol list of Brainstorm
% Author: Valérie Chanoine, Research Engineer at Brain and Language
% Research Institute (http://www.blri.fr/)
% Date: Oct 11, 2016

    clear all; 
    
    %======================================================================
    % Settings with 'working' structure
    %======================================================================
    
    w.dataDir       = 'F:\db_brainstorm\NV_bp_0p3_300\data';
    w.ProtocolName  = 'NV_bp_0p3_300';
%     w.subjects    	= {'Subject01', 'Subject02'};
%     w.conditions   	= {'Condition1, Condition2'}; 

    w.subjects    	= {'NV_027_M1'};
    w.conditions   	= {'PredNouns_TF'}; 

    w.trialName     = {'TRIGGER__530'};
    w.outputDir     = 'F:\MEG\NV_Project\Output';
  
    %======================================================================
    % Start brainstorm without the GUI
    %======================================================================

    if ~brainstorm('status')
        brainstorm nogui
    end
    
    %======================================================================
    % Get the protocol desired
    %======================================================================   
    iProtocol = bst_get('Protocol', w.ProtocolName);
     
   
    
	% Loop on conditions 
    for iCond=1:numel(w.conditions) 
        % Loop on subjects
        for iSub=1:numel(w.subjects)
           
            %==============================================================
            % Get current subject and condition
            %==============================================================           

             w.sub  = w.subjects{iSub};
             w.cond = w.conditions{iCond};
            
            %==============================================================
            % Define an output folder for fieldtrip data
            %==============================================================           

            ft_output = fullfile(w.outputDir, w.cond, w.sub);
            if ~exist(ft_output, 'dir')
               mkdir(ft_output)
            end  

            cd(w.dataDir);
            
            %==============================================================
            % Get good trials per condition and per subject)
            % Get Channel File
            %==============================================================
              
            [sFiles sChannel]= GetAllTrials(w);

      
            %==============================================================
            % Get indexes of good channels
            %==============================================================
            
            % Get Channel srtucture 
            ChannelMat = in_bst_channel(sChannel.FileName);
            
            % Get indexes of MEG channels
            iChannelsAll = channel_find(ChannelMat.Channel, 'MEG');     

            % Get indexes of good channels among MEG channels
            DataMat    = in_bst_data(sFiles{1}, 'ChannelFlag');       
            iChannelsGood = setdiff(iChannelsAll, find(DataMat.ChannelFlag == -1));    
            %iChannelsBads = setdiff(iChannelsAll, find(DataMat.ChannelFlag == 1));    
      

            %==============================================================
            % Convert brainstorm data structure (all trials) 
            % to a FieldTrip structure (FT_DATATYPE_RAW)
            %==============================================================
            
            ftData = struct([]);
            for i = 1:length(sFiles) 
               
                [DataTrial DataMat ChannelMat] = out_fieldtrip_data(sFiles{i}, sChannel.FileName, iChannelsGood, 0);

                if (isempty(ftData))
                    ftData = DataTrial;
                end

                ftData.trial{1,i}= DataTrial.trial{1};
                ftData.time{1,i}= DataTrial.time{1};
            end  

            %% Save fieldtrip structure   
            save(fullfile(ft_output, 'ftData.mat'), '-struct', 'ftData');         

            fprintf('************************************************************************\n');
            fprintf([w.sub '_' w.cond  ' ...Done\n']);
            fprintf('************************************************************************\n');

        end
    end
end


function [sFiles sChannel] = GetAllTrials(w)
	%======================================================================
    % Get good trials and channel files from Brainstorm
  	%======================================================================  
    
    %% Get all sFiles including bad trials
    [sStudy, iStudy] =  bst_get('StudyWithCondition', [w.sub '/' w.cond ]);
    sFiles = {sStudy.Data.FileName}; 
      
    %% Get channel file
    [sChannel, iChanStudy] = bst_get('ChannelForStudy', iStudy);  
    
    %% Remove average file
    ix = strfind(sFiles, 'average') ;
    sTrials = sFiles(cellfun(@isempty,ix));
    
    %% Get Bad trials
    s = load(fullfile(w.dataDir, sStudy.FileName));
    badTrials = s.BadTrials;

    %% Add full path
    sFiles_badTrials = strcat([w.sub '/' w.cond '/'], badTrials);
 
    %% Remove bad trials from data matrix
    sFiles_badTrials = sFiles_badTrials';                 
    sFiles = setdiff(sTrials, sFiles_badTrials); 
end
