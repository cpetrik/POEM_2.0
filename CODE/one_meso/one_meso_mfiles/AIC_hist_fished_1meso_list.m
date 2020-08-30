% 1 meso FEISTY w/o overcon
% compare to SAU & 1 meso FEISTY w/overcon

clear all
close all

pp = '/Users/cpetrik/Dropbox/Princeton/FEISTY/CODE/Figs/PNG/Matlab_New_sizes/bio_rates/';
dp = '/Volumes/FEISTY/NC/Matlab_new_size/';

%% 
load([dp 'bio_rates/aEnc_BE_A_search_1meso_Dc_enc-b200_m4-b175-k086_c20-b250_D080_nmort1_noCC_RE00100.mat'])


%% Biomass ratio misfits 
mis_all_F = mis_all(:,:,1);
mis_all_P = mis_all(:,:,2);
mis_all_D = mis_all(:,:,3);
mis_all_A = mis_all(:,:,4);
mis_all_PD = mis_all(:,:,6);
mis_all_PF = mis_all(:,:,7);
mis_all_LM = mis_all(:,:,8);
mis_all_Z = mis_all(:,:,9);
%put residuals of all fn types in one vector
% mis_rcombo = [mis_all_F,mis_all_P,mis_all_D,mis_all_A,mis_all_PD,...
%     mis_all_PF,mis_all_LM];
mis_rcombo = [mis_all_PD,mis_all_PF,mis_all_LM];

%% SAUP misfits 
mis_sau_F = mis_sau(:,:,1);
mis_sau_P = mis_sau(:,:,2);
mis_sau_D = mis_sau(:,:,3);
mis_sau_A = mis_sau(:,:,4);
mis_sau_PD = mis_sau(:,:,5);

%% Check distribution of misfits
figure(1)
subplot(2,2,1)
hist(mis_all_PD(:))
subplot(2,2,2)
hist(mis_all_PF(:))
subplot(2,2,3)
hist(mis_all_LM(:))
subplot(2,2,4)
hist(mis_all_Z(:)) %too diff of values to be included with ratios

figure(2)
subplot(2,2,1)
hist(mis_sau_F(:))
subplot(2,2,2)
hist(mis_sau_P(:))
subplot(2,2,3)
hist(mis_sau_D(:))
subplot(2,2,4)
hist(mis_sau_PD(:))


%% SAU comparison
load('/Users/cpetrik/Dropbox/Princeton/POEM_other/SAUP/SAUP_Stock_top10.mat');
load(['/Users/cpetrik/Dropbox/Princeton/POEM_other/poem_ms/',...
    'Stock_PNAS_catch_oceanprod_output.mat'],'notLELC')
keep = notLELC;

l10sF=log10(Flme_mcatch10+eps);
l10sP=log10(Plme_mcatch10+eps);
l10sD=log10(Dlme_mcatch10+eps);
l10sA=log10(slme_mcatch10+eps);
sFracPD = Plme_mcatch10 ./ (Plme_mcatch10 + Dlme_mcatch10+eps);

%% 1 meso structurally FEISTY
cfile1 = 'Dc_enc70-b200_m4-b175-k086_c20-b250_D075_A050_nmort1_BE08_noCC_RE00100';
fpath1 = ['/Volumes/FEISTY/NC/Matlab_new_size/' cfile1 '/'];
harv = 'All_fish03';

load([fpath1 'Means_Historic_1meso_',harv,'_' cfile1 '.mat'],...
    'sf_mean50','sp_mean50','sd_mean50',...
    'mf_mean50','mp_mean50','md_mean50',...
    'lp_mean50','ld_mean50','b_mean50','mz_mfrac5');

CF = sf_mean50 + mf_mean50;
CP = sp_mean50 + mp_mean50 + lp_mean50;
CD = sd_mean50 + md_mean50 + ld_mean50;
CB = b_mean50;
CM = mf_mean50 + mp_mean50 + md_mean50;
CL = lp_mean50 + ld_mean50;
CZ = mz_mfrac5;

CAll = CF+CP+CD;
cFracPD = CP ./ (CP+CD);
cFracPF = CP ./ (CP+CF);
cFracLM = CL ./ (CL+CM);

%% AIC of frac HPloss con
%variance of observations
rsig = var(CZ);
%num of observations
nr = length(CZ);

%logLike
LLr = -nr/2 * log(2*pi*rsig) - (1/(2*rsig)) * sum(mis_all_Z.^2,2);
zaic = -2 * LLr;

[zaic_srt,zidc] = sort(zaic);
zdel = zaic_srt - zaic_srt(1);
zw = exp(-0.5*zdel) ./ nansum( exp(-0.5*zdel) );
zaicv(:,1) = zidc;
zaicv(:,2) = zaic_srt;
zaicv(:,3) = zdel;
zaicv(:,4) = zw;
zaicv(:,5:8) = pset(zidc,:);
zT = array2table(zaicv,'VariableNames',{'ParamSet','AIC','delta','weight',...
    'aC','aE','BE','A'});
