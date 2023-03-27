

Subjects=[1 2 4 6 9 10 12 15 16 17 18 19 20 21 22 23 24 25 26 28 29 30 31 32 33 35 36 37];%Subjects=[1 2 4 6 9 10 12 15 16 17 18 19 20 21 22 23 24 25 26 28 29 30 31 32 33]
%%Subjects=[2 4 6 9 10 12 15 16 18 19 20 22 23 24 26 29 30 31 35 36];%subjects with 0.05 threshold
RootDir=['D:\Bochum\DATA\fMRI_Match2sample\Data_thalamocortical\'];
analysis_dir='Results_st_keepandchange_mu2hat_New';
VOIradius_global= 8;
VOIradius_local = 4;
VOIname={'rMD','rOFC','rDLPFC'};
VOIxyz={[12 -10 8],[28 56 -6],[42 40 28]}; %change>keep

% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
%spm_get_defaults('cmdline',1);

for n = 1:length(Subjects)
    fprintf('Working on participant %d\n',Subjects(n));
    
    inputpath= fullfile(RootDir, sprintf('Sub%02d',Subjects(n)),analysis_dir);
    
    outputpath=fullfile(RootDir, sprintf('Sub%02d',Subjects(n)),'DCM_bilinear_rMD_rOFC_rDLPFC_4connections_new');
    mkdir(outputpath)
    
%     clear matlabbatch
    
%     for i=1:length(VOIname)
% 
%         
%         % EXTRACTING TIME SERIES:
%         %--------------------------------------------------------------------------
%         matlabbatch{i}.spm.util.voi.spmmat = cellstr(fullfile(inputpath,'SPM.mat'));
%         matlabbatch{i}.spm.util.voi.adjust = 7;  % Effects of interest contrast (F-contrast) number
%         matlabbatch{i}.spm.util.voi.session = 1; %
%         matlabbatch{i}.spm.util.voi.name = VOIname{i};
%         
%         % Define thresholded SPM for finding the subject's local peak response
%         matlabbatch{i}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
%         
%         matlabbatch{i}.spm.util.voi.roi{1}.spm.contrast = 5;  % change>keep
%         
%         matlabbatch{i}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
%         matlabbatch{i}.spm.util.voi.roi{1}.spm.thresh = 1;
%         matlabbatch{i}.spm.util.voi.roi{1}.spm.extent = 0;
%         
%         % Define large fixed outer sphere to fine the peak
%         matlabbatch{i}.spm.util.voi.roi{2}.sphere.centre = VOIxyz{i};
%         matlabbatch{i}.spm.util.voi.roi{2}.sphere.radius = VOIradius_global;
%         matlabbatch{i}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
%         
%         % Define smaller inner sphere which jumps to the peak of the outer sphere
%         matlabbatch{i}.spm.util.voi.roi{3}.sphere.centre           = [0 0 0]; % Leave this at zero
%         matlabbatch{i}.spm.util.voi.roi{3}.sphere.radius           = VOIradius_local;       % Set radius here (mm)
%         matlabbatch{i}.spm.util.voi.roi{3}.sphere.move.global.spm  = 1;       % Index of SPM within the batch
%         matlabbatch{i}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';    % Index of the outer sphere within the batch
%         
%         % Include voxels in the thresholded SPM (i1) and the mobile inner sphere (i3)
%         matlabbatch{i}.spm.util.voi.expression = 'i1 & i3';
%         
%         
%     end
%     
%     
%     spm_jobman('run',matlabbatch);
    
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
    DCM.U.name = [SPM.Sess(1).U(1).name(1) SPM.Sess(1).U(2).name(1)];
    DCM.U.u    = [SPM.Sess.U(1).u(33:end,1) ...     % Keep
                  SPM.Sess.U(2).u(33:end,1)];       % change  

    % DCM parameters and options
    %--------------------------------------------------------------------------
    DCM.delays = repmat(SPM.xY.RT/2,DCM.n,1);
    DCM.TE     = 0.04;
    
    DCM.options.nonlinear  = 0;
    DCM.options.two_state  = 0;
    DCM.options.stochastic = 0;
    DCM.options.nograph    = 1;
    
    % Connectivity matrices for model with backward modulation
    %--------------------------------------------------------------------------
    DCM.a = [0 1 1 ; 1 1 1 ; 1 1 1 ]; % endogenous connections  n_node x n_node
    DCM.d = zeros(3,3,0); %nonlinear modulation: n_node x n_node x n_node
    
    %% Bilinear Driving input-rMD
    DCM.c = [1 1; 0 0;0 0];% driving input to a node: n_node x n_conditions
    
    %model 1: 
    DCM.b = zeros(3,3,2);  % Bilinear: n_node x n_node x n_conditions
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(3,2,1) =1;  DCM.b(2,3,1) =1; DCM.b(3,2,2) =1;  DCM.b(2,3,2) =1;       % DLPFC->OFC & OFC->DLPFC
    save(fullfile(outputpath,'DCM_mod01_bilinear.mat'),'DCM');
    
    %model 2:
    DCM.b = zeros(3,3,2);  
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(1,2,1) =1;  DCM.b(2,1,1) =1;  DCM.b(1,2,2) = 1; DCM.b(2,1,2) = 1;     % OFC->MD & MD->OFC
    save(fullfile(outputpath,'DCM_mod02_bilinear.mat'),'DCM');
   
    %model 3: 
    DCM.b = zeros(3,3,2);   
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(1,2,1) =1;  DCM.b(2,3,1) =1;  DCM.b(1,2,2) =1;  DCM.b(2,3,2) =1;       % DLPFC->OFC & OFC->MD
    save(fullfile(outputpath,'DCM_mod03_bilinear.mat'),'DCM');    
    
    %model 4: 
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(2,1,1) =1;  DCM.b(3,2,1) =1;  DCM.b(2,1,2) =1;  DCM.b(3,2,2) =1;       % OFC->DLPFC & MD->OFC
    save(fullfile(outputpath,'DCM_mod04_bilinear.mat'),'DCM');
    
    %model 5:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(1,2,1) =1;  DCM.b(3,2,1) =1;  DCM.b(1,2,2) =1;  DCM.b(3,2,2) =1;       % OFC->DLPFC & OFC->MD 
    save(fullfile(outputpath,'DCM_mod05_bilinear.mat'),'DCM');
  
    %model 6:
    DCM.b = zeros(3,3,2);
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(2,1,1) =1;  DCM.b(2,3,1) =1;  DCM.b(2,1,2) =1;  DCM.b(2,3,2) =1;       % DLPFC->OFC & MD->OFC
    save(fullfile(outputpath,'DCM_mod06_bilinear.mat'),'DCM');
    

    %% Bilinear Driving input-rOFC
    DCM.c = [0 0; 1 1; 0 0]; % driving input to a node: n_node x n_conditions
    
    %model 7: 
    DCM.b = zeros(3,3,2);  % Bilinear: n_node x n_node x n_conditions
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(3,2,1) =1;  DCM.b(2,3,1) =1; DCM.b(3,2,2) =1;  DCM.b(2,3,2) =1;       % DLPFC->OFC & OFC->DLPFC
    save(fullfile(outputpath,'DCM_mod07_bilinear.mat'),'DCM');
    
    %model 8:
    DCM.b = zeros(3,3,2);  
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(1,2,1) =1;  DCM.b(2,1,1) =1;  DCM.b(1,2,2) = 1; DCM.b(2,1,2) = 1;     % OFC->MD & MD->OFC
    save(fullfile(outputpath,'DCM_mod08_bilinear.mat'),'DCM');
   
    %model 9: 
    DCM.b = zeros(3,3,2);   
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(1,2,1) =1;  DCM.b(2,3,1) =1;  DCM.b(1,2,2) =1;  DCM.b(2,3,2) =1;       % DLPFC->OFC & OFC->MD
    save(fullfile(outputpath,'DCM_mod09_bilinear.mat'),'DCM');    
    
    %model 10: 
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(2,1,1) =1;  DCM.b(3,2,1) =1;  DCM.b(2,1,2) =1;  DCM.b(3,2,2) =1;       % OFC->DLPFC & MD->OFC
    save(fullfile(outputpath,'DCM_mod10_bilinear.mat'),'DCM');
    
    %model 11:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(1,2,1) =1;  DCM.b(3,2,1) =1;  DCM.b(1,2,2) =1;  DCM.b(3,2,2) =1;       % OFC->DLPFC & OFC->MD 
    save(fullfile(outputpath,'DCM_mod11_bilinear.mat'),'DCM');
  
    %model 12:
    DCM.b = zeros(3,3,2);
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(2,1,1) =1;  DCM.b(2,3,1) =1;  DCM.b(2,1,2) =1;  DCM.b(2,3,2) =1;       % DLPFC->OFC & MD->OFC
    save(fullfile(outputpath,'DCM_mod12_bilinear.mat'),'DCM');
    

    
    %% Bilinear Driving input-rDLPFC
    DCM.c = [0 0; 0 0; 1 1]; % driving input to a node: n_node x n_conditions
    
    %model 13: 
    DCM.b = zeros(3,3,2);  % Bilinear: n_node x n_node x n_conditions
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(3,2,1) =1;  DCM.b(2,3,1) =1; DCM.b(3,2,2) =1;  DCM.b(2,3,2) =1;       % DLPFC->OFC & OFC->DLPFC
    save(fullfile(outputpath,'DCM_mod13_bilinear.mat'),'DCM');
    
    %model 14:
    DCM.b = zeros(3,3,2);  
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(1,2,1) =1;  DCM.b(2,1,1) =1;  DCM.b(1,2,2) = 1; DCM.b(2,1,2) = 1;     % OFC->MD & MD->OFC
    save(fullfile(outputpath,'DCM_mod14_bilinear.mat'),'DCM');
   
    %model 15: 
    DCM.b = zeros(3,3,2);   
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(1,2,1) =1;  DCM.b(2,3,1) =1;  DCM.b(1,2,2) =1;  DCM.b(2,3,2) =1;       % DLPFC->OFC & OFC->MD
    save(fullfile(outputpath,'DCM_mod15_bilinear.mat'),'DCM');    
    
    %model 16: 
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(2,1,1) =1;  DCM.b(3,2,1) =1;  DCM.b(2,1,2) =1;  DCM.b(3,2,2) =1;       % OFC->DLPFC & MD->OFC
    save(fullfile(outputpath,'DCM_mod16_bilinear.mat'),'DCM');
    
    %model 17:
    DCM.b = zeros(3,3,2); 
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(1,2,1) =1;  DCM.b(3,2,1) =1;  DCM.b(1,2,2) =1;  DCM.b(3,2,2) =1;       % OFC->DLPFC & OFC->MD 
    save(fullfile(outputpath,'DCM_mod17_bilinear.mat'),'DCM');
  
    %model 18:
    DCM.b = zeros(3,3,2);
    DCM.b(3,1,1) =1;  DCM.b(1,3,1) =1;  DCM.b(3,1,2) = 1; DCM.b(1,3,2) = 1;     % DLPFC->MD  & MD->DLPFC 
    DCM.b(2,1,1) =1;  DCM.b(2,3,1) =1;  DCM.b(2,1,2) =1;  DCM.b(2,3,2) =1;       % DLPFC->OFC & MD->OFC
    save(fullfile(outputpath,'DCM_mod18_bilinear.mat'),'DCM');

    % DCM Estimation
    %--------------------------------------------------------------------------
    clear matlabbatch
    
    
    matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
        fullfile(outputpath,'DCM_mod01_bilinear.mat');...
        fullfile(outputpath,'DCM_mod02_bilinear.mat');...
        fullfile(outputpath,'DCM_mod03_bilinear.mat');...
        fullfile(outputpath,'DCM_mod04_bilinear.mat');...
        fullfile(outputpath,'DCM_mod05_bilinear.mat');...
        fullfile(outputpath,'DCM_mod06_bilinear.mat');...
        fullfile(outputpath,'DCM_mod07_bilinear.mat');...
        fullfile(outputpath,'DCM_mod08_bilinear.mat');...
        fullfile(outputpath,'DCM_mod09_bilinear.mat');...
        fullfile(outputpath,'DCM_mod10_bilinear.mat');...
        fullfile(outputpath,'DCM_mod11_bilinear.mat');...
        fullfile(outputpath,'DCM_mod12_bilinear.mat');...
        fullfile(outputpath,'DCM_mod13_bilinear.mat');...
        fullfile(outputpath,'DCM_mod14_bilinear.mat');...
        fullfile(outputpath,'DCM_mod15_bilinear.mat');...
        fullfile(outputpath,'DCM_mod16_bilinear.mat');...
        fullfile(outputpath,'DCM_mod17_bilinear.mat');...
        fullfile(outputpath,'DCM_mod18_bilinear.mat')};
    
    
    spm_jobman('run',matlabbatch);
    
    % Bayesian Model Comparison
    %--------------------------------------------------------------------------
%     DCM_1 = load('DCM_mod1_test.mat','F');
%     DCM_2 = load('DCM_mod2_test.mat','F');
%     fprintf('Model evidence: %f (mod1) vs %f (mod2)\n',DCM_1.F,DCM_2.F);
end
