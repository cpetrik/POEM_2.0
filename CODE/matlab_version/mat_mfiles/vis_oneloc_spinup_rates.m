% Visualize output of POEM biol rate eq tests
% Spinup at one location
% 50 years, monthly means saved

clear all
close all

datap = '/Volumes/GFDL/CSV/Matlab_big_size/';
figp = '/Users/cpetrik/Dropbox/Princeton/POEM_2.0/CODE/Figs/PNG/Matlab_Big_sizes/';

RE = {'1000','0500','0100','0050','0010'};
reff = [1.0,0.5,0.1,0.05,0.01];
sreff = {'1.0','0.5','0.1','0.05','0.01'};
encs = 1:4;
Estr = {'K&H','Hartvig','mizer','J&C'};
cmaxs = [0,2:4];
Cstr = {'Hartvig15','Hartvig10','mizer','J&C'};
mets = 2:4;
Mstr = {'Hartvig','mizer','J&C'};
fcrit = 40;
nmort = '2';
kad = 100;
pref = 'D100';
BE = '05';
CC = '050';

spots = {'GB','EBS','OSP','HOT','BATS','NS','EEP','K2','S1','Aus','PUp'};
cols = {'bio','enc_f','enc_p','enc_d','enc_zm','enc_zl','enc_be','con_f',...
    'con_p','con_d','con_zm','con_zl','con_be','I','nu','gamma','die','rep',...
    'rec','clev','prod','pred','nmort','met','caught'};
cols=cols';

sname = 'Spinup_';
sname2 = '';

load('/Users/cpetrik/Dropbox/Princeton/POEM_2.0/CODE/Figs/poem_mfiles/cmap_ppt_angles.mat')
cmap3=cmap_ppt([5,1,3],:);
cm={[1 0.5 0],...   %orange
    [0.5 0.5 0],... %tan/army
    [0 0.7 0],...   %g
    [0 1 1],...     %c
    [0 0 0.75],...  %b
    [0.5 0 1],...   %purple
    [1 0 1],...     %m
    [1 0 0],...     %r
    [0.5 0 0],...   %maroon
    [0.75 0.75 0.75],... %lt grey
    [0.5 0.5 0.5],...    %med grey
    [49/255 79/255 79/255],... %dk grey
    [0 0 0],...      %black
    [1 1 0],...      %yellow
    [127/255 255/255 0],... %lime green
    [0 0.5 0],...    %dk green
    [0/255 206/255 209/255],... %turq
    [0 0.5 0.75],...   %med blue
    [188/255 143/255 143/255],... %rosy brown
    [255/255 192/255 203/255],... %pink
    [255/255 160/255 122/255]}; %peach

L_s = 10.0;     % small
L_m = 200.0;    % medium
L_l = 1.0e3;    % large

M_s = 0.01 * (0.1*L_s)^3;
M_m = 0.01 * (0.1*L_m)^3;
M_l = 0.01 * (0.1*L_l)^3;

mass = [M_s;M_m;M_l];
mass = repmat(mass,1,length(spots));
L = [L_s;L_m;L_l];

stages={'SF','MF','SP','MP','LP','SD','MD','LD'};

%%
mfn=3;
tmfn = num2str(mfn);
for E = 1%:length(encs)
    efn = encs(E);
    tefn = num2str(efn);
    for C = length(cmaxs)
        cfn = cmaxs(C);
        tcfn = num2str(cfn);
        for R = length(RE)
            rfrac = RE{R};
            close all
            dp = ['Dc_TrefO_cmax',tcfn,'_metab',tmfn,'_enc',tefn,'_MFeqMP_',pref,...
                '_nmort',nmort,'_BE',BE,'_CC',CC,'_RE',rfrac];
