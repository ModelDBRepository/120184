function facilitation_freq

% ========================================================================
% This file is part of the Supplemental Codes of the manuscript 
% entitled "A Kinetic Model Unifying Presynaptic Short-Term Facilitation 
% and Depression" accepted by Journal of Compuational Neuroscience.  
% (Manucript No. #JCNS583R2).
% Authors: Chuang-Chung J. Lee, Mihai Anton, Chi-Sang Poon, Gregory McRae 
%
% Created by Chuang-Chung J. Lee 
% Created in Oct. '07.
% Latest modified in Oct. '08.
% ========================================================================

% ------------------------------------------------------------------------
% This function calculates the steady state frequency response of 
% synapses under facilitation and plots both experimental & simulated
% results.  The Probability of release and Ratio of realeasable vehsicle
% resposes are also output.  
% Equations used: Eq. (8) - (11)

% Experimental Data source: Dittman, J. S. et al. (2000) Interplay between 
% facilitation, depression, and residual calcium at three presynaptic 
% terminals. J. Neurosci. 20:1374-1385.

% Output: Figure 3A and 3B.  Facilitation in the rat parallel fiber to 
% Purkinje cell synapse. A, The frequency response of EPSC. Data are shown 
% as mean ± standard error of the mean (SEM). B, The frequency response of 
% vesicle ratio and release probability by model.
% ------------------------------------------------------------------------

% -----------Plot the experimental frequency response first---------------
close all
freq_ex=[1 3 10 20 50];
EPSCss_norm=[1.11 1.44 2.28 2.87 4.06];
EPSCss_std=[0.07 0.13 0.25 0.20 0.14];

semilogx(freq_ex, EPSCss_norm,'ko', 'Markersize', 4,'MarkerFaceColor','k')
axis([0.1 100 0 6])
hold on
errorbar(freq_ex(1), EPSCss_norm(1), EPSCss_std(1),'k-','LineWidth',1.2)
errorbar(freq_ex(2), EPSCss_norm(2), EPSCss_std(2),'k-','LineWidth',1.2)
errorbar(freq_ex(3), EPSCss_norm(3), EPSCss_std(3),'k-','LineWidth',1.2)
errorbar(freq_ex(4), EPSCss_norm(4), EPSCss_std(4),'k-','LineWidth',1.2)
errorbar(freq_ex(5), EPSCss_norm(5), EPSCss_std(5),'k-','LineWidth',1.2)
hold on
plot(freq_ex,EPSCss_norm+EPSCss_std,'k+','MarkerSize',6)
plot(freq_ex,EPSCss_norm-EPSCss_std,'k+','MarkerSize',6)
hold on
plot(freq_ex,EPSCss_norm+EPSCss_std+0.14,'s', 'MarkerFaceColor','w','MarkerEdgeColor','w');
plot(freq_ex,EPSCss_norm-EPSCss_std-0.14,'s', 'MarkerFaceColor','w','MarkerEdgeColor','w');

xlabel('Frequency (Hz)','FontSize', 14);
ylabel ('Normalized EPSC_s_s','FontSize', 14);


% ---------Then Calculate and plot the model frequency response ----------
freq=logspace(log10(0.1),log10(100),80); % frequency range in the units of Hz
freqkHz=freq/1000; % frequency in the units of kHz
Ca0=0.47e1; % calcium dynamics
KCa=1.2e2;
krecov0=2.2E-2; % recovery rate constants
krecovmax=krecov0;
Krecov=0e2;
Prelmax=0.9; % release probability
Krel=0.9e1;
krecovmax_Prelmax=krecovmax/Prelmax;
nHill=4;

for i=1:80
   Ca(i)=Ca0+freqkHz(i)*KCa;
   Prelss(i)=Prelmax*Ca(i)^4/(Ca(i)^4+Krel^4);
   krecov(i) = krecov0+(krecovmax-krecov0)*Ca(i)/(Ca(i)+Krecov);
   Rrelss(i)=krecov(i)/(krecov(i)+Prelss(i)*freqkHz(i));
   sim_EPSC(i)=Prelss(i)*Rrelss(i);
end

sim_EPSC=sim_EPSC/sim_EPSC(1); % normalize EPSPs wrt the lowest freq

plot(freq,sim_EPSC,'b-','LineWidth',1.5)
legend('experiment','model','Location','southeast'); 
legend('boxoff')

[rresonance] = calc_rreson(Ca0,KCa,Krel,krecovmax_Prelmax,nHill);

% -----Plot Prel and Rrel-----
figure
subplot(2,1,1)
plot(freq,Rrelss,'LineWidth',1.3)
axis([0.1 100 0 1])
ylabel ('R_r_e_l (r)','FontSize', 14);

subplot(2,1,2)
plot(freq,Prelss,'r','LineWidth',1.3)
axis([0.1 100 0 1])
xlabel('Frequency (Hz)','FontSize', 14);
ylabel ('P_r_e_l (r)','FontSize', 14);

% --------------Functions for calculating rresonance-------------------
function [rresonance] = calc_rreson(Ca0,KCa,Krel,krecovmax_Prelmax,nHill)
rresonance = (-Ca0./KCa + (nHill.*(Krel./KCa).^nHill.*...
krecovmax_Prelmax).^(1./(nHill+1)))*1e3; %resonance frequency
return

% --------------Functions for calculating sim_EPSP-----------------------
function [sim_EPSP Rrelss Prelss] = calc_EPSP(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,freqkHz)
Ca=Ca0+freqkHz.*KCa;
Prelss=Prelmax.*Ca.^nHill./(Ca.^nHill+Krel.^nHill);
Rrelss=krecovmax./(krecovmax+Prelss.*freqkHz);
sim_EPSP=Prelss.*Rrelss;
Prel0=Prelmax.*Ca0.^nHill./(Ca0.^nHill+Krel.^nHill);
sim_EPSP=sim_EPSP; % normalize EPSPs wrt the lowest freq
return

   