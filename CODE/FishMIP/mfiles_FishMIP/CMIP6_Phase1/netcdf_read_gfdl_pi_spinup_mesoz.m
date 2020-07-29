% Read Fish-MIP netcdfs
% GFDL PreIndust

clear all
close all

fpath='/Users/cpetrik/Dropbox/ESM_data/Fish-MIP/CMIP6/GFDL/preindust/';

%% Meso Zoop zall
ncdisp([fpath 'gfdl-esm4_r1i1p1f1_picontrol_zmeso_onedeg_global_monthly_1601_2100.nc'])
standard_name = 'mole_concentration_of_mesozooplankton_expressed_as_carbon_in_sea_water';
long_name     = 'Mole Concentration of Mesozooplankton expressed as Carbon in sea water';
units         = 'mol m-3';

%%
ncid = netcdf.open([fpath 'gfdl-esm4_r1i1p1f1_picontrol_zmeso_onedeg_global_monthly_1601_2100.nc'],'NC_NOWRITE');

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
%chl: 360x180x35x6000
%time: 6000
%NaNs = 1.0000e+20

%% Get subset
% Time
yr = ((time+1)/12)+1601-1;
spin = find(yr>1850 & yr<=1950);
% Top 100 m
z100 = find(lev <= 100);

i = nvars;
zmeso = netcdf.getVar(ncid,i-1, [0,0,0,spin(1)-1],[360 180 length(z100) length(spin)]);
zmeso(zmeso >= 1.00e+20) = NaN;
netcdf.close(ncid);

%% Integrate top 100 m
zmeso_100 = squeeze(nansum(zmeso,3));

%%
save([fpath 'gfdl_pi_zmeso100_monthly_1850_1949.mat'],'zmeso_100','time',...
    'yr','spin','long_name','standard_name','units','lev','z100');





