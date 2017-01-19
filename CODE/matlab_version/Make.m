%% POEM Make file

clear all
close all

%%%%!! EXPERIMENTS
testoneloc = true;
oneloc_fishing = false;
oneloc_hind_pristine = false;
oneloc_fore_pristine = false;
spinup_pristine = false;
pre_industrial = false;
historic_pristine = false;
historic_fished = false;
forecast_pristine = false;
forecast_fished = false;

if testoneloc
    tic
    Testoneloc()
    toc
end
if oneloc_fishing
    Oneloc_fishing()
end
if oneloc_hind_pristine
    Oneloc_hindcast_pristine()
end
if oneloc_fore_pristine
    Oneloc_forecast_pristine()
end
if spinup_pristine
    Spinup_pristine()
end
if pre_industrial
    Pre_industrial()
end
if historic_pristine
    Historic_pristine()
end
if historic_fished
    Historic_fished()
end
if forecast_pristine
    Forecast_pristine()
end
if forecast_fished
    Forecast_fished()
end
