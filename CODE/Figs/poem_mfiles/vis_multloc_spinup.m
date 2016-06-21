% Visualize output of POEM
% Spinup at 100 locations
% 30 years
% Saved as mat files

%clear all
close all

dpath = '/Volumes/GFDL/NC/';
cpath = '/Users/cpetrik/Dropbox/Princeton/POEM_other/grid_cobalt/';
fpath = '/Users/cpetrik/Dropbox/Princeton/POEM_2.0/CODE/Figs/PNG/PDc_TrefO_KHparams_cmax-metab_MFbetterMP4/';

load([dpath 'Data_spinup_pristine.mat']);


%%
[loc,days]=size(SP.bio);
x=1:days;

lyr=x((end-365+1):end);

sp_mean=mean(SP.bio(:,lyr),2);
sf_mean=mean(SF.bio(:,lyr),2);
sd_mean=mean(SD.bio(:,lyr),2);
mp_mean=mean(MP.bio(:,lyr),2);
mf_mean=mean(MF.bio(:,lyr),2);
md_mean=mean(MD.bio(:,lyr),2);
lp_mean=mean(LP.bio(:,lyr),2);
ld_mean=mean(LD.bio(:,lyr),2);

%% Plots in space
grid = csvread([cpath 'grid_csv.csv']);
%fix lon shift
id=find(grid(:,2)<-180);
grid(id,2)=grid(id,2)+360;

x=-180:180;
y=-90:90;
[X,Y]=meshgrid(x,y);

Zsp=griddata(grid(:,2),grid(:,3),sp_mean,X,Y);
Zsf=griddata(grid(:,2),grid(:,3),sf_mean,X,Y);
Zsd=griddata(grid(:,2),grid(:,3),sd_mean,X,Y);
Zmp=griddata(grid(:,2),grid(:,3),mp_mean,X,Y);
Zmf=griddata(grid(:,2),grid(:,3),mf_mean,X,Y);
Zmd=griddata(grid(:,2),grid(:,3),md_mean,X,Y);
Zlp=griddata(grid(:,2),grid(:,3),lp_mean,X,Y);
Zld=griddata(grid(:,2),grid(:,3),ld_mean,X,Y);

%% sp
figure(1)
m_proj('miller','lat',82);
m_pcolor(X,Y,log10(Zsp)); hold on;
shading flat
m_coast('patch',[.5 .5 .5],'edgecolor','none');
m_grid;
title('log10 mean Larval P biomass (g m^-^2)')
colormap('jet') 
colorbar('h')
caxis([-10 2])
print('-dpng',[fpath 'Spinup_global_SP.png'])

%% sf
figure(2)
m_proj('miller','lat',82);
m_pcolor(X,Y,log10(Zsf)); hold on;
shading flat
m_coast('patch',[.5 .5 .5],'edgecolor','none');
m_grid;
title('log10 mean Larval F biomass (g m^-^2)')
colormap('jet') 
colorbar('h')
caxis([-10 2])
print('-dpng',[fpath 'Spinup_global_SF.png'])

%% sd
figure(3)
m_proj('miller','lat',82);
m_pcolor(X,Y,log10(Zsd)); hold on;
shading flat
m_coast('patch',[.5 .5 .5],'edgecolor','none');
m_grid;
title('log10 mean Larval D biomass (g m^-^2)')
colormap('jet') 
colorbar('h')
caxis([-4 2])
print('-dpng',[fpath 'Spinup_global_SD.png'])

%% mp
figure(4)
m_proj('miller','lat',82);
m_pcolor(X,Y,log10(Zmp)); hold on;
shading flat
m_coast('patch',[.5 .5 .5],'edgecolor','none');
m_grid;
title('log10 mean Juvenile P biomass (g m^-^2)')
colormap('jet') 
colorbar('h')
caxis([-8 3])
print('-dpng',[fpath 'Spinup_global_MP.png'])

%% mf
figure(5)
m_proj('miller','lat',82);
m_pcolor(X,Y,log10(Zmf)); hold on;
shading flat
m_coast('patch',[.5 .5 .5],'edgecolor','none');
m_grid;
title('log10 mean Adult F biomass (g m^-^2)')
colormap('jet') 
colorbar('h')
caxis([-10 3])
print('-dpng',[fpath 'Spinup_global_MF.png'])

%% md
figure(6)
m_proj('miller','lat',82);
m_pcolor(X,Y,log10(Zmd)); hold on;
shading flat
m_coast('patch',[.5 .5 .5],'edgecolor','none');
m_grid;
title('log10 mean Juvenile D biomass (g m^-^2)')
colormap('jet') 
colorbar('h')
caxis([-3 3])
print('-dpng',[fpath 'Spinup_global_MD.png'])

%% lp
figure(7)
m_proj('miller','lat',82);
m_pcolor(X,Y,log10(Zlp)); hold on;
shading flat
m_coast('patch',[.5 .5 .5],'edgecolor','none');
m_grid;
title('log10 mean Adult P biomass (g m^-^2)')
colormap('jet') 
colorbar('h')
caxis([-8 3])
print('-dpng',[fpath 'Spinup_global_LP.png'])

%% ld
figure(8)
m_proj('miller','lat',82);
m_pcolor(X,Y,log10(Zld)); hold on;
shading flat
m_coast('patch',[.5 .5 .5],'edgecolor','none');
m_grid;
title('log10 mean Adult D biomass (g m^-^2)')
colormap('jet') 
colorbar('h')
caxis([-3 3])
print('-dpng',[fpath 'Spinup_global_LD.png'])




