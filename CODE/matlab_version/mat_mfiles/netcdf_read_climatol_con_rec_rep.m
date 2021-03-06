% POEM output at all locations

clear all
close all


%cfile = 'Dc_enc70-b200_m4-b175-k086_c20-b250_D075_J100_A050_Sm025_nmort1_BE08_noCC_RE00100';
cfile = 'Dc_enc70-b200_m4-b175-k086_c20-b250_D075_J100_A050_Sm000_nmort1_BE08_noCC_RE00100';
harv = 'SWmarth_MZ25_All_fish03';
var = '_con_rec_rep';

fpath=['/Volumes/MIP/NC/Matlab_new_size/' cfile '/'];

%% SP
ncid = netcdf.open([fpath 'Climatol_' harv var '_sml_p.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

SP.con = con;
SP.rec = rec;
clear con rec

% SF
ncid = netcdf.open([fpath 'Climatol_' harv var '_sml_f.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

SF.con = con;
SF.rec = rec;
clear con rec

% SD
ncid = netcdf.open([fpath 'Climatol_' harv var '_sml_d.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

SD.con = con;
SD.rec = rec;
clear con rec

% MP
ncid = netcdf.open([fpath 'Climatol_' harv var '_med_p.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

MP.con = con;
MP.rec = rec;
clear con rec

% MF
ncid = netcdf.open([fpath 'Climatol_' harv var '_med_f.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

MF.con = con;
MF.rep = rep;
MF.rec = rec;
clear con rec rep

% MD
ncid = netcdf.open([fpath 'Climatol_' harv var '_med_d.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

MD.con = con;
MD.rec = rec;
clear con rec

% LP
ncid = netcdf.open([fpath 'Climatol_' harv var '_lrg_p.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

LP.con = con;
LP.rep = rep;
LP.rec = rec;
clear con rec rep

% LD
ncid = netcdf.open([fpath 'Climatol_' harv var '_lrg_d.nc'],'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 99999) = NaN;']);
end
netcdf.close(ncid);

LD.con = con;
LD.rep = rep;
LD.rec = rec;
clear con rec rep


%% Take means
[ids,nt] = size(LD.con);

%Time
sp_tmcon=mean(SP.con,1);
sf_tmcon=mean(SF.con,1);
sd_tmcon=mean(SD.con,1);
mp_tmcon=mean(MP.con,1);
mf_tmcon=mean(MF.con,1);
md_tmcon=mean(MD.con,1);
lp_tmcon=mean(LP.con,1);
ld_tmcon=mean(LD.con,1);

sp_tmrec=mean(SP.rec,1);
sf_tmrec=mean(SF.rec,1);
sd_tmrec=mean(SD.rec,1);
mp_tmrec=mean(MP.rec,1);
mf_tmrec=mean(MF.rec,1);
md_tmrec=mean(MD.rec,1);
lp_tmrec=mean(LP.rec,1);
ld_tmrec=mean(LD.rec,1);

mf_tmrep=mean(MF.rep,1);
lp_tmrep=mean(LP.rep,1);
ld_tmrep=mean(LD.rep,1);

%% Last year
time=1:nt;
lyr=time((end-12+1):end);
sp_mcon=mean(SP.con(:,lyr),2);
sf_mcon=mean(SF.con(:,lyr),2);
sd_mcon=mean(SD.con(:,lyr),2);
mp_mcon=mean(MP.con(:,lyr),2);
mf_mcon=mean(MF.con(:,lyr),2);
md_mcon=mean(MD.con(:,lyr),2);
lp_mcon=mean(LP.con(:,lyr),2);
ld_mcon=mean(LD.con(:,lyr),2);

sp_mrec=mean(SP.rec(:,lyr),2);
sf_mrec=mean(SF.rec(:,lyr),2);
sd_mrec=mean(SD.rec(:,lyr),2);
mp_mrec=mean(MP.rec(:,lyr),2);
mf_mrec=mean(MF.rec(:,lyr),2);
md_mrec=mean(MD.rec(:,lyr),2);
lp_mrec=mean(LP.rec(:,lyr),2);
ld_mrec=mean(LD.rec(:,lyr),2);

mf_mrep=mean(MF.rep(:,lyr),2);
lp_mrep=mean(LP.rep(:,lyr),2);
ld_mrep=mean(LD.rep(:,lyr),2);

%% Just last year
sp_rec=SP.rec(:,lyr);
sf_rec=SF.rec(:,lyr);
sd_rec=SD.rec(:,lyr);
mp_rec=MP.rec(:,lyr);
mf_rec=MF.rec(:,lyr);
md_rec=MD.rec(:,lyr);
lp_rec=LP.rec(:,lyr);
ld_rec=LD.rec(:,lyr);

mf_rep=MF.rep(:,lyr);
lp_rep=LP.rep(:,lyr);
ld_rep=LD.rep(:,lyr);

sp_con=SP.con(:,lyr);
sf_con=SF.con(:,lyr);
sd_con=SD.con(:,lyr);
mp_con=MP.con(:,lyr);
mf_con=MF.con(:,lyr);
md_con=MD.con(:,lyr);
lp_con=LP.con(:,lyr);
ld_con=LD.con(:,lyr);

%%
% save([fpath 'Means_Climatol_' harv '_' cfile '.mat'],'sf_mcon',...
%     'sf_tmcon','sp_tmcon','sd_tmcon','mf_tmcon','mp_tmcon',...
%     'md_tmcon','lp_tmcon','ld_tmcon',...
%     'sf_tmrec','sp_tmrec','sd_tmrec','mf_tmrec','mp_tmrec',...
%     'md_tmrec','lp_tmrec','ld_tmrec',...
%     'mf_tmrep','lp_tmrep','ld_tmrep',...
%     'sf_mcon','sp_mcon','sd_mcon','mf_mcon','mp_mcon',...
%     'md_mcon','lp_mcon','ld_mcon',...
%     'sf_mrec','sp_mrec','sd_mrec','mf_mrec','mp_mrec',...
%     'md_mrec','lp_mrec','ld_mrec',...
%     'mf_mrep','lp_mrep','ld_mrep',...
%     'time','lyr','sf_rec','sp_rec','sd_rec',...
%     'mf_rec','mp_rec','md_rec',...
%     'lp_rec','ld_rec','b_rec',...
%     'mf_rep','lp_rep','ld_rep','-append');

save([fpath 'Means',var,'_Climatol_' harv '_' cfile '.mat'],'sf_mcon',...
    'sf_tmcon','sp_tmcon','sd_tmcon','mf_tmcon','mp_tmcon',...
    'md_tmcon','lp_tmcon','ld_tmcon',...
    'sf_tmrec','sp_tmrec','sd_tmrec','mf_tmrec','mp_tmrec',...
    'md_tmrec','lp_tmrec','ld_tmrec',...
    'mf_tmrep','lp_tmrep','ld_tmrep',...
    'sf_mcon','sp_mcon','sd_mcon','mf_mcon','mp_mcon',...
    'md_mcon','lp_mcon','ld_mcon',...
    'sf_mrec','sp_mrec','sd_mrec','mf_mrec','mp_mrec',...
    'md_mrec','lp_mrec','ld_mrec',...
    'mf_mrep','lp_mrep','ld_mrep',...
    'time','lyr','sf_rec','sp_rec','sd_rec',...
    'mf_rec','mp_rec','md_rec',...
    'lp_rec','ld_rec',...
    'mf_rep','lp_rep','ld_rep',...
    'sf_con','sp_con','sd_con',...
    'mf_con','mp_con','md_con',...
    'lp_con','ld_con');







