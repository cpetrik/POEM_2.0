% Read Fish-MIP netcdfs
% GFDL PreIndust

clear all
close all

fpath='/Users/cpetrik/Dropbox/ESM_data/Fish-MIP/CMIP6/GFDL/preindust/';

%% Meso Zoop zall
ncdisp([fpath 'gfdl-esm4_r1i1p1f1_picontrol_zmicro_onedeg_global_monthly_1601_2100.nc'])
standard_name = 'sea_water_potential_temperature';
long_name     = 'Sea Water Potential Temperature';
units         = 'degC';

%%
ncid = netcdf.open([fpath 'gfdl-esm4_r1i1p1f1_picontrol_zmicro_onedeg_global_monthly_1601_2100.nc'],'NC_NOWRITE');

[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);

% Get all other vars 1st
for i = 1:(nvars-1)
    varname = netcdf.inqVar(ncid, i-1);
    eval([ varname ' = netcdf.getVar(ncid,i-1);']);
    eval([ varname '(' varname ' == 1.000000020040877e+20) = NaN;']);
end

% Vars
%lat: 180
%lon: 360
%lev: 35
%zoo: 360x180x35x6000
%time: 6000
%NaNs = 1.0000e+20

%% Get subset of chl
% Time
yr = ((time+1)/12)+1601-1;
runs = find(yr>1950 & yr<=2100);
z100 = find(lev <= 100);

i = nvars;
zmicro = netcdf.getVar(ncid,i-1, [0,0,0,runs(1)-1],[360 180 length(z100) length(runs)]);
zmicro(zmicro >= 1.00e+20) = NaN;
netcdf.close(ncid);

%% Mean top 100 m 
zmicro_100 = squeeze(nanmean(zmicro,3));

%%
save([fpath 'gfdl_pi_zmicro100_monthly_1950_2100.mat'],'zmicro_100','time',...
    'yr','runs','long_name','standard_name','units','lev','z100');





