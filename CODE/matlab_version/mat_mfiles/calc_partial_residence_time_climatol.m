% Calc partial residence times
% Residence time = biomass / 1 input
% or             = biomass / 1 output
% Total inputs: rec, nu
% Total outputs: gamma, rep, nmort, die (pred), yield (fishing)

clear all
close all

cfile = 'Dc_enc70-b200_m4-b175-k086_c20-b250_D075_J100_A050_Sm025_nmort1_BE08_noCC_RE00100';
harv = 'All_fish03';
fpath=['/Volumes/MIP/NC/Matlab_new_size/' cfile '/'];

pp = '/Users/cpetrik/Dropbox/Princeton/FEISTY/CODE/Figs/PNG/Matlab_New_sizes/';
ppath = [pp cfile '/Climatol/'];
load('/Volumes/FEISTY/POEM_JLD/esm26_hist/ESM26_1deg_5yr_clim_191_195_gridspec.mat');

%%
load([fpath 'Means_die_nmort_yield_Climatol_' harv '_' cfile '.mat'],...
    'sf_die','sp_die','sd_die',...
    'sf_mort','sp_mort','sd_mort');

load([fpath 'Means_con_rec_rep_Climatol_' harv '_' cfile '.mat'],...
    'sf_rec','sp_rec','sd_rec',...
    'sf_con','sp_con','sd_con');

load([fpath 'Means_nu_gam_die_clev_Climatol_' harv '_' cfile '.mat'],...
    'sf_gamma','sp_gamma','sd_gamma',...
    'sf_nu','sp_nu','sd_nu');

load([fpath 'Means_Climatol_' harv '_' cfile '.mat'],...
    'sf_bio','sp_bio','sd_bio');

%% 
sf_nu = max(0,sf_nu);
sp_nu = max(0,sp_nu);
sd_nu = max(0,sd_nu);

%ld_gamma + ld_rep + ld_mort + ld_die + ld_yield + max(0,ld_nu) + ld_rec;

%% nu
sf_rnu = sf_bio ./ sf_nu;
sp_rnu = sp_bio ./ sp_nu;
sd_rnu = sd_bio ./ sd_nu;
% rec
sf_rrec = sf_bio ./ sf_rec;
sp_rrec = sp_bio ./ sp_rec;
sd_rrec = sd_bio ./ sd_rec;
% gamma
sf_rgam = sf_bio ./ sf_gamma;
sp_rgam = sp_bio ./ sp_gamma;
sd_rgam = sd_bio ./ sd_gamma;
% mort
sf_rmort = sf_bio ./ sf_mort;
sp_rmort = sp_bio ./ sp_mort;
sd_rmort = sd_bio ./ sd_mort;
% die
sf_rdie = sf_bio ./ sf_die;
sp_rdie = sp_bio ./ sp_die;
sd_rdie = sd_bio ./ sd_die;
% con
sf_rcon = sf_bio ./ sf_con;
sp_rcon = sp_bio ./ sp_con;
sd_rcon = sd_bio ./ sd_con;

%% means
sf_mrnu = nanmean(sf_rnu,2);
sp_mrnu = nanmean(sp_rnu,2);
sd_mrnu = nanmean(sd_rnu,2);

sf_mrrec = mean(sf_rrec,2);
sp_mrrec = mean(sp_rrec,2);
sd_mrrec = mean(sd_rrec,2);

sf_mrgam = mean(sf_rgam,2);
sp_mrgam = mean(sp_rgam,2);
sd_mrgam = mean(sd_rgam,2);

sf_mrmort = nanmean(sf_rmort,2);
sp_mrmort = nanmean(sp_rmort,2);
sd_mrmort = nanmean(sd_rmort,2);

sf_mrdie = mean(sf_rdie,2);
sp_mrdie = mean(sp_rdie,2);
sd_mrdie = mean(sd_rdie,2);

sf_mrcon = mean(sf_rcon,2);
sp_mrcon = mean(sp_rcon,2);
sd_mrcon = mean(sd_rcon,2);


%% Save
save([fpath 'Residence_time_means_Climatol_' harv '_' cfile '.mat'],...
  'sf_mrnu','sp_mrnu','sd_mrnu',...
  'sf_mrrec','sp_mrrec','sd_mrrec',...
  'sf_mrgam','sp_mrgam','sd_mrgam',...
  'sf_mrmort','sp_mrmort','sd_mrmort',...
  'sf_mrdie','sp_mrdie','sd_mrdie',...
    'sf_mrcon','sp_mrcon','sd_mrcon','-append')

%% Histograms
edges = -5:0.5:5;
figure(1)
subplot(5,3,1)
histogram(log10(sf_mrnu),edges)
title('SF nu')

subplot(5,3,2)
histogram(log10(sp_mrnu),edges)
title('SP nu')

subplot(5,3,3)
histogram(log10(sd_mrnu),edges)
title('SD nu')

subplot(5,3,4)
histogram(log10(sf_mrrec),edges)
title('SF rec')

subplot(5,3,5)
histogram(log10(sp_mrrec),edges)
title('SP rec')

subplot(5,3,6)
histogram(log10(sd_mrrec),edges)
title('SD rec')

subplot(5,3,7)
histogram(log10(sf_mrgam),edges)
title('SF gam')

subplot(5,3,8)
histogram(log10(sp_mrgam),edges)
title('SP gam')

subplot(5,3,9)
histogram(log10(sd_mrgam),edges)
title('SD gam')

subplot(5,3,10)
histogram(log10(sf_mrmort),edges)
title('SF mort')

subplot(5,3,11)
histogram(log10(sp_mrmort),edges)
title('SP mort')

