% List of open inputs
function batch_1stlevel_st_keep_and_change_mu2hat_con(RootDir,Subjects)  

Nr_run=3;
cond_name={'sample_keep','sample_change','decision_missing','target','target_missing'};
modulators={'keep_mu2hat','change_mu2hat'};

outputdir=['Results_st_keepandchange_mu2hat'];
job_name=['Model_1stlevel_st_keepandchange_mu2hat.mat'];
prfx='Sub';

%% define the name and contrast
contrast_name={'Keep_main effect','Keep_mu2hat','Change_main effect','Change_mu2hat','Change>Keep','keep_mu2hat>change_mu2hat','effect of interest'};


contrast= {[1 0 0 0 0 0 0 0 0 0 0 0 0];
           [0 1 0 0 0 0 0 0 0 0 0 0 0];
           [0 0 1 0 0 0 0 0 0 0 0 0 0];
           [0 0 0 1 0 0 0 0 0 0 0 0 0];
           [-1 0 1 0 0 0 0 0 0 0 0 0 0];
           [0 1 0 -1 0 0 0 0 0 0 0 0 0];
           [1 0 0 0 0 0 0 0 0 0 0 0 0
            0 1 0 0 0 0 0 0 0 0 0 0 0
            0 0 1 0 0 0 0 0 0 0 0 0 0
            0 0 0 1 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 1 0 0 0 0 0 0 0]};

