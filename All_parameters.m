

RootDir=['D:\Bochum\DATA\fMRI_Match2sample\Data_thalamocortical\'];
Subjects=[1 2 4 6 9 10 12 15 16 17 18 19 20 21 22 23 24 25 26 28 29 30 31 32 33 35 36 37];

prfx='Sub';


    All_pre_epsi2_keep=[];
    All_pre_epsi2_change=[];
    All_pre_epsi3_keep=[];
    All_pre_epsi3_change=[];
    All_pre_psi2_keep=[];
    All_pre_psi2_change=[];
    All_pre_psi3_keep=[];
    All_pre_psi3_change=[];
    All_pre_choicePE_keep=[];
    All_pre_choicePE_change=[];
    All_pi2hat_keep=[];
    All_pi2hat_change=[];
    All_mu2hat_keep=[];
    All_mu2hat_change=[];

    All_mu1hat_keep=[];
    All_mu1hat_change=[];
%% loop for each subject
for i=1:length(Subjects)
    
    sub=Subjects(i);
    inputpath= [RootDir,prfx,num2str(sub,'%.2d')];
    
    load([inputpath,'\Results_HGF_raw.mat']);%Creat a mat fime to save all parameter value for each subject %%Extract_traj_val.m
    load([inputpath,'\index_decision_sample_prePE.mat']);
    
    
    index_decision(index_decision==2)=1; %keep
    index_decision(index_decision==4)=3; %change
    

    pre_epsi2=[[0;modulator(1:end-1,6)],index_decision];     % precision-weighted prediction error
    pre_epsi3=[[0;modulator(1:end-1,7)],index_decision];     % precision-weighted prediction error
    pre_psi2=[[0;modulator(1:end-1,8)],index_decision];      % precision
    pre_psi3=[[0;modulator(1:end-1,9)],index_decision];      % precision
    pre_choicePE=[[0;modulator(1:end-1,10)],index_decision]; % choice PE
    
    pi2hat=[modulator(:,4),index_decision];   % uncertainty
    pi3hat=[modulator(:,5),index_decision];   % uncertainty
    mu2hat=[modulator(:,14),index_decision];  % prior belief and precision
    mu3hat=[modulator(:,15),index_decision];  % prior belief and precision
    
    mu1hat=[modulator(:,13),index_decision];  % probability
    
    pre_epsi2_keep = pre_epsi2(pre_epsi2(:,2)==1,1);
    pre_epsi2_change = pre_epsi2(pre_epsi2(:,2)==3,1);
    
    pre_epsi3_keep = pre_epsi3(pre_epsi3(:,2)==1,1);
    pre_epsi3_change = pre_epsi3(pre_epsi3(:,2)==3,1);
    
    pre_psi2_keep = pre_psi2(pre_psi2(:,2)==1,1);
    pre_psi2_change = pre_psi2(pre_psi2(:,2)==3,1);

    pre_psi3_keep = pre_psi3(pre_psi3(:,2)==1,1);
    pre_psi3_change = pre_psi3(pre_psi3(:,2)==3,1);
    
    pre_choicePE_keep = pre_choicePE(pre_choicePE(:,2)==1,1);
    pre_choicePE_change = pre_choicePE(pre_choicePE(:,2)==3,1);    
    
    pi2hat_keep = pi2hat(pi2hat(:,2)==1,1);
    pi2hat_change = pi2hat(pi2hat(:,2)==3,1);
    
    mu2hat_keep = mu2hat(mu2hat(:,2)==1,1);
    mu2hat_change = mu2hat(mu2hat(:,2)==3,1);

    mu1hat_keep = mu1hat(mu1hat(:,2)==1,1);
    mu1hat_change = mu1hat(mu1hat(:,2)==3,1);

    
    
    All_pre_epsi2_keep = [All_pre_epsi2_keep;pre_epsi2_keep];
    All_pre_epsi2_change = [All_pre_epsi2_change;pre_epsi2_change];
    
    All_pre_epsi3_keep = [All_pre_epsi3_keep;pre_epsi3_keep];
    All_pre_epsi3_change = [All_pre_epsi3_change;pre_epsi3_change];
    
    All_pre_psi2_keep = [All_pre_psi2_keep;pre_psi2_keep];
    All_pre_psi2_change = [All_pre_psi2_change;pre_psi2_change];
    
    All_pre_psi3_keep = [All_pre_psi3_keep;pre_psi3_keep];
    All_pre_psi3_change = [All_pre_psi3_change;pre_psi3_change];
    
    All_pre_choicePE_keep = [All_pre_choicePE_keep;pre_choicePE_keep];
    All_pre_choicePE_change = [All_pre_choicePE_change;pre_choicePE_change];
    
    All_pi2hat_keep = [All_pi2hat_keep;pi2hat_keep];
    All_pi2hat_change = [All_pi2hat_change;pi2hat_change];
    
    All_mu2hat_keep = [All_mu2hat_keep;mu2hat_keep];
    All_mu2hat_change = [All_mu2hat_change;mu2hat_change];
    
    All_mu1hat_keep = [All_mu1hat_keep;mu1hat_keep];
    All_mu1hat_change = [All_mu1hat_change;mu1hat_change];
    
end
    
    
    
    
    
    
    
    
    