%             dp = ['Dc_TrefO_cmax-metab',tcfn,'_enc',tefn,'_MFeqMP_fcrit',num2str(fcrit),'_',pref,...
%                 '_nmort',nmort,'_BE',BE,'_CC',CC,'_RE',rfrac];
%             dp = ['Dc_TrefO_Hold_cmax-metab_MFeqMP_fcrit',num2str(fcrit),'_',pref,...
%                 '_nmort',nmort,'_BE',BE,'_CC',CC,'_RE',rfrac];
            dpath = [datap char(dp) '/'];
            fpath = [figp char(dp) '/'];
            if (~isdir([figp char(dp)]))
                mkdir([figp char(dp)])
            end
            cfile = char(dp);
            
            load([dpath sname 'lastyr_sum_mean_biom.mat']);
            
            mlev = [Flev;Plev;Dlev];
            %%
            for s=1:length(spots)
                loc = spots{s};
                lname = [loc '_'];
                
                %% Biomass
                f21 = figure(21);
                subplot(4,3,s)
                plot(0.5:2:5.5,log10(squeeze(all_mean(:,1,s))),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(1:2:6,log10(squeeze(all_mean(:,2,s))),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(1.5:2:6.5,log10(squeeze(all_mean(:,3,s))),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 6])
                ylim([-3 2])
                set(gca,'XTick',1:2:5,'XTickLabel',{'S','M','L'})
                if (s==4)
                    ylabel('log10 Mean Biom (g m^-^2) in final year')
                end
                title(loc)
                if (s==3)
                    stamp(cfile)
                end
                
                %% Feeding level
                f2=figure(2);
                subplot(4,3,s)
                bar(mlev(:,s),'k')
                ylim([0 1])
                xlim([0 9])
                set(gca,'XTickLabel',[]);
                for n=1:8
                    text(n-0.5,-0.2,stages{n},'Rotation',45)
                end
                title(spots{s})
                if (s==4)
                    ylabel('Feeding level')
                end
                if (s==11)
                    subplot(4,3,12)
                    bar(mean(mlev,2),'k')
                    ylim([0 1])
                    xlim([0 9])
                    set(gca,'XTickLabel',[]);
                    for n=1:8
                        text(n-0.5,-0.2,stages{n},'Rotation',45)
                    end
                    title('Mean all')
                    stamp(cfile)
                end
                
                %% Growth rate (nu - energy for biomass production)
                f3 = figure(3);
                subplot(2,2,1)
                plot(s-0.25,Fmgr(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,Pmgr(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,Dmgr(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                ylabel('Mean growth rate (g g^-^1 d^-^1) in final year')
                title('S')
                
                subplot(2,2,2)
                plot(s-0.25,(Fmgr(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,(Pmgr(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dmgr(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                ylabel('Mean growth/repro rate (g g^-^1 d^-^1) in final year')
                title('M')
                
                subplot(2,2,3)
                plot(s,(Pmgr(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dmgr(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                ylabel('Mean repro rate (g g^-^1 d^-^1) in final year')
                title('L')
                if (s==3)
                    stamp(cfile)
                end
                
                %% Fraction zoop losses consumed
                f5 = figure(5);
                subplot(4,3,s)
                bar(z(s,:),'k'); hold on;
                xlim([0 4])
                ylim([0 1])
                set(gca,'XTick',1:3,'XTickLabel',{'MZ','LZ','Bent'})
                if (s==4)
                    ylabel('Fraction flux consumed')
                end
                title(loc)
                if (s==3)
                    stamp(cfile)
                end
                
                %% Production (= nu * biom)
                f8 = figure(8);
                subplot(2,2,1)
                plot(s-0.25,Fprod(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,Pprod(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,Dprod(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                ylabel('Mean biom prod rate (g g^-^1 d^-^1) in final year')
                title('S')
                
                subplot(2,2,2)
                plot(s-0.25,(Fprod(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,(Pprod(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dprod(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                ylabel('Mean biom prod rate (g g^-^1 d^-^1) in final year')
                title('M')
                
                subplot(2,2,3)
                plot(s,(Pprod(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dprod(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                ylabel('Mean biom prod rate (g g^-^1 d^-^1) in final year')
                title('L')
                if (s==1)
                    stamp(cfile)
                end
                
                %% Reproduction
                f9 = figure(9);
                subplot(1,2,1)
                plot(s-0.25,Frep(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,Prep(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,Drep(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,-0.01,spots{n},'Rotation',45)
                end
                ylabel('Mean repro rate (g g^-^1 d^-^1) in final year')
                
                subplot(1,2,2)
                plot(s-0.25,(Frep(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,(Prep(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Drep(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,-0.01,spots{n},'Rotation',45)
                end
                ylabel('Mean biom reproduced (g d^-^1) in final year')
                if (s==1)
                    stamp(cfile)
                end
                
                %% Metabolism
                f10 = figure(10);
                subplot(2,2,1)
                plot(s-0.25,Fmet(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,Pmet(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,Dmet(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                ylabel('Mean metabolism (g g^-^1 d^-^1) in final year')
                title('S')
                
                subplot(2,2,2)
                plot(s-0.25,(Fmet(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,(Pmet(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dmet(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                ylabel('Mean metabolism (g g^-^1 d^-^1) in final year')
                title('M')
                
                subplot(2,2,3)
                plot(s,(Pmet(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dmet(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                ylabel('Mean metabolism (g g^-^1 d^-^1) in final year')
                title('L')
                if (s==3)
                    stamp(cfile)
                end
                
                %% Predation
                f11 = figure(11);
                subplot(1,2,1)
                plot(s-0.25,Fpred(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,Ppred(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,Dpred(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,-0.001,spots{n},'Rotation',45)
                end
                ylabel('Mean predation rate (d^-^1) in final year')
                title('S')
                
                subplot(1,2,2)
                plot(s-0.25,(Fpred(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,(Ppred(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dpred(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,-0.001,spots{n},'Rotation',45)
                end
                ylabel('Mean predation rate (d^-^1) in final year')
                title('M')
                if (s==3)
                    stamp(cfile)
                end
                
                %% Fishing
                f12 = figure(12);
                subplot(1,2,1)
                plot(s-0.25,Ftotcatch(2,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,Ptotcatch(2,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,Dtotcatch(2,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,-0.1,spots{n},'Rotation',45)
                end
                ylabel('Total catch (g) in final year')
                
                subplot(1,2,2)
                plot(s,Ptotcatch(3,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,Dtotcatch(3,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,-0.1,spots{n},'Rotation',45)
                end
                ylabel('Total catch (g) in final year')
                if (s==1)
                    stamp(cfile)
                end
                
                %% Total mortality w/o fishing
                %model mass in grams
                M = 0.01 .* (0.1.*L).^3;
                %Andersen & Beyer mortality rate per year (natural + predation)
                %physiol mort * growth constant * M^-0.25
                AB = (0.35 .* 4.5 .* M.^(-0.25)) ./365;
                
                Fmort = Fpred + Fnat;
                Pmort = Ppred + Pnat;
                Dmort = Dpred + Dnat;
                
                f13=figure(13);
                subplot(2,2,1)
                plot(s-0.25,Fmort(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,Pmort(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,Dmort(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                if(s==11)
                    plot(0:10,AB(1)*ones(11,1),'--k'); hold on;
                end
                ylabel('Mean mortality rate w/o fishing (d^-^1) in final year')
                title('S')
                
                subplot(2,2,2)
                plot(s-0.25,(Fmort(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,(Pmort(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dmort(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                if(s==11)
                    plot(0:10,AB(2)*ones(11,1),'--k'); hold on;
                end
                title('M')
                
                subplot(2,2,3)
                plot(s,(Pmort(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dmort(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                if(s==11)
                    plot(0:10,AB(3)*ones(11,1),'--k'); hold on;
                end
                title('L')
                
                %% Total mortality w/ fishing
                Fmortf = Fpred + Fnat + Ffish;
                Pmortf = Ppred + Pnat + Pfish;
                Dmortf = Dpred + Dnat + Dfish;
                
                f14=figure(14);
                subplot(2,2,1)
                plot(s-0.25,Fmortf(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,Pmortf(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,Dmortf(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                if(s==11)
                    plot(0:10,AB(1)*ones(11,1),'--k'); hold on;
                end
                ylabel('Mean mortality rate w/fishing (d^-^1) in final year')
                title('S')
                
                subplot(2,2,2)
                plot(s-0.25,(Fmortf(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,(Pmortf(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dmortf(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                if(s==11)
                    plot(0:10,AB(2)*ones(11,1),'--k'); hold on;
                end
                title('M')
                
                subplot(2,2,3)
                plot(s,(Pmortf(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dmortf(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,0,spots{n},'Rotation',45)
                end
                if(s==11)
                    plot(0:10,AB(3)*ones(11,1),'--k'); hold on;
                end
                title('L')
                
                %% Gross growth efficiency (= nu/consump)
                f15 = figure(15);
                subplot(2,2,1)
                plot(s-0.25,Fgge(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,Pgge(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,Dgge(1,s),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                ylim([-0.5 0.5])
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,-0.6,spots{n},'Rotation',45)
                end
                ylabel('Mean gross growth efficiency in final year')
                title('S')
                
                subplot(2,2,2)
                plot(s-0.25,(Fgge(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(3,:),...
                    'MarkerSize',15); hold on;
                plot(s,(Pgge(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dgge(2,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                ylim([-0.5 0.5])
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,-0.6,spots{n},'Rotation',45)
                end
                ylabel('Mean gross growth efficiency in final year')
                title('M')
                
                subplot(2,2,3)
                plot(s,(Pgge(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(1,:),...
                    'MarkerSize',15); hold on;
                plot(s+0.25,(Dgge(3,s)),'sk',...
                    'MarkerFaceColor',cmap_ppt(2,:),...
                    'MarkerSize',15); hold on;
                ylim([-0.5 0.5])
                xlim([0 12])
                set(gca,'XTickLabel',[]);
                for n=1:11
                    text(n-0.5,-0.6,spots{n},'Rotation',45)
                end
                ylabel('Mean gross growth efficiency in final year')
                title('L')
                if (s==3)
                    stamp(cfile)
                end
                
            end
            print(f21,'-dpng',[fpath sname sname2 'All_oneloc_Logmean_biomass_axes.png'])
            print(f2,'-dpng',[fpath sname sname2 'All_oneloc_con_level.png'])
            print(f3,'-dpng',[fpath sname sname2 'All_oneloc_nu.png'])
            print(f5,'-dpng',[fpath sname sname2 'All_oneloc_frac_zoop_loss.png'])
            print(f8,'-dpng',[fpath sname sname2 'All_oneloc_prod.png'])
            print(f9,'-dpng',[fpath sname sname2 'All_oneloc_rep.png'])
            print(f10,'-dpng',[fpath sname sname2 'All_oneloc_met.png'])
            print(f11,'-dpng',[fpath sname sname2 'All_oneloc_pred.png'])
            print(f12,'-dpng',[fpath sname sname2 'All_oneloc_catch.png'])
            print(f13,'-dpng',[fpath sname sname2 'All_oneloc_mort_nof.png'])
            print(f14,'-dpng',[fpath sname sname2 'All_oneloc_mort_f.png'])
            print(f15,'-dpng',[fpath sname sname2 'All_oneloc_gge.png'])
            
            %% Sum mean biom over stages
            fishsp = squeeze(nansum(all_mean));
            
            figure(16);
            plot((1-0.2):11,log10(fishsp(1,:)),'sk','MarkerFaceColor',cmap_ppt(3,:),...
                'MarkerSize',15); hold on;
            plot(1:11,log10(fishsp(2,:)),'sk','MarkerFaceColor',cmap_ppt(1,:),...
                'MarkerSize',15); hold on;
            plot((1+0.2):12,log10(fishsp(3,:)),'sk','MarkerFaceColor',cmap_ppt(2,:),...
                'MarkerSize',15); hold on;
            xlim([0 12])
            ylim([-2 2])
            set(gca,'XTick',1:11,'XTickLabel',[])
            for n=1:11
                text(n,-2.2,spots{n},'HorizontalAlignment','center')
            end
            ylabel('log10 Mean Biom (g m^-^2) in final year')
            title('All stages')
            stamp(cfile)
            print('-dpng',[fpath sname sname2 'All_oneloc_tot_mean_biomass_type.png'])
            
            sumspec = squeeze(nansum(nansum(all_mean)));
            
            figure(17);
            plot(1:11,log10(sumspec),'k.','MarkerSize',25); hold on;
            xlim([0 12])
            ylim([-2 2])
            set(gca,'XTick',1:11,'XTickLabel',[])
            for n=1:11
                text(n,-2.1,spots{n},'HorizontalAlignment','center')
            end
            ylabel('log10 Mean Biom (g m^-^2) in final year')
            title('All fishes and stages')
            stamp(cfile)
            print('-dpng',[fpath sname sname2 'All_oneloc_tot_mean_biomass_spec.png'])
            
            %% Consump g/g/d --> g/d --> g/y
            Pcon = Pcon .* mass .* 365;
            Fcon = Fcon .* mass(1:2,:) .* 365;
            Dcon = Dcon .* mass .* 365;
            
            f18 = figure(18);
            subplot(3,1,1)
            plot(0.75:1:10.75,Fcon(1,:),'sk',...
                'MarkerFaceColor',cmap_ppt(3,:),...
                'MarkerSize',15); hold on;
            plot(1:1:11,Pcon(1,:),'sk',...
                'MarkerFaceColor',cmap_ppt(1,:),...
                'MarkerSize',15); hold on;
            plot(1.25:1:11.25,Dcon(1,:),'sk',...
                'MarkerFaceColor',cmap_ppt(2,:),...
                'MarkerSize',15); hold on;
            xlim([0 12])
            ylabel('S')
            set(gca,'XTick',1:11,'XTickLabel',spots)
            title('Mean consumption (g y^-^1) in final year')
            
            subplot(3,1,2)
            plot(0.75:1:10.75,Fcon(2,:),'sk',...
                'MarkerFaceColor',cmap_ppt(3,:),...
                'MarkerSize',15); hold on;
            plot(1:1:11,Pcon(2,:),'sk',...
                'MarkerFaceColor',cmap_ppt(1,:),...
                'MarkerSize',15); hold on;
            plot(1.25:1:11.25,Dcon(2,:),'sk',...
                'MarkerFaceColor',cmap_ppt(2,:),...
                'MarkerSize',15); hold on;
            xlim([0 12])
            ylabel('M')
            set(gca,'XTick',1:11,'XTickLabel',spots)
            
            subplot(3,1,3)
            plot(1:1:11,Pcon(3,:),'sk',...
                'MarkerFaceColor',cmap_ppt(1,:),...
                'MarkerSize',15); hold on;
            plot(1.25:1:11.25,Dcon(3,:),'sk',...
                'MarkerFaceColor',cmap_ppt(2,:),...
                'MarkerSize',15); hold on;
            xlim([0 12])
            ylabel('L')
            set(gca,'XTick',1:11,'XTickLabel',spots)
            xlabel('Location')
            stamp(cfile)
            
            print(f18,'-dpng',[fpath sname sname2 'All_oneloc_consump_gyr.png'])
            
            %% Consump vs. weight
            A = 4.39;
            fc = 0.2;
            f0 = 0.6;
            epsassim = 0.6;
            n = 3/4;
            
            w = logspace(-3, 5);
            
            AvailEnergy = A*w.^n;
            Consumption = A / (epsassim*(f0-fc)) * w.^n;
            
            f19=figure(19);
            for s=1:length(spots)
                subplot(1,3,1)
                loglog((mass(1:2,1)),(Fcon(:,s)),'.',...
                    'Color',cm{s},'MarkerSize',25); hold on;
                title('F')
                xlabel('Mass (g)')
                ylabel('Mean consumption (g y^-^1) in final year')
                legend(spots)
                legend('location','northwest')
                %axis([-5 5 -1 5])
                
                subplot(1,3,2)
                loglog((mass(:,1)),(Pcon(:,s)),'.',...
                    'Color',cm{s},'MarkerSize',25); hold on;
                title('P')
                xlabel('Mass (g)')
                %axis([-5 5 -1 5])
                
                subplot(1,3,3)
                loglog((mass(:,1)),(Dcon(:,s)),'.',...
                    'Color',cm{s},'MarkerSize',25); hold on;
                title('D')
                xlabel('Mass (g)')
                %axis([-5 5 -1 5])
                stamp(cfile)
            end
            subplot(1,3,1)
            loglog(w, Consumption,'k')
            
            subplot(1,3,2)
            loglog(w, Consumption,'k')
            
            subplot(1,3,3)
            loglog(w, Consumption,'k')
            print(f19,'-dpng',[fpath sname 'All_oneloc_consump_gyr_vs_weight_compare.png'])
            
        end %RE
    end %cmax
end %enc