%% loop for each subject
for i=1:length(Subjects)
    
    sub=Subjects(i);
    inputpath= [RootDir,prfx,num2str(sub,'%.2d')];
    outputpath= [RootDir,prfx,num2str(sub,'%.2d'),'\',outputdir];
    
    %% get the path of processed swra* file in 3 RUNs
    clear file_all filePath
    for j=1:Nr_run
        datapath=[inputpath,'\RUN',num2str(j),'\'];
        datadir=dir([datapath,'\swra*']);
        for i = 1:length(datadir)
            filePath{i,j} = [datapath,datadir(i).name];
        end
    end
    
    file_all=[filePath(:,1);filePath(:,2);filePath(:,3)];
    id=cellfun('length',file_all);
    file_all(id==0)=[];
    
    
    
    %% get the onset for conditions in 3 RUNs
    load([inputpath,'\Onset_sample_decision_prePE.mat']);
    
    onset_keep_all=[onset_keep_correct_all;onset_keep_wrong_all];
    onset_change_all=[onset_change_correct_all;onset_change_wrong_all];
    
    %onset_decision_missing_all
    
    load([inputpath,'\Onset_target_all.mat']);
    
    %onset_target_all
    %onset_target_missing_all
    
    %% get the prior belief value for both Keep and Change
    load([inputpath,'\Results_HGF.mat']);%Creat a mat fime to save all parameter value for each subject %%Extract_traj_val.m
    load([inputpath,'\index_decision_sample_prePE.mat']);
    

    PMs=[modulator(:,14),index_decision]; % |mu2hat|
    
    mu2hat_keep_correct=PMs(PMs(:,2)==1,1);
    mu2hat_keep_wrong=PMs(PMs(:,2)==2,1);
     
    mu2hat_change_correct=PMs(PMs(:,2)==3,1);
    mu2hat_change_wrong=PMs(PMs(:,2)==4,1);
    
    mu2hat_keep=[mu2hat_keep_correct;mu2hat_keep_wrong];
    mu2hat_change=[mu2hat_change_correct;mu2hat_change_wrong];
    
    
    %% get the file path of head movement parameters
    Headfiles = fullfile(inputpath,'rp_all.txt');
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  first level speficication
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear matlabbatch
    
    matlabbatch{1}.spm.stats.fmri_spec.dir = {outputpath};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.8;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    
    % RUN1
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = file_all;%%
    % cond1
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = cond_name{1}; %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = onset_keep_all; %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod(1).name = modulators{1};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod(1).param = mu2hat_keep;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod(1).poly = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;
    
    % cond2
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name =  cond_name{2};%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = onset_change_all;%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod(1).name = modulators{2};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod(1).param = mu2hat_change;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod(1).poly = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;
    
    % cond3
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name =  cond_name{3};%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = onset_decision_missing_all;%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).orth = 1;
    
    
    % cond4
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name =  cond_name{4};%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = onset_target_all;%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).orth = 1;
    
    
    %% cond5
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).name =  cond_name{5};%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).onset = onset_target_missing_all;%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).orth = 1;
    
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {Headfiles};%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;

    %
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
    save([inputpath,'\',job_name], 'matlabbatch');
    
    % run job
    spm_jobman('run',matlabbatch);
    
    %% concatenate three sessions
    if sub==1
        scans = [205 235 200];
    elseif sub==2
        scans = [205 230 203];
    elseif sub==4
        scans = [205 238 203];
    else
        scans = [202 238 202];
    end
    spm_fmri_concatenate([outputpath,'\SPM.mat'], scans);
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  model estimation and result check
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear matlabbatch
    
    matlabbatch{1}.spm.stats.fmri_est.spmmat(1) = {[outputpath,'\SPM.mat']};
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    
    matlabbatch{2}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.con.consess{1}.tcon.name = contrast_name{1};
    matlabbatch{2}.spm.stats.con.consess{1}.tcon.weights = contrast{1};
    matlabbatch{2}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{2}.spm.stats.con.consess{2}.tcon.name = contrast_name{2};
    matlabbatch{2}.spm.stats.con.consess{2}.tcon.weights = contrast{2};
    matlabbatch{2}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{2}.spm.stats.con.consess{3}.tcon.name = contrast_name{3};
    matlabbatch{2}.spm.stats.con.consess{3}.tcon.weights = contrast{3};
    matlabbatch{2}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{2}.spm.stats.con.consess{4}.tcon.name = contrast_name{4};
    matlabbatch{2}.spm.stats.con.consess{4}.tcon.weights = contrast{4};
    matlabbatch{2}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{2}.spm.stats.con.consess{5}.tcon.name = contrast_name{5};
    matlabbatch{2}.spm.stats.con.consess{5}.tcon.weights = contrast{5};
    matlabbatch{2}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    matlabbatch{2}.spm.stats.con.consess{6}.tcon.name = contrast_name{6};
    matlabbatch{2}.spm.stats.con.consess{6}.tcon.weights = contrast{6};
    matlabbatch{2}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    matlabbatch{2}.spm.stats.con.consess{7}.fcon.name = contrast_name{7};
    matlabbatch{2}.spm.stats.con.consess{7}.fcon.weights = contrast{7};
    matlabbatch{2}.spm.stats.con.consess{7}.fcon.sessrep = 'none';
    matlabbatch{2}.spm.stats.con.delete = 0;

    %%result check
    matlabbatch{3}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.results.conspec(1).titlestr = '';
    matlabbatch{3}.spm.stats.results.conspec(1).contrasts = 1;
    matlabbatch{3}.spm.stats.results.conspec(1).threshdesc = 'none';
    matlabbatch{3}.spm.stats.results.conspec(1).thresh = 0.001;
    matlabbatch{3}.spm.stats.results.conspec(1).extent = 0;
    matlabbatch{3}.spm.stats.results.conspec(1).conjunction = 1;
    matlabbatch{3}.spm.stats.results.conspec(1).mask.none = 1;
    
    matlabbatch{3}.spm.stats.results.conspec(2).titlestr = '';
    matlabbatch{3}.spm.stats.results.conspec(2).contrasts = 2;
    matlabbatch{3}.spm.stats.results.conspec(2).threshdesc = 'none';
    matlabbatch{3}.spm.stats.results.conspec(2).thresh = 0.001;
    matlabbatch{3}.spm.stats.results.conspec(2).extent = 0;
    matlabbatch{3}.spm.stats.results.conspec(2).conjunction = 1;
    matlabbatch{3}.spm.stats.results.conspec(2).mask.none = 1;
    
    matlabbatch{3}.spm.stats.results.conspec(3).titlestr = '';
    matlabbatch{3}.spm.stats.results.conspec(3).contrasts = 3;
    matlabbatch{3}.spm.stats.results.conspec(3).threshdesc = 'none';
    matlabbatch{3}.spm.stats.results.conspec(3).thresh = 0.001;
    matlabbatch{3}.spm.stats.results.conspec(3).extent = 0;
    matlabbatch{3}.spm.stats.results.conspec(3).conjunction = 1;
    matlabbatch{3}.spm.stats.results.conspec(3).mask.none = 1;
    
    matlabbatch{3}.spm.stats.results.conspec(4).titlestr = '';
    matlabbatch{3}.spm.stats.results.conspec(4).contrasts = 4;
    matlabbatch{3}.spm.stats.results.conspec(4).threshdesc = 'none';
    matlabbatch{3}.spm.stats.results.conspec(4).thresh = 0.001;
    matlabbatch{3}.spm.stats.results.conspec(4).extent = 0;
    matlabbatch{3}.spm.stats.results.conspec(4).conjunction = 1;
    matlabbatch{3}.spm.stats.results.conspec(4).mask.none = 1;
    
    matlabbatch{3}.spm.stats.results.conspec(5).titlestr = '';
    matlabbatch{3}.spm.stats.results.conspec(5).contrasts = 5;
    matlabbatch{3}.spm.stats.results.conspec(5).threshdesc = 'none';
    matlabbatch{3}.spm.stats.results.conspec(5).thresh = 0.001;
    matlabbatch{3}.spm.stats.results.conspec(5).extent = 0;
    matlabbatch{3}.spm.stats.results.conspec(5).conjunction = 1;
    matlabbatch{3}.spm.stats.results.conspec(5).mask.none = 1;
    
    matlabbatch{3}.spm.stats.results.conspec(6).titlestr = '';
    matlabbatch{3}.spm.stats.results.conspec(6).contrasts = 6;
    matlabbatch{3}.spm.stats.results.conspec(6).threshdesc = 'none';
    matlabbatch{3}.spm.stats.results.conspec(6).thresh = 0.001;
    matlabbatch{3}.spm.stats.results.conspec(6).extent = 0;
    matlabbatch{3}.spm.stats.results.conspec(6).conjunction = 1;
    matlabbatch{3}.spm.stats.results.conspec(6).mask.none = 1;
    
    matlabbatch{3}.spm.stats.results.conspec(7).titlestr = '';
    matlabbatch{3}.spm.stats.results.conspec(7).contrasts = 7;
    matlabbatch{3}.spm.stats.results.conspec(7).threshdesc = 'none';
    matlabbatch{3}.spm.stats.results.conspec(7).thresh = 0.001;
    matlabbatch{3}.spm.stats.results.conspec(7).extent = 0;
    matlabbatch{3}.spm.stats.results.conspec(7).conjunction = 1;
    matlabbatch{3}.spm.stats.results.conspec(7).mask.none = 1;
    
    matlabbatch{3}.spm.stats.results.units = 1;
    matlabbatch{3}.spm.stats.results.export{1}.ps = true;
    
    
   spm_jobman('run',matlabbatch);
    
    
end

