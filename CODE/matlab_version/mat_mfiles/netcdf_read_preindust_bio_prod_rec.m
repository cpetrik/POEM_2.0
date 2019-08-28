% POEM output at all locations

clear all
close all

%cfile = 'Dc_enc70_cmax-metab20_fcrit20_D075_J100_A050_Sm025_nmort1_BE05_CC050_lgRE00100_mdRE00400';
cfile = 'Dc_enc70-b200_m4-b175-k086_c20-b250_D075_J100_A050_Sm025_nmort1_BE08_noCC_RE00100';

fpath=['/Volumes/GFDL/NC/Matlab_new_size/' cfile '/'];

nt=12*100;

%% SP
ncid = netcdf.open([fpath 'Preindust_sml_p.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

SP.bio = biomass;
SP.prod = prod;
SP.rec = rec;

Sml_p.bio = biomass(:,nt);

clear biomass rec prod

%% SF
ncid = netcdf.open([fpath 'Preindust_sml_f.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

SF.bio = biomass(:,1:nt);
SF.prod = prod(:,1:nt);
SF.rec = rec(:,1:nt);

Sml_f.bio = biomass(:,nt);

clear biomass rec prod

% SD
ncid = netcdf.open([fpath 'Preindust_sml_d.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

SD.bio = biomass;
SD.prod = prod;
SD.rec = rec;

Sml_d.bio = biomass(:,nt);

clear biomass rec prod

%% MP
ncid = netcdf.open([fpath 'Preindust_med_p.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

MP.bio = biomass;
MP.prod = prod;
MP.rec = rec;

Med_p.bio = biomass(:,nt);

clear biomass rec prod

% MF
ncid = netcdf.open([fpath 'Preindust_med_f.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

MF.bio = biomass;
MF.prod = prod;
MF.rec = rec;

Med_f.bio = biomass(:,nt);

clear biomass rec prod

% MD
ncid = netcdf.open([fpath 'Preindust_med_d.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

MD.bio = biomass;
MD.prod = prod;
MD.rec = rec;

Med_d.bio = biomass(:,nt);

clear biomass rec prod

% LP
ncid = netcdf.open([fpath 'Preindust_lrg_p.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

LP.bio = biomass;
LP.prod = prod;
LP.rec = rec;

Lrg_p.bio = biomass(:,nt);

clear biomass rec prod

% LD
ncid = netcdf.open([fpath 'Preindust_lrg_d.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

LD.bio = biomass;
LD.prod = prod;
LD.rec = rec;

Lrg_d.bio = biomass(:,nt);

clear biomass rec prod

% Benthic material
ncid = netcdf.open([fpath 'Preindust_bent.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

Bent.bio = biomass;
BENT.bio = biomass(:,nt);
clear biomass 

%% Take means
nt = length(time);
MNTH = [31,28,31,30,31,30,31,31,30,31,30,31];


%Time
sp_tmean=mean(SP.bio,1);
sf_tmean=mean(SF.bio,1);
sd_tmean=mean(SD.bio,1);
mp_tmean=mean(MP.bio,1);
mf_tmean=mean(MF.bio,1);
md_tmean=mean(MD.bio,1);
lp_tmean=mean(LP.bio,1);
ld_tmean=mean(LD.bio,1);
b_tmean=mean(Bent.bio,1);

sp_tprod=mean(SP.prod,1);
sf_tprod=mean(SF.prod,1);
sd_tprod=mean(SD.prod,1);
mp_tprod=mean(MP.prod,1);
mf_tprod=mean(MF.prod,1);
md_tprod=mean(MD.prod,1);
lp_tprod=mean(LP.prod,1);
ld_tprod=mean(LD.prod,1);

sp_trec=mean(SP.rec,1);
sf_trec=mean(SF.rec,1);
sd_trec=mean(SD.rec,1);
mp_trec=mean(MP.rec,1);
mf_trec=mean(MF.rec,1);
md_trec=mean(MD.rec,1);
lp_trec=mean(LP.rec,1);
ld_trec=mean(LD.rec,1);

% First 50 years of century
y = 1760+(1/12):(1/12):1860;
yr50=find(y>=1801 & y<1851);
%yr50=time((end-(50*12)+1):end);

sp_mean50=mean(SP.bio(:,yr50),2);
sf_mean50=mean(SF.bio(:,yr50),2);
sd_mean50=mean(SD.bio(:,yr50),2);
mp_mean50=mean(MP.bio(:,yr50),2);
mf_mean50=mean(MF.bio(:,yr50),2);
md_mean50=mean(MD.bio(:,yr50),2);
lp_mean50=mean(LP.bio(:,yr50),2);
ld_mean50=mean(LD.bio(:,yr50),2);
b_mean50=mean(Bent.bio(:,yr50),2);

sp_prod50=nanmean(SP.prod(:,yr50),2);
sf_prod50=nanmean(SF.prod(:,yr50),2);
sd_prod50=nanmean(SD.prod(:,yr50),2);
mp_prod50=nanmean(MP.prod(:,yr50),2);
mf_prod50=nanmean(MF.prod(:,yr50),2);
md_prod50=nanmean(MD.prod(:,yr50),2);
lp_prod50=nanmean(LP.prod(:,yr50),2);
ld_prod50=nanmean(LD.prod(:,yr50),2);

sp_rec50=nanmean(SP.rec(:,yr50),2);
sf_rec50=nanmean(SF.rec(:,yr50),2);
sd_rec50=nanmean(SD.rec(:,yr50),2);
mp_rec50=nanmean(MP.rec(:,yr50),2);
mf_rec50=nanmean(MF.rec(:,yr50),2);
md_rec50=nanmean(MD.rec(:,yr50),2);
lp_rec50=nanmean(LP.rec(:,yr50),2);
ld_rec50=nanmean(LD.rec(:,yr50),2);

%% Every year
st=1:12:length(time);
en=12:12:length(time);
for m=1:length(en)
    yr1 = st(m):en(m);
    sp_mean(:,m)=mean(SP.bio(:,yr1),2);
    sf_mean(:,m)=mean(SF.bio(:,yr1),2);
    sd_mean(:,m)=mean(SD.bio(:,yr1),2);
    mp_mean(:,m)=mean(MP.bio(:,yr1),2);
    mf_mean(:,m)=mean(MF.bio(:,yr1),2);
    md_mean(:,m)=mean(MD.bio(:,yr1),2);
    lp_mean(:,m)=mean(LP.bio(:,yr1),2);
    ld_mean(:,m)=mean(LD.bio(:,yr1),2);
    b_mean(:,m)=mean(Bent.bio(:,yr1),2);
end


%% Save means
save([fpath 'Means_preindust_' cfile '.mat'],'time','yr50','y',...
    'sf_mean','sp_mean','sd_mean',...
    'mf_mean','mp_mean','md_mean',...
    'b_mean','lp_mean','ld_mean',...
    'sf_tmean','sp_tmean','sd_tmean',...
    'mf_tmean','mp_tmean','md_tmean',...
    'b_tmean','lp_tmean','ld_tmean',...
    'sf_tprod','sp_tprod','sd_tprod',...
    'mf_tprod','mp_tprod','md_tprod',...
    'lp_tprod','ld_tprod',...
    'sf_trec','sp_trec','sd_trec',...
    'mf_trec','mp_trec','md_trec',...
    'lp_trec','ld_trec',...
    'sf_mean50','sp_mean50','sd_mean50',...
    'mf_mean50','mp_mean50','md_mean50',...
    'b_mean50','lp_mean50','ld_mean50',...
    'sf_prod50','sp_prod50','sd_prod50',...
    'mf_prod50','mp_prod50','md_prod50',...
    'lp_prod50','ld_prod50',...
    'sf_rec50','sp_rec50','sd_rec50',...
    'mf_rec50','mp_rec50','md_rec50',...
    'lp_rec50','ld_rec50');
    
% Save last year for initializing historical runs
save([fpath 'Last_mo_preindust_' cfile '.mat'],'Sml_f','Sml_p','Sml_d',... 
    'Med_f','Med_p','Med_d','Lrg_p','Lrg_d','BENT')


