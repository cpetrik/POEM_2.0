% Visualize output of POEM
% Pristine historical at one location
% 145 years

clear all
close all

dpath = '/Users/cpetrik/Dropbox/Princeton/POEM_2.0/CODE/Data/CSV/';
fpath = '/Users/cpetrik/Dropbox/Princeton/POEM_2.0/CODE/Figs/PNG/';

spots = {'GB','EBS','OSP','HOT','BATS','NS'};

for s=1:length(spots)
    %%
    close all
    loc = spots{s};
    sname = 'Oneloc_pris_';
    %lname = [loc '_phen_'];
    lname = [loc '_'];
    SP = csvread([dpath sname lname 'Sml_p.csv']);
    SF = csvread([dpath sname lname 'Sml_f.csv']);
    SD = csvread([dpath sname lname 'Sml_d.csv']);
    MP = csvread([dpath sname lname 'Med_p.csv']);
    MF = csvread([dpath sname lname 'Med_f.csv']);
    MD = csvread([dpath sname lname 'Med_d.csv']);
    LP = csvread([dpath sname lname 'Lrg_p.csv']);
    mMF = csvread([dpath sname 'Rec_' lname 'Med_f.csv']);
    mMD = csvread([dpath sname 'Rec_' lname 'Med_d.csv']);
    mLP = csvread([dpath sname 'Rec_' lname 'Lrg_p.csv']);
    
    %% Plots over time
    x=1:length(SP);
    yfrac=x/365;
    y=1861:(1/365):(1861+yfrac(end));
    %y=1861:(1/365):2005;
    y=y(1:(end-1));
    lstd=length(SP);
    id1 = 0:365:(lstd-1);
    id2 = 365:365:(lstd);
    ID  = [id1 id2];
    
    
    %% Piscivore
    figure(1)
    plot(y((end-(30*365)):end),SP((end-(30*365)):end),'b','Linewidth',2); hold on;
    plot(y((end-(30*365)):end),MP((end-(30*365)):end),'r','Linewidth',2); hold on;
    plot(y((end-(30*365)):end),LP((end-(30*365)):end),'k','Linewidth',2); hold on;
    xlim([y(end-(30*365)) y(end)])
    title(['Historic Pelagic Piscivores ' loc])
    xlabel('Time (y)')
    ylabel('Biomass (g km^-^2)')
    legend('Larvae','Juveniles','Adults')
    print('-dpng',[fpath sname lname 'oneloc_pisc_time.png'])
    
    %% Planktivore
    figure(2)
    plot(y((end-(30*365)):end),SF((end-(30*365)):end),'b','Linewidth',2); hold on;
    plot(y((end-(30*365)):end),MF((end-(30*365)):end),'r','Linewidth',2); hold on;
    xlim([y(end-(30*365)) y(end)])
    xlabel('Time (y)')
    ylabel('Biomass (g km^-^2)')
    legend('Immature','Adults')
    title(['Historic Forage Fishes ' loc])
    print('-dpng',[fpath sname lname 'oneloc_plan_time.png'])
    
    %% Detritivore
    figure(3)
    plot(y((end-(30*365)):end),SD((end-(30*365)):end),'b','Linewidth',2); hold on;
    plot(y((end-(30*365)):end),MD((end-(30*365)):end),'r','Linewidth',2); hold on;
    xlim([y(end-(30*365)) y(end)])
    xlabel('Time (y)')
    ylabel('Biomass (g km^-^2)')
    legend('Immature','Adults')
    title(['Historic Demersal Fishes ' loc])
    print('-dpng',[fpath sname lname 'oneloc_detr_time.png'])
    
    %% All size classes of all
    
    figure(4)
    plot(y((end-(30*365)):end),SP((end-(30*365)):end,:),'Linewidth',2); hold on;
    plot(y((end-(30*365)):end),MP((end-(30*365)):end,:),'Linewidth',2); hold on;
    plot(y((end-(30*365)):end),LP((end-(30*365)):end,:),'Linewidth',2); hold on;
    plot(y((end-(30*365)):end),SF((end-(30*365)):end,:),'Linewidth',2); hold on;
    plot(y((end-(30*365)):end),MF((end-(30*365)):end,:),'Linewidth',2); hold on;
    plot(y((end-(30*365)):end),SD((end-(30*365)):end,:),'Linewidth',2); hold on;
    plot(y((end-(30*365)):end),MD((end-(30*365)):end,:),'Linewidth',2); hold on;
    legend('SP','MP','LP','SF','MF','SD','MD')
    legend('location','eastoutside')
    xlim([y(end-(30*365)) y(end)])
    xlabel('Time (y)')
    ylabel('Biomass (g km^-^2)')
    title(['Historic ' loc])
    print('-dpng',[fpath sname lname 'oneloc_all_sizes.png'])
    
    %% Final mean biomass size spectrum
    t=1:length(SP);
    lyr=t((end-(30*365)+1):end);
    SP_sum=sum(SP(lyr));
    SF_sum=sum(SF(lyr));
    SD_sum=sum(SD(lyr));
    MP_sum=sum(MP(lyr));
    MF_sum=sum(MF(lyr));
    MD_sum=sum(MD(lyr));
    LP_sum=sum(LP(lyr));
    
    SP_mean=mean(SP(lyr));
    SF_mean=mean(SF(lyr));
    SD_mean=mean(SD(lyr));
    MP_mean=mean(MP(lyr));
    MF_mean=mean(MF(lyr));
    MD_mean=mean(MD(lyr));
    LP_mean=mean(LP(lyr));
    
    P_sum=[SP_sum;MP_sum;LP_sum];
    F_sum=[SF_sum;MF_sum];
    D_sum=[SD_sum;MD_sum];
    P_mean=[SP_mean;MP_mean;LP_mean];
    F_mean=[SF_mean;MF_mean];
    D_mean=[SD_mean;MD_mean];
    
    Pwgt = [0.0025; 2.5298; 2.5298e3];
    Fwgt = [0.0025; 2.5298];
    Dwgt = [0.0025; 2.5298];
    
    figure(5)
    subplot(2,3,1)
    bar(P_sum,'k')
    xlim([0 4])
    title('Pelagic Piscivores')
    ylabel('Total Biomass (g km^-^2)')
    subplot(2,3,4)
    bar(P_mean,'k')
    xlim([0 4])
    ylabel('Mean Biomass (g km^-^2)')
    
    subplot(2,3,2)
    bar(F_sum,'b')
    xlim([0 3])
    title({loc; 'Forage Fishes'})
    xlabel('Stage')
    subplot(2,3,5)
    bar(F_mean,'b')
    xlim([0 3])
    xlabel('Stage')
    
    subplot(2,3,3)
    bar(D_sum,'r')
    xlim([0 3])
    title('Demersal Fishes')
    subplot(2,3,6)
    bar(D_mean,'r')
    xlim([0 3])
    print('-dpng',[fpath sname lname 'oneloc_all_biomass_spec.png'])
    
    %% Recruitment