subplot(5,3,12)
histogram(log10(sd_mrmort),edges)
title('SD mort')

subplot(5,3,13)
histogram(log10(sf_mrdie),edges)
title('SF die')

subplot(5,3,14)
histogram(log10(sp_mrdie),edges)
title('SP die')

subplot(5,3,15)
histogram(log10(sd_mrdie),edges)
title('SD die')


%% Maps
% plot info
[ni,nj]=size(lon);
geolon_t = double(lon);
geolat_t = double(lat);
plotminlat=-90;
plotmaxlat=90;
plotminlon=-280;
plotmaxlon=80;
latlim=[plotminlat plotmaxlat];
lonlim=[plotminlon plotmaxlon];

load coastlines;

%% Plots in space
%nu
Nsf=NaN*ones(ni,nj);
Nsp=NaN*ones(ni,nj);
Nsd=NaN*ones(ni,nj);
%rec
Rsf=NaN*ones(ni,nj);
Rsp=NaN*ones(ni,nj);
Rsd=NaN*ones(ni,nj);
%gam
Gsf=NaN*ones(ni,nj);
Gsp=NaN*ones(ni,nj);
Gsd=NaN*ones(ni,nj);
%mort
Msf=NaN*ones(ni,nj);
Msp=NaN*ones(ni,nj);
Msd=NaN*ones(ni,nj);
%die
Dsf=NaN*ones(ni,nj);
Dsp=NaN*ones(ni,nj);
Dsd=NaN*ones(ni,nj);
%con
Csf=NaN*ones(ni,nj);
Csp=NaN*ones(ni,nj);
Csd=NaN*ones(ni,nj);

%nu
Nsf(ID)=sf_mrnu;
Nsp(ID)=sp_mrnu;
Nsd(ID)=sd_mrnu;
%rec
Rsf(ID)=sf_mrrec;
Rsp(ID)=sp_mrrec;
Rsd(ID)=sd_mrrec;
%gam
Gsf(ID)=sf_mrgam;
Gsp(ID)=sp_mrgam;
Gsd(ID)=sd_mrgam;
%mort
Msf(ID)=sf_mrmort;
Msp(ID)=sp_mrmort;
Msd(ID)=sd_mrmort;
%die
Dsf(ID)=sf_mrdie;
Dsp(ID)=sp_mrdie;
Dsd(ID)=sd_mrdie;
%con
Csf(ID)=sf_mrcon;
Csp(ID)=sp_mrcon;
Csd(ID)=sd_mrcon;

%% 6 plot of SF terms
f3 = figure('Units','inches','Position',[1 3 6.5 7.25]);

%A
subplot('Position',[0.01 0.68 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Nsf))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SF nu','HorizontalAlignment','center')

%B
subplot('Position',[0.41 0.68 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Rsf))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SF rec','HorizontalAlignment','center')

%C
subplot('Position',[0.01 0.37 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Gsf))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SF gamma','HorizontalAlignment','center')

%D
subplot('Position',[0.41 0.37 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Msf))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SF nmort','HorizontalAlignment','center')

%E
subplot('Position',[0.01 0.06 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Dsf))
cmocean('speed')
cb = colorbar('Position',[0.85 0.25 0.025 0.5],'orientation','vertical','AxisLocation','out');
xlabel(cb,'days')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SF pred','HorizontalAlignment','center')

%F
subplot('Position',[0.41 0.06 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Csf))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SF con','HorizontalAlignment','center')
print('-dpng',[ppath 'Climatol_map_mean_partial_res_SF.png'])

%% 6 plot of SP
f4 = figure('Units','inches','Position',[1 3 6.5 7.25]);

%A
subplot('Position',[0.01 0.68 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Nsp))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SP nu','HorizontalAlignment','center')

%B
subplot('Position',[0.41 0.68 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Rsp))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SP rec','HorizontalAlignment','center')

%C
subplot('Position',[0.01 0.37 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Gsp))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SP gamma','HorizontalAlignment','center')

%D
subplot('Position',[0.41 0.37 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Msp))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SP nmort','HorizontalAlignment','center')

%E
subplot('Position',[0.01 0.06 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Dsp))
cmocean('speed')
cb = colorbar('Position',[0.85 0.25 0.025 0.5],'orientation','vertical','AxisLocation','out');
xlabel(cb,'days')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SP pred','HorizontalAlignment','center')

%F
subplot('Position',[0.41 0.06 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Csp))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SP con','HorizontalAlignment','center')

print('-dpng',[ppath 'Climatol_map_mean_partial_res_SP.png'])

%% 6 plot of SD
f5 = figure('Units','inches','Position',[1 3 6.5 7.25]);

%A
subplot('Position',[0.01 0.68 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Nsd))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SD nu','HorizontalAlignment','center')

%B
subplot('Position',[0.41 0.68 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Rsd))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SD rec','HorizontalAlignment','center')

%C
subplot('Position',[0.01 0.37 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Gsd))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SD gamma','HorizontalAlignment','center')

%D
subplot('Position',[0.41 0.37 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Msd))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SD nmort','HorizontalAlignment','center')

%E
subplot('Position',[0.01 0.06 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Dsd))
cmocean('speed')
cb = colorbar('Position',[0.85 0.25 0.025 0.5],'orientation','vertical','AxisLocation','out');
xlabel(cb,'days')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SD pred','HorizontalAlignment','center')

%F
subplot('Position',[0.41 0.06 0.4 0.3])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,(Csd))
cmocean('speed')
h=patchm(coastlat+0.5,coastlon+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([1 365])
set(gcf,'renderer','painters')
text(0,1.75,'SD con','HorizontalAlignment','center')
print('-dpng',[ppath 'Climatol_map_mean_partial_res_SD.png'])

