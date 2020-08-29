% Fraction of zoop hp loss consumed 
% And number of times overconsumed
% Visualize output of FEISTY
% Historic time period (1861-2005) at all locations
% 145 years
% Saved as mat files

clear all
close all

cpath = '/Users/cpetrik/Dropbox/Princeton/POEM_other/grid_cobalt/';
pp = '/Users/cpetrik/Dropbox/Princeton/FEISTY/CODE/Figs/PNG/Matlab_New_sizes/';

%cfile = 'Dc_enc70-b200_m4-b175-k086_c20-b250_D075_A050_nmort1_BE08_noCC_RE00100_noHPloss';
cfile = 'Dc_Lam700_enc6-b200_m400-b175-k086_c19.72-b250_D080_A067_nmort1_BE08_CC80_RE00100';
harv = 'All_fish03';

fpath=['/Volumes/FEISTY/NC/Matlab_new_size/' cfile '/'];
ppath = [pp cfile '/'];
if (~isfolder(ppath))
    mkdir(ppath)
end

load([fpath 'Means_Historic_1meso_encBincr_',harv,'_' cfile '.mat'],...
    'mz_tmfrac','mz_mfrac5','mz_ttf','mz_mtf5','mz_mtf',...
    'bz_tmfrac','bz_mfrac5','bz_ttf','bz_mtf5','bz_mtf');

load('/Users/cpetrik/Dropbox/Princeton/POEM_other/grid_cobalt/hindcast_gridspec.mat',...
    'geolon_t','geolat_t');
grid = csvread([cpath 'grid_csv.csv']);
ID = grid(:,1);
nx = length(ID);

%% Pick which time period mean
% Last year
%Mean fraction
Cmz_smfrac = mz_mfrac5;
Cbz_smfrac = bz_mfrac5;

%Total times it happens over time
Cmz_ttover = mz_ttf/nx;
Cbz_ttover = bz_ttf/nx;

%Total times it happens in last year (12 mos) in space
Cmz_stover5 = mz_mtf5 ./ (12);
Cbz_stover5 = bz_mtf5 ./ (12);

%%
%happens whole year
test=floor(Cbz_stover5);
%histogram(test)
sum(test)/length(test) % = 0

test2=floor(Cmz_stover5);
%histogram(test2)        %     4 /  5 / 6  / 7 / 8
sum(test2)/length(test2) % = 0.08/0.21/0.30/0.35/0.37

%happens >=50% of year
test3=round(Cbz_stover5);
%histogram(test3)
sum(test3)/length(test3) % = 0

test4=round(Cmz_stover5);
%histogram(test4)
sum(test4)/length(test4) % = 0.59/0.74/0.81/0.85/0.88

%% Plot in time
y=(1/12):(1/12):145;
y=y+1860;
figure(1)
plot(y, Cmz_ttover,'r','LineWidth',2); hold on;
plot(y, Cbz_ttover,'b','LineWidth',2); hold on;
xlim([1860 2005])
legend('HPloss','Biom')
xlabel('Years')
ylabel('Fraction of grid cells over-consumed')
print('-dpng',[ppath 'Hist_1meso_encBincr_' harv '_timeseries_zoop_overcon.png'])

%% Plots in space
[ni,nj]=size(geolon_t);
CFmz=NaN*ones(ni,nj);
COmz=NaN*ones(ni,nj);
CFbz=NaN*ones(ni,nj);
CObz=NaN*ones(ni,nj);
COmz5=NaN*ones(ni,nj);
CObz5=NaN*ones(ni,nj);

CFmz(ID)=Cmz_smfrac;
CFbz(ID)=Cbz_smfrac;

COmz(ID)=Cmz_stover5;
CObz(ID)=Cbz_stover5;

save([fpath 'Hist_1meso_encBincr_' harv '_ts_map_zoop_overcon.mat'],...
    'Cmz_ttover','Cbz_ttover','CFmz','COmz','CFbz','CObz');

%% plot info
plotminlat=-90; %Set these bounds for your data
plotmaxlat=90;
plotminlon=-280;
plotmaxlon=80;
latlim=[plotminlat plotmaxlat];
lonlim=[plotminlon plotmaxlon];

cmBP=cbrewer('seq','BuPu',10,'PCHIP');
cmBP2 = cmBP;
cmBP2(11,:) = [0 0 0];

%% 2 plots of both maps
figure(3)
%1 - m frac
subplot('Position',[0.01 0.5 0.9 0.45])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,CFmz)
colormap(cmBP2)
%cmocean('oxy')
load coast;                     %decent looking coastlines
h=patchm(lat+0.5,long+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([0 3.5]);
colorbar
set(gcf,'renderer','painters')
text(0,1.6,'Mean fraction Z hploss consumed','HorizontalAlignment','center')
%text(-2.75,1.75,'A')

%3 - l frac
subplot('Position',[0.01 0.01 0.9 0.45])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,CFbz)
colormap(cmBP2)
load coast;                     %decent looking coastlines
h=patchm(lat+0.5,long+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([0 0.2]);
colorbar
set(gcf,'renderer','painters')
text(0,1.6,'Mean fraction Z biom consumed','HorizontalAlignment','center')
%text(-2.75,1.75,'C')
print('-dpng',[ppath 'Hist_1meso_encBincr_' harv '_global_zoop_fraccon.png'])

%%
figure(4)
subplot('Position',[0.01 0.5 0.9 0.45])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,COmz)
colormap(cmBP)
load coast;                     %decent looking coastlines
h=patchm(lat+0.5,long+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([0 1]);
colorbar
set(gcf,'renderer','painters')
text(0,1.6,'Mean times Z HPloss overconsumed','HorizontalAlignment','center')

subplot('Position',[0.01 0.01 0.9 0.45])
axesm ('Robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,'frame','on',...
    'Grid','off','FLineWidth',1,'origin',[0 -100 0])
surfm(geolat_t,geolon_t,CFmz.*COmz)
colormap(cmBP2)
load coast;                     %decent looking coastlines
h=patchm(lat+0.5,long+0.5,'w','FaceColor',[0.75 0.75 0.75]);
caxis([0 3.5]);
colorbar
set(gcf,'renderer','painters')
text(0,1.6,'Mean frac * Mean times','HorizontalAlignment','center')
print('-dpng',[ppath 'Hist_1meso_encBincr_' harv '_global_zoop_overcon.png'])