%     yr=t((end-(30*365)+1):end);
%     SPL=mLP(yr);
%     SFL=mMF(yr);
%     SDL=mMD(yr);
%     PA=LP(yr);
%     FA=MF(yr);
%     DA=MD(yr);
%     
%     st=1:365:length(yr);
%     en=365:365:length(yr);
%     SPy = NaN*ones(30,1);
%     SFy = SPy;
%     SDy = SPy;
%     PAy = SPy;
%     FAy = SPy;
%     DAy = SPy;
%     for n=1:30
%         SPy(n) = nansum(SPL(st(n):en(n)));
%         SFy(n) = nansum(SFL(st(n):en(n)));
%         SDy(n) = nansum(SDL(st(n):en(n)));
%         PAy(n) = nansum(PA(st(n):en(n)));
%         FAy(n) = nansum(FA(st(n):en(n)));
%         DAy(n) = nansum(DA(st(n):en(n)));
%     end
%     
%     %
%     figure(7)
%     subplot(3,1,1)
%     plot(1976:2005,SPy,'Linewidth',2); hold on;
%     xlim([1976 2005])
%     ylabel({loc; 'Recruits (g km^-^2)'})
%     title('Pelagic piscivores')
%     
%     subplot(3,1,2)
%     plot(1976:2005,SFy,'Linewidth',2); hold on;
%     xlim([1976 2005])
%     ylabel('Recruits (g km^-^2)')
%     title('Forage fishes')
%     
%     subplot(3,1,3)
%     plot(1976:2005,SDy,'Linewidth',2); hold on;
%     xlim([1976 2005])
%     ylabel('Recruits (g km^-^2)')
%     title('Demersal piscivores')
%     print('-dpng',[fpath sname lname 'oneloc_recruitment.png'])
end
