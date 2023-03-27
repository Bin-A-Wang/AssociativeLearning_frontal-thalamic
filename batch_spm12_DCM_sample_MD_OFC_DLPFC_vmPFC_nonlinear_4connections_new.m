
Subjects=[1 2 4 6 9 10 12 15 16 17 18 19 20 21 22 23 24 25 26 28 29 30 31 32 33 35 36 37];
%%Subjects=[2 4 6 9 10 12 15 16 18 19 20 22 23 24 26 29 30 31 35 36];%subjects with 0.05 threshold
RootDir=['D:\Bochum\DATA\fMRI_Match2sample\Data_thalamocortical\'];
analysis_dir='Results_st_keepandchange_mu2hat_New';
VOIradius_global= 8;
VOIradius_local = 4;
VOIname={'rMD','rOFC','rDLPFC','vmPFC'};
VOIxyz={[12 -10 8],[28 56 -6],[42 40 28],[-4 60 10]};  %rMD:[10,-22,12] keep&change, [12 -10 8] change vs.keep; rOFC: Change vs. keep; vmPFC: change_mu2hat;

% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
%spm_get_defaults('cmdline',1);

for n = 1:length(Subjects)
    fprintf('Working on participant %d\n',Subjects(n));
    
    inputpath= fullfile(RootDir, sprintf('Sub%02d',Subjects(n)),analysis_dir);
    
    outputpath=fullfile(RootDir, sprintf('Sub%02d',Subjects(n)),'DCM_nonlinear_rMD_rOFC_rDLPFC_vmPFC_4connections_New');
    mkdir(outputpath)
    
%     clear matlabbatch
%     
%     % EXTRACTING TIME SERIES rMD:
%     %--------------------------------------------------------------------------
%     matlabbatch{1}.spm.util.voi.spmmat = cellstr(fullfile(inputpath,'SPM.mat'));
%     matlabbatch{1}.spm.util.voi.adjust = 7;  % Effects of interest contrast (F-contrast) number
%     matlabbatch{1}.spm.util.voi.session = 1; %
%     matlabbatch{1}.spm.util.voi.name = VOIname{1};
%     
%     % Define thresholded SPM for finding the subject's local peak response
%     matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
%     matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = 5;  % Change>Keep
%     matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
%     matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 1;
%     matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
%     
%     % Define large fixed outer sphere to fine the peak
%     matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre = VOIxyz{1};
%     matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius = VOIradius_global;
%     matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
%     
%     % Define smaller inner sphere which jumps to the peak of the outer sphere
%     matlabbatch{1}.spm.util.voi.roi{3}.sphere.centre           = [0 0 0]; % Leave this at zero
%     matlabbatch{1}.spm.util.voi.roi{3}.sphere.radius           = VOIradius_local;       % Set radius here (mm)
%     matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.spm  = 1;       % Index of SPM within the batch
%     matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';    % Index of the outer sphere within the batch
%     
%     % Include voxels in the thresholded SPM (i1) and the mobile inner sphere (i3)
%     matlabbatch{1}.spm.util.voi.expression = 'i1 & i3';
%     
%     % EXTRACTING TIME SERIES rOFC:
%     %--------------------------------------------------------------------------
%     matlabbatch{2}.spm.util.voi.spmmat = cellstr(fullfile(inputpath,'SPM.mat'));
%     matlabbatch{2}.spm.util.voi.adjust = 7;  % Effects of interest contrast (F-contrast) number
%     matlabbatch{2}.spm.util.voi.session = 1; %
%     matlabbatch{2}.spm.util.voi.name = VOIname{2};
%     
%     % Define thresholded SPM for finding the subject's local peak response
%     matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
%     matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = 5;  % Change>Keep
%     matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
%     matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = 1;
%     matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 0;
%     
%     % Define large fixed outer sphere to fine the peak
%     matlabbatch{2}.spm.util.voi.roi{2}.sphere.centre = VOIxyz{2};
%     matlabbatch{2}.spm.util.voi.roi{2}.sphere.radius = VOIradius_global;
%     matlabbatch{2}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
%     
%     % Define smaller inner sphere which jumps to the peak of the outer sphere
%     matlabbatch{2}.spm.util.voi.roi{3}.sphere.centre           = [0 0 0]; % Leave this at zero
%     matlabbatch{2}.spm.util.voi.roi{3}.sphere.radius           = VOIradius_local;       % Set radius here (mm)
%     matlabbatch{2}.spm.util.voi.roi{3}.sphere.move.global.spm  = 1;       % Index of SPM within the batch
%     matlabbatch{2}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';    % Index of the outer sphere within the batch
%     
%     % Include voxels in the thresholded SPM (i1) and the mobile inner sphere (i3)
%     matlabbatch{2}.spm.util.voi.expression = 'i1 & i3';
%     
%     
%     % EXTRACTING TIME SERIES: vmPFC
%     %--------------------------------------------------------------------------
%     matlabbatch{3}.spm.util.voi.spmmat = cellstr(fullfile(inputpath,'SPM.mat'));
%     matlabbatch{3}.spm.util.voi.adjust = 7;  % Effects of interest contrast (F-contrast) number
%     matlabbatch{3}.spm.util.voi.session = 1; %
%     matlabbatch{3}.spm.util.voi.name = VOIname{3};
%     
%     % Define thresholded SPM for finding the subject's local peak response
%     matlabbatch{3}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
%     matlabbatch{3}.spm.util.voi.roi{1}.spm.contrast = 4;  % change_mu2hat
%     matlabbatch{3}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
%     matlabbatch{3}.spm.util.voi.roi{1}.spm.thresh = 1;
%     matlabbatch{3}.spm.util.voi.roi{1}.spm.extent = 0;
%     
%     % Define large fixed outer sphere to fine the peak
%     matlabbatch{3}.spm.util.voi.roi{2}.sphere.centre = VOIxyz{3};
%     matlabbatch{3}.spm.util.voi.roi{2}.sphere.radius = VOIradius_global;
%     matlabbatch{3}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
%     
%     % Define smaller inner sphere which jumps to the peak of the outer sphere
%     matlabbatch{3}.spm.util.voi.roi{3}.sphere.centre           = [0 0 0]; % Leave this at zero
%     matlabbatch{3}.spm.util.voi.roi{3}.sphere.radius           = VOIradius_local;       % Set radius here (mm)
%     matlabbatch{3}.spm.util.voi.roi{3}.sphere.move.global.spm  = 1;       % Index of SPM within the batch
%     matlabbatch{3}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';    % Index of the outer sphere within the batch
%     
%     % Include voxels in the thresholded SPM (i1) and the mobile inner sphere (i3)
%     matlabbatch{3}.spm.util.voi.expression = 'i1 & i3';
%     
%     
%     spm_jobman('run',matlabbatch);
%     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DYNAMIC CAUSAL MODELLING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    clear DCM
    
    % SPECIFICATION DCMs "attentional modulation of backward/forward connection"
    %--------------------------------------------------------------------------
    % To specify a DCM, you might want to create a template one using the GUI
    % then use spm_dcm_U.m and spm_dcm_voi.m to insert new inputs and new
    % regions. The following code creates a DCM file from scratch, which
    % involves some technical subtleties and a deeper knowledge of the DCM
    % structure.
    
    load(fullfile(inputpath,'SPM.mat'));
    
    % Load regions of interest
    %--------------------------------------------------------------------------
    for i=1:length(VOIname)
        
        load(fullfile(inputpath,['VOI_',VOIname{i},'_1.mat']),'xY');
        DCM.xY(i) = xY;

    end
    DCM.n = length(DCM.xY);      % number of regions
    DCM.v = length(DCM.xY(1).u); % number of time points
    
    % Time series
    %--------------------------------------------------------------------------
    DCM.Y.dt  = SPM.xY.RT;
    DCM.Y.X0  = DCM.xY(1).X0;
    for i = 1:DCM.n
        DCM.Y.y(:,i)  = DCM.xY(i).u;
        DCM.Y.name{i} = DCM.xY(i).name;
    end
    
    DCM.Y.Q    = spm_Ce(ones(1,DCM.n)*DCM.v);
    
    % Experimental inputs
    %--------------------------------------------------------------------------
    DCM.U.dt   =  SPM.Sess(1).U(1).dt;
    DCM.U.name = [SPM.Sess(1).U(1).name(1) SPM.Sess(1).U(1).name(2) SPM.Sess(1).U(2).name(1) SPM.Sess(1).U(2).name(2)];
    DCM.U.u    = [SPM.Sess.U(1).u(33:end,1) ...       % Keep
                  SPM.Sess.U(1).u(33:end,2) ...       % keep x mu2hat effect
                  SPM.Sess.U(2).u(33:end,1) ...       % change      
                  SPM.Sess.U(2).u(33:end,2)];         % change x mu2hat effect
 
    % DCM parameters and options
    %--------------------------------------------------------------------------
    DCM.delays = repmat(SPM.xY.RT/2,DCM.n,1);
    DCM.TE     = 0.04;
    
    DCM.options.nonlinear  = 1;
    DCM.options.two_state  = 0;
    DCM.options.stochastic = 0;
    DCM.options.nograph    = 1;
    
    % Connectivity matrices for model with backward modulation
    %--------------------------------------------------------------------------
    DCM.a = [0 1 1 0; 1 1 1 0; 1 1 1 0; 0 0 0 1]; % endogenous connections  n_node x n_node
    DCM.b = zeros(4,4,4);    % Bilinear: n_node x n_node x n_conditions
    DCM.c = [0 0 0 0; 0 0 0 0;1 0 1 0;0 1 0 1];% driving input to a node: n_node x n_conditions
   
    %model 1: 
    DCM.d = zeros(4,4,4);   %nonlinear modulation: n_node x n_node x n_cnode
    DCM.d(1,3,4) =1;       %  dlPFC->MD 
    save(fullfile(outputpath,'DCM_mod01_nonlinear.mat'),'DCM');
    
    %model 2: 
    DCM.d = zeros(4,4,4);   %nonlinear modulation: n_node x n_node x n_cnode
    DCM.d(3,1,4) =1;       %  MD->dlPFC     
    save(fullfile(outputpath,'DCM_mod02_nonlinear.mat'),'DCM'); 
    
    %model 3: 
    DCM.d = zeros(4,4,4);   
    DCM.d(2,3,4) =1;      %  dlPFC->OFC 
    save(fullfile(outputpath,'DCM_mod03_nonlinear.mat'),'DCM');       
    
    %model 4: 
    DCM.d = zeros(4,4,4);     
    DCM.d(1,2,4) =1;     %  OFC->MD
    save(fullfile(outputpath,'DCM_mod04_nonlinear.mat'),'DCM');
    

    %model 5: 
    DCM.d = zeros(4,4,4);   %nonlinear modulation: n_node x n_node x n_cnode
    DCM.d(1,3,4) =1;       %  dlPFC->MD 
    DCM.d(3,1,4) =1;       %  MD->dlPFC     
    save(fullfile(outputpath,'DCM_mod05_nonlinear.mat'),'DCM');
    
    %model 6:
    DCM.d = zeros(4,4,4); 
    DCM.d(2,3,4) =1;       %  dlPFC->OFC
    DCM.d(1,2,4) =1;       %  OFC->MD 
    save(fullfile(outputpath,'DCM_mod06_nonlinear.mat'),'DCM');
    
    %model 7: 
    DCM.d = zeros(4,4,4);   
    DCM.d(2,3,4) =1;      %  dlPFC->OFC 
    DCM.d(1,3,4) =1;      %  dlPFC->MD  
    save(fullfile(outputpath,'DCM_mod07_nonlinear.mat'),'DCM');    
    
    %model 8: 
    DCM.d = zeros(4,4,4);     
    DCM.d(1,2,4) =1;     %  OFC->MD
    DCM.d(3,1,4) =1;     %  MD->dlPFC
    save(fullfile(outputpath,'DCM_mod08_nonlinear.mat'),'DCM');
    
    %model 9:
    DCM.d = zeros(4,4,4);  
    DCM.d(3,1,4) =1;        % MD->dlPFC
    DCM.d(2,3,4) =1;        % dlPFC->OFC
    save(fullfile(outputpath,'DCM_mod09_nonlinear.mat'),'DCM');
    
    %model 10:
    DCM.d = zeros(4,4,4);
    DCM.d(1,3,4) =1;        % dlPFC->MD
    DCM.d(1,2,4) =1;        % OFC->MD
    save(fullfile(outputpath,'DCM_mod10_nonlinear.mat'),'DCM');
    
      
   
    
    % DCM Estimation
    %--------------------------------------------------------------------------
    clear matlabbatch
    
    
    matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
        fullfile(outputpath,'DCM_mod01_nonlinear.mat');...
        fullfile(outputpath,'DCM_mod02_nonlinear.mat');...
        fullfile(outputpath,'DCM_mod03_nonlinear.mat');...
        fullfile(outputpath,'DCM_mod04_nonlinear.mat');...
        fullfile(outputpath,'DCM_mod05_nonlinear.mat');...
        fullfile(outputpath,'DCM_mod06_nonlinear.mat');...
        fullfile(outputpath,'DCM_mod07_nonlinear.mat');...
        fullfile(outputpath,'DCM_mod08_nonlinear.mat');...
        fullfile(outputpath,'DCM_mod09_nonlinear.mat');...
        fullfile(outputpath,'DCM_mod10_nonlinear.mat')};
    
    
    spm_jobman('run',matlabbatch);
    
    % Bayesian Model Comparison
    %--------------------------------------------------------------------------
%     DCM_1 = load('DCM_mod1_test.mat','F');
%     DCM_2 = load('DCM_mod2_test.mat','F');
%     fprintf('Model evidence: %f (mod1) vs %f (mod2)\n',DCM_1.F,DCM_2.F);
end
