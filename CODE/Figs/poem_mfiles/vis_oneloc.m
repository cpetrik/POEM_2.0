% Visualize output of POEM
% Spinup at one location
% 100 years

clear all
close all

dpath = '/Users/Colleen/Dropbox/Princeton/POEM_2.0/CODE/Data/CSV/';

pi = csvread([dpath 'Spinup_PISC.csv']);
pl = csvread([dpath 'Spinup_PLAN.csv']);
de = csvread([dpath 'Spinup_DETR.csv']);

%% Plots over time
x=1:length(pi);

%Piscivore
figure(1)
subplot(1,2,1)
plot(x,pi)
xlim([x(1) x(end)])
title('Piscivore')
xlabel('Time (d)')
ylabel('Biomass (g km^-^2)')
legend('1','2','3','4','5','6','7','8','9','10')
subplot(2,2,2)
plot(x(1:730),pi(1:730,:),'Linewidth',2)
xlim([1 730])
subplot(2,2,4)
plot(x((end-731):end),pi((end-731):end,:),'Linewidth',2)
xlim([x(end-731) x(end)])

%Planktivore
figure(2)
subplot(1,2,1)
plot(x,pl)
xlim([x(1) x(end)])
title('Planktivore')
xlabel('Time (d)')
ylabel('Biomass (g km^-^2)')
legend('1','2','3','4','5','6','7','8','9','10')
subplot(2,2,2)
plot(x(1:730),pl(1:730,:),'Linewidth',2)
xlim([1 730])
subplot(2,2,4)
plot(x((end-366):end),pl((end-366):end,:),'Linewidth',2)
xlim([x(end-366) x(end)])

%Detritivore
figure(3)
subplot(1,2,1)
plot(x,de)
xlim([x(1) x(end)])
title('Detritivore')
xlabel('Time (d)')
ylabel('Biomass (g km^-^2)')
legend('1','2','3','4','5','6','7','8','9','10')
subplot(2,2,2)
plot(x(1:730),de(1:730,:),'Linewidth',2)
xlim([1 730])
subplot(2,2,4)
plot(x((end-366):end),de((end-366):end,:),'Linewidth',2)
xlim([x(end-366) x(end)])

% All size classes of all
figure(4)
for i=1:10
    subplot(3,4,i)
    plot(x(36134:36500),pi(36134:36500,i),'k','Linewidth',2); hold on
    xlim([x(36134) x(end)])
    ylim([0 5e-3])
    xlabel('Time (d)')
    ylabel('Biomass (g km^-^2)')
end
%
figure(5)
for i=1:10
    subplot(3,4,i)
    plot(x(36134:36500),pl(36134:36500,i),'b','Linewidth',2); hold on
    xlim([x(36134) x(end)])
    %ylim([0 2.5e-16])
    xlabel('Time (d)')
    ylabel('(g km^-^2)')
end
%
figure(6)
for i=1:10
    subplot(3,4,i)
    plot(x(36134:36500),de(36134:36500,i),'r','Linewidth',2); hold on
    xlim([x(36134) x(end)])
    %ylim([0 1.2e-8])
    xlabel('Time (d)')
    ylabel('log Biomass (g km^-^2)')
end

%
figure(7)
for i=1:10
    subplot(3,4,i)
    plot(x(36134:36500),log(pi(36134:36500,i)),'k','Linewidth',2); hold on
    plot(x(36134:36500),log(pl(36134:36500,i)),'b','Linewidth',2); hold on
    plot(x(36134:36500),log(de(36134:36500,i)),'r','Linewidth',2); hold on
    xlim([x(36134) x(end)])
    ylim([-100 0])
    xlabel('Time (d)')
    ylabel('log Biomass (g km^-^2)')
end
legend('Piscivore','Planktivore','Detritivore')

%% Final mean biomass size spectrum
lyr=x((end-365):end);
pi_sum=sum(pi(lyr,:));
pi_mean=mean(pi(lyr,:));
pl_sum=sum(pl(lyr,:));
pl_mean=mean(pl(lyr,:));
de_sum=sum(de(lyr,:));
de_mean=mean(de(lyr,:));

figure(8)
subplot(2,3,1)
bar(pi_sum,'k')
xlim([0 11])
title('Piscivores')
ylabel('Total Annual Biomass (g km^-^2)')
subplot(2,3,4)
bar(pi_mean,'k')
xlim([0 11])
ylabel('Mean Annual Biomass (g km^-^2)')

subplot(2,3,2)
bar(pl_sum,'b')
xlim([0 11])
title('Planktivores')
xlabel('Size class')
subplot(2,3,5)
bar(pl_mean,'b')
xlim([0 11])
xlabel('Size class')

subplot(2,3,3)
bar(de_sum,'r')
xlim([0 11])
title('Detritivores')
subplot(2,3,6)
bar(de_mean,'r')
xlim([0 11])

%% log scale with weight
%Number of size classes
PI_N=10;
PL_N=10;
DE_N=10;

%Min body size (g)
PI_smin = 10;
PL_smin = .1;
DE_smin = .1;

%Max body size (g)
PI_smax = 10000;
PL_smax = 500;
DE_smax = 500;

%Body mass linearly distributed (g)
PI_s = linspace((PI_smin),(PI_smax),PI_N);
PL_s = linspace((PL_smin),(PL_smax),PL_N);
DE_s = linspace((DE_smin),(DE_smax),DE_N);

figure(9)
subplot(2,1,1)
plot(log(PI_s),log(pi_sum),'k','Linewidth',2); hold on;
plot(log(PL_s),log(pl_sum),'b','Linewidth',2); hold on;
plot(log(DE_s),log(de_sum),'r','Linewidth',2); hold on;
xlabel('log Weight of size class (g)')
ylabel('log Total Annual Biomass (g km^-^2)')

subplot(2,1,2)
plot(log(PI_s),log(pi_mean),'k','Linewidth',2); hold on;
plot(log(PL_s),log(pl_mean),'b','Linewidth',2); hold on;
plot(log(DE_s),log(de_mean),'r','Linewidth',2); hold on;
xlabel('log Weight of size class (g)')
ylabel('log Mean Annual Biomass (g km^-^2)')

%
figure(10)
subplot(3,1,1)
plot(log(PI_s),log(pi_sum),'k','Linewidth',2); hold on;
xlim([-3 10])
title('Piscivores')

subplot(3,1,2)
plot(log(PL_s),log(pl_mean),'b','Linewidth',2); hold on;
xlim([-3 10])
ylabel('log Mean Annual Biomass (g km^-^2)')
title('Planktivores')

subplot(3,1,3)
plot(log(DE_s),log(de_mean),'r','Linewidth',2); hold on;
xlim([-3 10])
xlabel('log Weight of size class (g)')
title('Detritivores')