writetable(zT,[dp 'bio_rates/AIC_HPloss_aEnc_BE_A_search_1meso_Dc_enc70-b200_m-b175-k086_c20-b250_D080_A050_nmort1_BE10_noCC_RE00100.csv'])


%% Classic AIC of ratios
% AIC = -2*log(L) + 2*K
% log(L) = (-n/2) * log(2*pi*var) - (1/(2*var)) * sum(resid^2)

%mis_rcombo = [mis_all_PD,mis_all_PF,mis_all_LM];
Call = [cFracPD;cFracPF;cFracLM];
%variance of observations
rsig = var(Call);
%num of observations
nr = length(Call);

%logLike
LLr = -nr/2 * log(2*pi*rsig) - (1/(2*rsig)) * sum(mis_rcombo.^2,2);
raic = -2 * LLr;

[raic_srt,ridc] = sort(raic);
rdel = raic_srt - raic_srt(1);
rw = exp(-0.5*rdel) ./ nansum( exp(-0.5*rdel) );
raicv(:,1) = ridc;
raicv(:,2) = raic_srt;
raicv(:,3) = rdel;
raicv(:,4) = rw;
raicv(:,5:8) = pset(ridc,:);
rT = array2table(raicv,'VariableNames',{'ParamSet','AIC','delta','weight',...
    'aC','aE','BE','A'});
writetable(rT,[dp 'bio_rates/AIC_ratios_aEnc_BE_A_search_1meso_Dc_enc70-b200_m-b175-k086_c20-b250_D080_A050_nmort1_BE10_noCC_RE00100.csv'])

%% Biomass P:D ratio
% AIC = -2*log(L) + 2*K
% log(L) = (-n/2) * log(2*pi*var) - (1/(2*var)) * sum(resid^2)

%mis_rcombo = [mis_all_PD,mis_all_PF,mis_all_LM];
%variance of observations
rsig = var(cFracPD);
%num of observations
nr = length(cFracPD);

%logLike
LLr = -nr/2 * log(2*pi*rsig) - (1/(2*rsig)) * sum(mis_all_PD.^2,2);
raic = -2 * LLr;

[raic_srt,ridc] = sort(raic);
rdel = raic_srt - raic_srt(1);
rw = exp(-0.5*rdel) ./ sum( exp(-0.5*rdel) );
raicv1(:,1) = ridc;
raicv1(:,2) = raic_srt;
raicv1(:,3) = rdel;
raicv1(:,4) = rw;
raicv1(:,5:8) = pset(ridc,:);
rTPD = array2table(raicv1,'VariableNames',{'ParamSet','AIC','delta','weight',...
    'aC','aE','BE','A'});
writetable(rTPD,[dp 'bio_rates/AIC_PDratio_aEnc_BE_A_search_1meso_Dc_enc70-b200_m-b175-k086_c20-b250_D080_A050_nmort1_BE10_noCC_RE00100.csv'])

%% Biomass P:F ratio
% AIC = -2*log(L) + 2*K
% log(L) = (-n/2) * log(2*pi*var) - (1/(2*var)) * sum(resid^2)

%mis_rcombo = [mis_all_PD,mis_all_PF,mis_all_LM];
%variance of observations
rsig = var(cFracPF);
%num of observations
nr = length(cFracPF);

%logLike
LLr = -nr/2 * log(2*pi*rsig) - (1/(2*rsig)) * sum(mis_all_PF.^2,2);
raic = -2 * LLr;

[raic_srt,ridc] = sort(raic);
rdel = raic_srt - raic_srt(1);
rw = exp(-0.5*rdel) ./ sum( exp(-0.5*rdel) );
raicv2(:,1) = ridc;
raicv2(:,2) = raic_srt;
raicv2(:,3) = rdel;
raicv2(:,4) = rw;
raicv2(:,5:8) = pset(ridc,:);
rTPF = array2table(raicv2,'VariableNames',{'ParamSet','AIC','delta','weight',...
    'aC','aE','BE','A'});
writetable(rTPF,[dp 'bio_rates/AIC_PFratio_aEnc_BE_A_search_1meso_Dc_enc70-b200_m-b175-k086_c20-b250_D080_A050_nmort1_BE10_noCC_RE00100.csv'])

%% Biomass L:M ratio
% AIC = -2*log(L) + 2*K
% log(L) = (-n/2) * log(2*pi*var) - (1/(2*var)) * sum(resid^2)

%mis_rcombo = [mis_all_PD,mis_all_PF,mis_all_LM];
%variance of observations
rsig = var(cFracLM);
%num of observations
nr = length(cFracLM);

%logLike
LLr = -nr/2 * log(2*pi*rsig) - (1/(2*rsig)) * sum(mis_all_LM.^2,2);
raic = -2 * LLr;

