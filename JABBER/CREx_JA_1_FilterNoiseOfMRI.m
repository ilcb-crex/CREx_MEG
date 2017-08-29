function CREx_JA_FilterNoiseOfMRI
    % Example of FilterNoise implementation for SPM12
    % Author: Valérie Chanoine, Research Engineer at Institute of Language, Communication and the Brain
    % (http://www.ilcb.fr/)
    % Co-authors from MEG platform:  Samuel Medina, Jean-Michel Badier et
    % Christian Bénar from MEG Center of Marseille (Timone Hospital,  France)
    % Co-authors from UNICOG: Stanislas Dehaene
    % Date: August 1, 2017

    close all; clear all; clc;
    
    % Initialise SPM
    spm('defaults','fmri');  
    spm_jobman('initcfg');
    
    anatDir = 'G:\JABBER\rawData\Patients\IRM\P01\';
    mri_original =fullfile(anatDir, 'P01.nii');
    
    clear matlabbatch;
    matlabbatch{1}.spm.tools.cat.tools.sanlm.data = {mri_original};
    matlabbatch{1}.spm.tools.cat.tools.sanlm.prefix = 'sanlm_';
    matlabbatch{1}.spm.tools.cat.tools.sanlm.NCstr = -Inf;
    matlabbatch{1}.spm.tools.cat.tools.sanlm.rician = 0;
    
    save(fullfile(mri_original, 'JA_SPM12_matlabbatch_T1Filtering.mat'),'matlabbatch'); 
    
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);
end