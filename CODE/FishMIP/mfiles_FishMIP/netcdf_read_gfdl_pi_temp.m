% Read Fish-MIP CESM PreIndustrial netcdfs
% Mean over top 100 m for temperature

clear all
close all

fpath='/Volumes/FEISTY/Fish-MIP/GFDL/PreIndust/';
cpath='/Volumes/GFDL/Fish-MIP/GFDL/PreIndust/';

tstart = 186101:1000:210001;
tend = 187012:1000:210912;

%each file has 10 years of 12 months
mos = 10*12*(length(tstart));
mod_time = nan(mos,1);
tbnds = nan(2,mos);
tp_100 = nan(360,180,mos);

mstart = 1:120:mos;
mend = 120:120:mos;

%%
for t=1:length(tstart)
ncid = netcdf.open([fpath 'gfdl-esm2m_pi_to_zall_monthly_',num2str(tstart(t)),'-',...
    num2str(tend(t)),'.nc'],'NC_NOWRITE');

[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);

for i = 1:nvars
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    %eval([ varname '(' varname ' == 9.96921e+36) = NaN;']);
end
netcdf.close(ncid);

%NaNs on land cells
to(to>=1e+20)=nan;
%top 100 m
tp100 = to(:,:,1:10,:);
%integrated over top 100m
itp100 = squeeze(nanmean(tp100,3));

%concatenate
mod_time(mstart(t):mend(t)) = time;
tbnds(:,mstart(t):mend(t)) = time_bnds;
tp_100(:,:,mstart(t):mend(t)) = itp100;

clear to time time_bnds 

end

save([fpath 'gfdl-esm2m_pi_tp_100_monthly_',num2str(tstart(1)),'-',...
    num2str(tend(end)),'.mat'],'tp_100','mod_time','tbnds');
save([cpath 'gfdl-esm2m_pi_tp_100_monthly_',num2str(tstart(1)),'-',...
    num2str(tend(end)),'.mat'],'tp_100','mod_time','tbnds');