[raic_srt,ridc] = sort(raic);
rdel = raic_srt - raic_srt(1);
rw = exp(-0.5*rdel) ./ sum( exp(-0.5*rdel) );
raicv3(:,1) = ridc;
raicv3(:,2) = raic_srt;
raicv3(:,3) = rdel;
raicv3(:,4) = rw;
raicv3(:,5:8) = pset(ridc,:);
rTLM = array2table(raicv3,'VariableNames',{'ParamSet','AIC','delta','weight',...
    'aC','aE','BE','A'});
writetable(rTLM,[dp 'bio_rates/AIC_LMratio_aEnc_BE_A_search_1meso_Dc_enc70-b200_m-b175-k086_c20-b250_D080_A050_nmort1_BE10_noCC_RE00100.csv'])

%% SAUP P catch & P:D ratio
% l10all = [l10sF(keep);l10sP(keep);l10sD(keep);l10sA(keep);sFracPD(keep)];
l10all = [l10sP(keep);sFracPD(keep)];
%variance of catch observations
ssig = var(l10all);
%num of observations
ns = length(l10all);

%put residuals of all fn types in one vector
% mis_scombo = [mis_sau_F,mis_sau_P,mis_sau_D,mis_sau_A,mis_sau_PD];
mis_scombo = [mis_sau_P,mis_sau_PD];

LLs = -ns/2 * log(2*pi*ssig) - (1/(2*ssig)) * sum(mis_scombo.^2,2);
saic = -2 * LLs;

[saic_srt,sidc] = sort(saic);
sdel = saic_srt - saic_srt(1);
sw = exp(-0.5*sdel) ./ sum( exp(-0.5*sdel) );
saicv(:,1) = sidc;
saicv(:,2) = saic_srt;
saicv(:,3) = sdel;
saicv(:,4) = sw;
saicv(:,5:8) = pset(sidc,:);
sT = array2table(saicv,'VariableNames',{'ParamSet','AIC','delta','weight',...
    'aC','aE','BE','A'});
writetable(sT,[dp 'bio_rates/AIC_SAUP_Pcatch_PDratio_aEnc_BE_A_search_1meso_Dc_enc70-b200_m-b175-k086_c20-b250_D080_A050_nmort1_BE10_noCC_RE00100.csv'])

%% SAUP P catch only

%variance of catch observations
ssig = var(l10sP(keep));
%num of observations
ns = length(l10sP(keep));

LLs = -ns/2 * log(2*pi*ssig) - (1/(2*ssig)) * sum(mis_sau_P.^2,2);
saic = -2 * LLs;

[saic_srt,sidc] = sort(saic);
sdel = saic_srt - saic_srt(1);
sw = exp(-0.5*sdel) ./ sum( exp(-0.5*sdel) );
saicv1(:,1) = sidc;
saicv1(:,2) = saic_srt;
saicv1(:,3) = sdel;
saicv1(:,4) = sw;
saicv1(:,5:8) = pset(sidc,:);
sTP = array2table(saicv1,'VariableNames',{'ParamSet','AIC','delta','weight',...
    'aC','aE','BE','A'});
writetable(sTP,[dp 'bio_rates/AIC_SAUP_Pcatch_aEnc_BE_A_search_1meso_Dc_enc70-b200_m-b175-k086_c20-b250_D080_A050_nmort1_BE10_noCC_RE00100.csv'])

%% SAUP P:D ratio only

%variance of catch observations
ssig = var(sFracPD(keep));
%num of observations
ns = length(sFracPD(keep));

LLs = -ns/2 * log(2*pi*ssig) - (1/(2*ssig)) * sum(mis_sau_PD.^2,2);
saic = -2 * LLs;

[saic_srt,sidc] = sort(saic);
sdel = saic_srt - saic_srt(1);
sw = exp(-0.5*sdel) ./ nansum( exp(-0.5*sdel) );
saicv2(:,1) = sidc;
saicv2(:,2) = saic_srt;
saicv2(:,3) = sdel;
saicv2(:,4) = sw;
saicv2(:,5:8) = pset(sidc,:);
sTPD = array2table(saicv2,'VariableNames',{'ParamSet','AIC','delta','weight',...
    'aC','aE','BE','A'});
writetable(sTPD,[dp 'bio_rates/AIC_SAUP_PDratio_aEnc_BE_A_search_1meso_Dc_enc70-b200_m-b175-k086_c20-b250_D080_A050_nmort1_BE10_noCC_RE00100.csv'])

%% weighted means
aicv(1,:) = nansum(zaicv(:,4) .* zaicv(:,5:8));
aicv(2,:) = nansum(raicv(:,4) .* raicv(:,5:8));
aicv(3,:) = nansum(saicv2(:,4) .* saicv2(:,5:8));
aicv(4,:) = mean(aicv(1:3,:));
aT = array2table(aicv,'VariableNames',{'aC','aE','BE','A'},'RowNames',...
    {'HPloss','Ratios3','PDcatch','Mean'});
writetable(aT,[dp 'bio_rates/AIC_WeightedMeans_aEnc_BE_A_search_1meso_Dc_enc70-b200_m-b175-k086_c20-b250_D080_A050_nmort1_BE10_noCC_RE00100.csv'],...
    'WriteRowNames',true)

