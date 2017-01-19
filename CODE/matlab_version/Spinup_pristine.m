%%%%!! RUN SPINUP FOR ALL LOCATIONS
function Spinup_pristine()

	%%%%%%%%%%%%%%% Initialize Model Variables
	%! Make parameters
	make_parameters(0) % make core parameters/constants

	%! setup spinup (loop first year of COBALT)
	COBALT = load('/Volumes/GFDL/POEM_JLD/Data_hindcast_PC_000120.jld'); % 1980
	%! Add phenology params from csv file with ID as row
	Tref = readdlm('./Data/grid_phenol_T0raw_NOflip.csv',','); %min temp for each yr at each location
	%global TrefP = readdlm('./Data/grid_phenol_T0p_clim_min_NOflip.csv',','); %1901-1950 climatological min temp at each location for upper 100m
	%global TrefB = readdlm('./Data/grid_phenol_T0b_clim_min_NOflip.csv',','); %1901-1950 climatological min temp at each location for bottom
	global TrefP = Tref
	global TrefB = Tref
	global Dthresh = readdlm('./Data/grid_phenol_DTraw_NOflip.csv',',');
	global Sp = readdlm('./Data/Gaussian_spawn_2mo.csv',',');
	global GRD = load('./Data/Data_grid_hindcast_NOTflipped.jld')
	YEARS = 50
  global DAYS = 365

	%! choose where and when to run the model
	const global NX = 48111
	const global ID = collect(1:NX);

	%! Storage variables
	simname = 'Dc_TrefO_JC_all_MFeqMP_MZ01_nmort_BE05_RE001';

	S_Bent_bio = zeros(NX,DAYS);

	S_Sml_f = zeros(NX,DAYS);
	S_Sml_p = zeros(NX,DAYS);
	S_Sml_d = zeros(NX,DAYS);
	S_Med_f = zeros(NX,DAYS);
	S_Med_p = zeros(NX,DAYS);
	S_Med_d = zeros(NX,DAYS);
	S_Lrg_p = zeros(NX,DAYS);
	S_Lrg_d = zeros(NX,DAYS);

	S_Sml_f_rec = zeros(NX,DAYS);
	S_Sml_p_rec = zeros(NX,DAYS);
	S_Sml_d_rec = zeros(NX,DAYS);
	S_Med_f_rec = zeros(NX,DAYS);
	S_Med_p_rec = zeros(NX,DAYS);
	S_Med_d_rec = zeros(NX,DAYS);
	S_Lrg_p_rec = zeros(NX,DAYS);
	S_Lrg_d_rec = zeros(NX,DAYS);

	S_Sml_f_con = zeros(NX,DAYS);
	S_Sml_p_con = zeros(NX,DAYS);
	S_Sml_d_con = zeros(NX,DAYS);
	S_Med_f_con = zeros(NX,DAYS);
	S_Med_p_con = zeros(NX,DAYS);
	S_Med_d_con = zeros(NX,DAYS);
	S_Lrg_p_con = zeros(NX,DAYS);
	S_Lrg_d_con = zeros(NX,DAYS);

	S_Sml_f_nu = zeros(NX,DAYS);
	S_Sml_p_nu = zeros(NX,DAYS);
	S_Sml_d_nu = zeros(NX,DAYS);
	S_Med_f_nu = zeros(NX,DAYS);
	S_Med_p_nu = zeros(NX,DAYS);
	S_Med_d_nu = zeros(NX,DAYS);
	S_Lrg_p_nu = zeros(NX,DAYS);
	S_Lrg_d_nu = zeros(NX,DAYS);

	S_Sml_f_prod = zeros(NX,DAYS);
	S_Sml_p_prod = zeros(NX,DAYS);
	S_Sml_d_prod = zeros(NX,DAYS);
	S_Med_f_prod = zeros(NX,DAYS);
	S_Med_p_prod = zeros(NX,DAYS);
	S_Med_d_prod = zeros(NX,DAYS);
	S_Lrg_p_prod = zeros(NX,DAYS);
	S_Lrg_d_prod = zeros(NX,DAYS);

	S_Sml_f_gamma = zeros(NX,DAYS);
	S_Sml_p_gamma = zeros(NX,DAYS);
	S_Sml_d_gamma = zeros(NX,DAYS);
	S_Med_f_gamma = zeros(NX,DAYS);
	S_Med_p_gamma = zeros(NX,DAYS);
	S_Med_d_gamma = zeros(NX,DAYS);
	S_Lrg_p_gamma = zeros(NX,DAYS);
	S_Lrg_d_gamma = zeros(NX,DAYS);

	S_Sml_f_rep = zeros(NX,DAYS);
	S_Sml_p_rep = zeros(NX,DAYS);
	S_Sml_d_rep = zeros(NX,DAYS);
	S_Med_f_rep = zeros(NX,DAYS);
	S_Med_p_rep = zeros(NX,DAYS);
	S_Med_d_rep = zeros(NX,DAYS);
	S_Lrg_p_rep = zeros(NX,DAYS);
	S_Lrg_d_rep = zeros(NX,DAYS);

	S_Sml_f_egg = zeros(NX,DAYS);
	S_Sml_p_egg = zeros(NX,DAYS);
	S_Sml_d_egg = zeros(NX,DAYS);
	S_Med_f_egg = zeros(NX,DAYS);
	S_Med_p_egg = zeros(NX,DAYS);
	S_Med_d_egg = zeros(NX,DAYS);
	S_Lrg_p_egg = zeros(NX,DAYS);
	S_Lrg_d_egg = zeros(NX,DAYS);

	S_Sml_f_die = zeros(NX,DAYS);
	S_Sml_p_die = zeros(NX,DAYS);
	S_Sml_d_die = zeros(NX,DAYS);
	S_Med_f_die = zeros(NX,DAYS);
	S_Med_p_die = zeros(NX,DAYS);
	S_Med_d_die = zeros(NX,DAYS);
	S_Lrg_p_die = zeros(NX,DAYS);
	S_Lrg_d_die = zeros(NX,DAYS);

	S_Sml_f_clev = zeros(NX,DAYS);
	S_Sml_p_clev = zeros(NX,DAYS);
	S_Sml_d_clev = zeros(NX,DAYS);
	S_Med_f_clev = zeros(NX,DAYS);
	S_Med_p_clev = zeros(NX,DAYS);
	S_Med_d_clev = zeros(NX,DAYS);
	S_Lrg_p_clev = zeros(NX,DAYS);
	S_Lrg_d_clev = zeros(NX,DAYS);

	S_Sml_f_S = zeros(NX,DAYS);
	S_Sml_p_S = zeros(NX,DAYS);
	S_Sml_d_S = zeros(NX,DAYS);
	S_Med_f_S = zeros(NX,DAYS);
	S_Med_p_S = zeros(NX,DAYS);
	S_Med_d_S = zeros(NX,DAYS);
	S_Lrg_p_S = zeros(NX,DAYS);
	S_Lrg_d_S = zeros(NX,DAYS);

	S_Sml_f_DD = zeros(NX,DAYS);
	S_Sml_p_DD = zeros(NX,DAYS);
	S_Sml_d_DD = zeros(NX,DAYS);
	S_Med_f_DD = zeros(NX,DAYS);
	S_Med_p_DD = zeros(NX,DAYS);
	S_Med_d_DD = zeros(NX,DAYS);
	S_Lrg_p_DD = zeros(NX,DAYS);
	S_Lrg_d_DD = zeros(NX,DAYS);

	%! Initialize
	phen=0;
	Sml_f, Sml_p, Sml_d, Med_f, Med_p, Med_d, Lrg_p, Lrg_d, BENT = sub_init_fish(ID,phen);
	Med_d.td(1:NX) = 0.0;
	Lrg_d.td(1:NX) = 0.0;
	ENVR = sub_init_env(ID);

	%%%%%%%%%%%%%%% Setup NetCDF save
	% %! Init netcdf file for storage
	% %biomatts = {'longname' => 'Biomass','units' => 'kg/m^2'}
	% %X_atts = {'longname' => 'Space', 'units' => 'grid cell'}
	% %timatts = {'longname' => 'Time', 'units' => 'hours since 01-01-2000 00:00:00'}
	% %Use 'Dict{Any,Any}(a=>b, ...)' instead.
	biomatts = Dict('longname' => 'Biomass',
	         'units'    => 'g/m^2')
	X_atts = Dict('longname' => 'Space',
			'units'    => 'grid cell')
	timatts = Dict('longname' => 'Time',
			'units'    => 'days since 01-01-1980 00:00:00')
	specatts = Dict('longname' => 'Biomass rate',
			         'units'    => 'g/g/day')
	fracatts = Dict('longname' => 'Fraction',
			'units'    => 'unitless')
	DDatts = Dict('longname' => 'Cumulative degree days',
			'units'    => 'degrees Celsius')

	% %! Init dims of netcdf file
	X   = collect(1:NX);
	tim = collect(1:DAYS);

	% %! setup netcdf path to store to
	file_sml_f = string('/Volumes/GFDL/NC/',simname, '/Data_spinup_pristine_sml_f.nc')
	file_sml_p = string('/Volumes/GFDL/NC/',simname, '/Data_spinup_pristine_sml_p.nc')
	file_sml_d = string('/Volumes/GFDL/NC/',simname, '/Data_spinup_pristine_sml_d.nc')
	file_med_f = string('/Volumes/GFDL/NC/',simname, '/Data_spinup_pristine_med_f.nc')
	file_med_p = string('/Volumes/GFDL/NC/',simname, '/Data_spinup_pristine_med_p.nc')
	file_med_d = string('/Volumes/GFDL/NC/',simname, '/Data_spinup_pristine_med_d.nc')
	file_lrg_p = string('/Volumes/GFDL/NC/',simname, '/Data_spinup_pristine_lrg_p.nc')
	file_lrg_d = string('/Volumes/GFDL/NC/',simname, '/Data_spinup_pristine_lrg_d.nc')
	file_bent = string('/Volumes/GFDL/NC/',simname, '/Data_spinup_pristine_bent.nc')

	% %! remove if already in existence
	isfile(file_sml_f) ? rm(file_sml_f) : nothing
	isfile(file_sml_p) ? rm(file_sml_p) : nothing
	isfile(file_sml_d) ? rm(file_sml_d) : nothing
	isfile(file_med_f) ? rm(file_med_f) : nothing
	isfile(file_med_p) ? rm(file_med_p) : nothing
	isfile(file_med_d) ? rm(file_med_d) : nothing
	isfile(file_lrg_p) ? rm(file_lrg_p) : nothing
	isfile(file_lrg_d) ? rm(file_lrg_d) : nothing
	isfile(file_bent) ? rm(file_bent) : nothing

	nccreate(file_sml_f,'biomass','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_sml_p,'biomass','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_sml_d,'biomass','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_med_f,'biomass','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_med_p,'biomass','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_med_d,'biomass','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_lrg_p,'biomass','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_lrg_d,'biomass','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_bent,'biomass','X',X,X_atts,'time',tim,timatts,atts=biomatts);

	nccreate(file_sml_f,'prod','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_sml_p,'prod','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_sml_d,'prod','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_med_f,'prod','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_med_p,'prod','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_med_d,'prod','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_lrg_p,'prod','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_lrg_d,'prod','X',X,X_atts,'time',tim,timatts,atts=biomatts);

	nccreate(file_sml_f,'rec','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_sml_p,'rec','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_sml_d,'rec','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_med_f,'rec','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_med_p,'rec','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_med_d,'rec','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_lrg_p,'rec','X',X,X_atts,'time',tim,timatts,atts=biomatts);
	nccreate(file_lrg_d,'rec','X',X,X_atts,'time',tim,timatts,atts=biomatts);

	nccreate(file_sml_f,'con','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_p,'con','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_d,'con','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_f,'con','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_p,'con','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_d,'con','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_p,'con','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_d,'con','X',X,X_atts,'time',tim,timatts,atts=specatts);

	nccreate(file_sml_f,'nu','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_p,'nu','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_d,'nu','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_f,'nu','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_p,'nu','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_d,'nu','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_p,'nu','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_d,'nu','X',X,X_atts,'time',tim,timatts,atts=specatts);

	nccreate(file_sml_f,'gamma','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_p,'gamma','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_d,'gamma','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_f,'gamma','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_p,'gamma','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_d,'gamma','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_p,'gamma','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_d,'gamma','X',X,X_atts,'time',tim,timatts,atts=specatts);

	nccreate(file_sml_f,'rep','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_p,'rep','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_d,'rep','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_f,'rep','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_p,'rep','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_d,'rep','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_p,'rep','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_d,'rep','X',X,X_atts,'time',tim,timatts,atts=specatts);

	nccreate(file_sml_f,'egg','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_p,'egg','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_d,'egg','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_f,'egg','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_p,'egg','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_d,'egg','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_p,'egg','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_d,'egg','X',X,X_atts,'time',tim,timatts,atts=specatts);

	nccreate(file_sml_f,'die','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_p,'die','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_sml_d,'die','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_f,'die','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_p,'die','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_med_d,'die','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_p,'die','X',X,X_atts,'time',tim,timatts,atts=specatts);
	nccreate(file_lrg_d,'die','X',X,X_atts,'time',tim,timatts,atts=specatts);

	nccreate(file_sml_f,'clev','X',X,X_atts,'time',tim,timatts,atts=fracatts);
	nccreate(file_sml_p,'clev','X',X,X_atts,'time',tim,timatts,atts=fracatts);
	nccreate(file_sml_d,'clev','X',X,X_atts,'time',tim,timatts,atts=fracatts);
	nccreate(file_med_f,'clev','X',X,X_atts,'time',tim,timatts,atts=fracatts);
	nccreate(file_med_p,'clev','X',X,X_atts,'time',tim,timatts,atts=fracatts);
	nccreate(file_med_d,'clev','X',X,X_atts,'time',tim,timatts,atts=fracatts);
	nccreate(file_lrg_p,'clev','X',X,X_atts,'time',tim,timatts,atts=fracatts);
	nccreate(file_lrg_d,'clev','X',X,X_atts,'time',tim,timatts,atts=fracatts);

	nccreate(file_sml_f,'S','X',X,X_atts,'time',tim,timatts,atts=fracatts)
	nccreate(file_sml_p,'S','X',X,X_atts,'time',tim,timatts,atts=fracatts)
	nccreate(file_sml_d,'S','X',X,X_atts,'time',tim,timatts,atts=fracatts)
	nccreate(file_med_f,'S','X',X,X_atts,'time',tim,timatts,atts=fracatts)
	nccreate(file_med_p,'S','X',X,X_atts,'time',tim,timatts,atts=fracatts)
	nccreate(file_med_d,'S','X',X,X_atts,'time',tim,timatts,atts=fracatts)
	nccreate(file_lrg_p,'S','X',X,X_atts,'time',tim,timatts,atts=fracatts)
	nccreate(file_lrg_d,'S','X',X,X_atts,'time',tim,timatts,atts=fracatts)

	nccreate(file_sml_f,'DD','X',X,X_atts,'time',tim,timatts,atts=DDatts)
	nccreate(file_sml_p,'DD','X',X,X_atts,'time',tim,timatts,atts=DDatts)
	nccreate(file_sml_d,'DD','X',X,X_atts,'time',tim,timatts,atts=DDatts)
	nccreate(file_med_f,'DD','X',X,X_atts,'time',tim,timatts,atts=DDatts)
	nccreate(file_med_p,'DD','X',X,X_atts,'time',tim,timatts,atts=DDatts)
	nccreate(file_med_d,'DD','X',X,X_atts,'time',tim,timatts,atts=DDatts)
	nccreate(file_lrg_p,'DD','X',X,X_atts,'time',tim,timatts,atts=DDatts)
	nccreate(file_lrg_d,'DD','X',X,X_atts,'time',tim,timatts,atts=DDatts)

	% %! Initializing netcdf files
	println('Initializing file system (takes about 5 minutes)')
	ncwrite(zeros(NX,1),file_sml_f,'biomass',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'biomass',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'biomass',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'biomass',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'biomass',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'biomass',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'biomass',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'biomass',(1,1))
	ncwrite(zeros(NX,1),file_bent,'biomass',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'prod',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'prod',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'prod',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'prod',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'prod',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'prod',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'prod',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'prod',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'con',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'con',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'con',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'con',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'con',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'con',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'con',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'con',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'rec',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'rec',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'rec',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'rec',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'rec',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'rec',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'rec',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'rec',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'nu',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'nu',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'nu',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'nu',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'nu',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'nu',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'nu',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'nu',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'gamma',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'gamma',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'gamma',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'gamma',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'gamma',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'gamma',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'gamma',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'gamma',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'rep',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'rep',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'rep',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'rep',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'rep',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'rep',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'rep',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'rep',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'egg',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'egg',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'egg',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'egg',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'egg',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'egg',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'egg',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'egg',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'die',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'die',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'die',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'die',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'die',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'die',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'die',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'die',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'clev',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'clev',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'clev',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'clev',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'clev',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'clev',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'clev',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'clev',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'S',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'S',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'S',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'S',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'S',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'S',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'S',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'S',(1,1))

	ncwrite(zeros(NX,1),file_sml_f,'DD',(1,1))
	ncwrite(zeros(NX,1),file_sml_p,'DD',(1,1))
	ncwrite(zeros(NX,1),file_sml_d,'DD',(1,1))
	ncwrite(zeros(NX,1),file_med_f,'DD',(1,1))
	ncwrite(zeros(NX,1),file_med_p,'DD',(1,1))
	ncwrite(zeros(NX,1),file_med_d,'DD',(1,1))
	ncwrite(zeros(NX,1),file_lrg_p,'DD',(1,1))
	ncwrite(zeros(NX,1),file_lrg_d,'DD',(1,1))

	%%%%%%%%%%%%%%%%%%%%%% Run the Model
	%! Run model with no fishing
	for YR = 1:YEARS % years

		%reset spawning flag
		if (phen == 1)
			Med_f.S = zeros(Float64,NX,DAYS)
			Lrg_d.S = zeros(Float64,NX,DAYS)
			Lrg_p.S = zeros(Float64,NX,DAYS)
		end

		for DAY = 1:DT:DAYS % days

			%%%! Future time step
			DY  = Int(ceil(DAY))
			println(YR,' , ', mod(DY,365))
			sub_futbio!(ID,DY,COBALT,ENVR,Sml_f,Sml_p,Sml_d,Med_f,Med_p,Med_d,Lrg_p,Lrg_d,BENT);

			if (YR == YEARS)
				%%%%%%%%%%%%%%%%%%%%% Clean up
				%! Store last year of spinup
				for i = 1:NX
					S_Bent_bio(i,DY) = BENT.mass(i)

					S_Sml_f(i,DY) = Sml_f.bio(i)
					S_Sml_p(i,DY) = Sml_p.bio(i)
					S_Sml_d(i,DY) = Sml_d.bio(i)
					S_Med_f(i,DY) = Med_f.bio(i)
					S_Med_p(i,DY) = Med_p.bio(i)
					S_Med_d(i,DY) = Med_d.bio(i)
					S_Lrg_p(i,DY) = Lrg_p.bio(i)
					S_Lrg_d(i,DY) = Lrg_d.bio(i)

					S_Sml_f_rec(i,DY) = Sml_f.rec(i)
					S_Sml_p_rec(i,DY) = Sml_p.rec(i)
					S_Sml_d_rec(i,DY) = Sml_d.rec(i)
					S_Med_f_rec(i,DY) = Med_f.rec(i)
					S_Med_p_rec(i,DY) = Med_p.rec(i)
					S_Med_d_rec(i,DY) = Med_d.rec(i)
					S_Lrg_p_rec(i,DY) = Lrg_p.rec(i)
					S_Lrg_d_rec(i,DY) = Lrg_d.rec(i)

					S_Sml_f_con(i,DY) = Sml_f.I(i)
					S_Sml_p_con(i,DY) = Sml_p.I(i)
					S_Sml_d_con(i,DY) = Sml_d.I(i)
					S_Med_f_con(i,DY) = Med_f.I(i)
					S_Med_p_con(i,DY) = Med_p.I(i)
					S_Med_d_con(i,DY) = Med_d.I(i)
					S_Lrg_p_con(i,DY) = Lrg_p.I(i)
					S_Lrg_d_con(i,DY) = Lrg_d.I(i)

					S_Sml_f_nu(i,DY) = Sml_f.nu(i)
					S_Sml_p_nu(i,DY) = Sml_p.nu(i)
					S_Sml_d_nu(i,DY) = Sml_d.nu(i)
					S_Med_f_nu(i,DY) = Med_f.nu(i)
					S_Med_p_nu(i,DY) = Med_p.nu(i)
					S_Med_d_nu(i,DY) = Med_d.nu(i)
					S_Lrg_p_nu(i,DY) = Lrg_p.nu(i)
					S_Lrg_d_nu(i,DY) = Lrg_d.nu(i)

					S_Sml_f_prod(i,DY) = Sml_f.prod(i)
					S_Sml_p_prod(i,DY) = Sml_p.prod(i)
					S_Sml_d_prod(i,DY) = Sml_d.prod(i)
					S_Med_f_prod(i,DY) = Med_f.prod(i)
					S_Med_p_prod(i,DY) = Med_p.prod(i)
					S_Med_d_prod(i,DY) = Med_d.prod(i)
					S_Lrg_p_prod(i,DY) = Lrg_p.prod(i)
					S_Lrg_d_prod(i,DY) = Lrg_d.prod(i)

					S_Sml_f_gamma(i,DY) = Sml_f.gamma(i)
					S_Sml_p_gamma(i,DY) = Sml_p.gamma(i)
					S_Sml_d_gamma(i,DY) = Sml_d.gamma(i)
					S_Med_f_gamma(i,DY) = Med_f.gamma(i)
					S_Med_p_gamma(i,DY) = Med_p.gamma(i)
					S_Med_d_gamma(i,DY) = Med_d.gamma(i)
					S_Lrg_p_gamma(i,DY) = Lrg_p.gamma(i)
					S_Lrg_d_gamma(i,DY) = Lrg_d.gamma(i)

					S_Sml_f_rep(i,DY) = Sml_f.rep(i)
					S_Sml_p_rep(i,DY) = Sml_p.rep(i)
					S_Sml_d_rep(i,DY) = Sml_d.rep(i)
					S_Med_f_rep(i,DY) = Med_f.rep(i)
					S_Med_p_rep(i,DY) = Med_p.rep(i)
					S_Med_d_rep(i,DY) = Med_d.rep(i)
					S_Lrg_p_rep(i,DY) = Lrg_p.rep(i)
					S_Lrg_d_rep(i,DY) = Lrg_d.rep(i)

					S_Sml_f_egg(i,DY) = Sml_f.egg(i)
					S_Sml_p_egg(i,DY) = Sml_p.egg(i)
					S_Sml_d_egg(i,DY) = Sml_d.egg(i)
					S_Med_f_egg(i,DY) = Med_f.egg(i)
					S_Med_p_egg(i,DY) = Med_p.egg(i)
					S_Med_d_egg(i,DY) = Med_d.egg(i)
					S_Lrg_p_egg(i,DY) = Lrg_p.egg(i)
					S_Lrg_d_egg(i,DY) = Lrg_d.egg(i)

					S_Sml_f_die(i,DY) = Sml_f.die(i)
					S_Sml_p_die(i,DY) = Sml_p.die(i)
					S_Sml_d_die(i,DY) = Sml_d.die(i)
					S_Med_f_die(i,DY) = Med_f.die(i)
					S_Med_p_die(i,DY) = Med_p.die(i)
					S_Med_d_die(i,DY) = Med_d.die(i)
					S_Lrg_p_die(i,DY) = Lrg_p.die(i)
					S_Lrg_d_die(i,DY) = Lrg_d.die(i)

					S_Sml_f_clev(i,DY) = Sml_f.clev(i)
					S_Sml_p_clev(i,DY) = Sml_p.clev(i)
					S_Sml_d_clev(i,DY) = Sml_d.clev(i)
					S_Med_f_clev(i,DY) = Med_f.clev(i)
					S_Med_p_clev(i,DY) = Med_p.clev(i)
					S_Med_d_clev(i,DY) = Med_d.clev(i)
					S_Lrg_p_clev(i,DY) = Lrg_p.clev(i)
					S_Lrg_d_clev(i,DY) = Lrg_d.clev(i)

					S_Sml_f_S(i,DY) = Sml_f.S(i)
					S_Sml_p_S(i,DY) = Sml_p.S(i)
					S_Sml_d_S(i,DY) = Sml_d.S(i)
					S_Med_f_S(i,DY) = Med_f.S(i)
					S_Med_p_S(i,DY) = Med_p.S(i)
					S_Med_d_S(i,DY) = Med_d.S(i)
					S_Lrg_p_S(i,DY) = Lrg_p.S(i)
					S_Lrg_d_S(i,DY) = Lrg_d.S(i)

					S_Sml_f_DD(i,DY) = Sml_f.DD(i)
					S_Sml_p_DD(i,DY) = Sml_p.DD(i)
					S_Sml_d_DD(i,DY) = Sml_d.DD(i)
					S_Med_f_DD(i,DY) = Med_f.DD(i)
					S_Med_p_DD(i,DY) = Med_p.DD(i)
					S_Med_d_DD(i,DY) = Med_d.DD(i)
					S_Lrg_p_DD(i,DY) = Lrg_p.DD(i)
					S_Lrg_d_DD(i,DY) = Lrg_d.DD(i)

				end %Grid cells
			end %If last year

		end %Days

	end %Years

	%! Save
	ncwrite(S_Bent_bio,file_bent,'biomass',(1,1))

	ncwrite(S_Sml_f,file_sml_f,'biomass',(1,1))
	ncwrite(S_Sml_p,file_sml_p,'biomass',(1,1))
	ncwrite(S_Sml_d,file_sml_d,'biomass',(1,1))
	ncwrite(S_Med_f,file_med_f,'biomass',(1,1))
	ncwrite(S_Med_p,file_med_p,'biomass',(1,1))
	ncwrite(S_Med_d,file_med_d,'biomass',(1,1))
	ncwrite(S_Lrg_p,file_lrg_p,'biomass',(1,1))
	ncwrite(S_Lrg_d,file_lrg_d,'biomass',(1,1))

	ncwrite(S_Sml_f_rec,file_sml_f,'rec',(1,1))
	ncwrite(S_Sml_p_rec,file_sml_p,'rec',(1,1))
	ncwrite(S_Sml_d_rec,file_sml_d,'rec',(1,1))
	ncwrite(S_Med_f_rec,file_med_f,'rec',(1,1))
	ncwrite(S_Med_p_rec,file_med_p,'rec',(1,1))
	ncwrite(S_Med_d_rec,file_med_d,'rec',(1,1))
	ncwrite(S_Lrg_p_rec,file_lrg_p,'rec',(1,1))
	ncwrite(S_Lrg_d_rec,file_lrg_d,'rec',(1,1))

	ncwrite(S_Sml_f_con,file_sml_f,'con',(1,1))
	ncwrite(S_Sml_p_con,file_sml_p,'con',(1,1))
	ncwrite(S_Sml_d_con,file_sml_d,'con',(1,1))
	ncwrite(S_Med_f_con,file_med_f,'con',(1,1))
	ncwrite(S_Med_p_con,file_med_p,'con',(1,1))
	ncwrite(S_Med_d_con,file_med_d,'con',(1,1))
	ncwrite(S_Lrg_p_con,file_lrg_p,'con',(1,1))
	ncwrite(S_Lrg_d_con,file_lrg_d,'con',(1,1))

	ncwrite(S_Sml_f_nu,file_sml_f,'nu',(1,1))
	ncwrite(S_Sml_p_nu,file_sml_p,'nu',(1,1))
	ncwrite(S_Sml_d_nu,file_sml_d,'nu',(1,1))
	ncwrite(S_Med_f_nu,file_med_f,'nu',(1,1))
	ncwrite(S_Med_p_nu,file_med_p,'nu',(1,1))
	ncwrite(S_Med_d_nu,file_med_d,'nu',(1,1))
	ncwrite(S_Lrg_p_nu,file_lrg_p,'nu',(1,1))
	ncwrite(S_Lrg_d_nu,file_lrg_d,'nu',(1,1))

	ncwrite(S_Sml_f_prod,file_sml_f,'prod',(1,1))
	ncwrite(S_Sml_p_prod,file_sml_p,'prod',(1,1))
	ncwrite(S_Sml_d_prod,file_sml_d,'prod',(1,1))
	ncwrite(S_Med_f_prod,file_med_f,'prod',(1,1))
	ncwrite(S_Med_p_prod,file_med_p,'prod',(1,1))
	ncwrite(S_Med_d_prod,file_med_d,'prod',(1,1))
	ncwrite(S_Lrg_p_prod,file_lrg_p,'prod',(1,1))
	ncwrite(S_Lrg_d_prod,file_lrg_d,'prod',(1,1))

	ncwrite(S_Sml_f_gamma,file_sml_f,'gamma',(1,1))
	ncwrite(S_Sml_p_gamma,file_sml_p,'gamma',(1,1))
	ncwrite(S_Sml_d_gamma,file_sml_d,'gamma',(1,1))
	ncwrite(S_Med_f_gamma,file_med_f,'gamma',(1,1))
	ncwrite(S_Med_p_gamma,file_med_p,'gamma',(1,1))
	ncwrite(S_Med_d_gamma,file_med_d,'gamma',(1,1))
	ncwrite(S_Lrg_p_gamma,file_lrg_p,'gamma',(1,1))
	ncwrite(S_Lrg_d_gamma,file_lrg_d,'gamma',(1,1))

	ncwrite(S_Sml_f_rep,file_sml_f,'rep',(1,1))
	ncwrite(S_Sml_p_rep,file_sml_p,'rep',(1,1))
	ncwrite(S_Sml_d_rep,file_sml_d,'rep',(1,1))
	ncwrite(S_Med_f_rep,file_med_f,'rep',(1,1))
	ncwrite(S_Med_p_rep,file_med_p,'rep',(1,1))
	ncwrite(S_Med_d_rep,file_med_d,'rep',(1,1))
	ncwrite(S_Lrg_p_rep,file_lrg_p,'rep',(1,1))
	ncwrite(S_Lrg_d_rep,file_lrg_d,'rep',(1,1))

	ncwrite(S_Sml_f_egg,file_sml_f,'egg',(1,1))
	ncwrite(S_Sml_p_egg,file_sml_p,'egg',(1,1))
	ncwrite(S_Sml_d_egg,file_sml_d,'egg',(1,1))
	ncwrite(S_Med_f_egg,file_med_f,'egg',(1,1))
	ncwrite(S_Med_p_egg,file_med_p,'egg',(1,1))
	ncwrite(S_Med_d_egg,file_med_d,'egg',(1,1))
	ncwrite(S_Lrg_p_egg,file_lrg_p,'egg',(1,1))
	ncwrite(S_Lrg_d_egg,file_lrg_d,'egg',(1,1))

	ncwrite(S_Sml_f_die,file_sml_f,'die',(1,1))
	ncwrite(S_Sml_p_die,file_sml_p,'die',(1,1))
	ncwrite(S_Sml_d_die,file_sml_d,'die',(1,1))
	ncwrite(S_Med_f_die,file_med_f,'die',(1,1))
	ncwrite(S_Med_p_die,file_med_p,'die',(1,1))
	ncwrite(S_Med_d_die,file_med_d,'die',(1,1))
	ncwrite(S_Lrg_p_die,file_lrg_p,'die',(1,1))
	ncwrite(S_Lrg_d_die,file_lrg_d,'die',(1,1))

	ncwrite(S_Sml_f_clev,file_sml_f,'clev',(1,1))
	ncwrite(S_Sml_p_clev,file_sml_p,'clev',(1,1))
	ncwrite(S_Sml_d_clev,file_sml_d,'clev',(1,1))
	ncwrite(S_Med_f_clev,file_med_f,'clev',(1,1))
	ncwrite(S_Med_p_clev,file_med_p,'clev',(1,1))
	ncwrite(S_Med_d_clev,file_med_d,'clev',(1,1))
	ncwrite(S_Lrg_p_clev,file_lrg_p,'clev',(1,1))
	ncwrite(S_Lrg_d_clev,file_lrg_d,'clev',(1,1))

	ncwrite(S_Sml_f_S,file_sml_f,'S',(1,1))
	ncwrite(S_Sml_p_S,file_sml_p,'S',(1,1))
	ncwrite(S_Sml_d_S,file_sml_d,'S',(1,1))
	ncwrite(S_Med_f_S,file_med_f,'S',(1,1))
	ncwrite(S_Med_p_S,file_med_p,'S',(1,1))
	ncwrite(S_Med_d_S,file_med_d,'S',(1,1))
	ncwrite(S_Lrg_p_S,file_lrg_p,'S',(1,1))
	ncwrite(S_Lrg_d_S,file_lrg_d,'S',(1,1))

	ncwrite(S_Sml_f_DD,file_sml_f,'DD',(1,1))
	ncwrite(S_Sml_p_DD,file_sml_p,'DD',(1,1))
	ncwrite(S_Sml_d_DD,file_sml_d,'DD',(1,1))
	ncwrite(S_Med_f_DD,file_med_f,'DD',(1,1))
	ncwrite(S_Med_p_DD,file_med_p,'DD',(1,1))
	ncwrite(S_Med_d_DD,file_med_d,'DD',(1,1))
	ncwrite(S_Lrg_p_DD,file_lrg_p,'DD',(1,1))
	ncwrite(S_Lrg_d_DD,file_lrg_d,'DD',(1,1))

	%! Close save
  ncclose(file_sml_f)
  ncclose(file_sml_p)
  ncclose(file_sml_d)
  ncclose(file_med_f)
  ncclose(file_med_p)
  ncclose(file_med_d)
  ncclose(file_lrg_p)
	ncclose(file_lrg_d)
	ncclose(file_bent)

end
