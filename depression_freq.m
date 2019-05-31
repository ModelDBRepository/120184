function depression_freq

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
% synapses under depression and plots both experimental & simulated
% results.  The Probability of release and Ratio of realeasable vehsicle
% resposes are also output.  
% Equations used: Eq. (8) - (11)

% Experimental Data source: Henrique von Gersdorff et al. (1997) J. 
% Neurosci., 17(21):8137–8146

% Output: Figure 4A and 4B.  Responses of depressing synapses. A, The 
% frequency response of EPSC in the rat calyx of Held synapse. Data are 
% shown as mean ± standard error of the mean (SEM). B, The frequency 
% response of vesicle ratio and release probability by model.
% ------------------------------------------------------------------------


% -----------Plot the experimental frequency response first---------------
close all
freq_ex=[0.2 0.5 1.0 2.0 5.0 10.0];
EPSCss_norm=[0.89 0.69 0.47 0.42 0.34 0.28];
EPSCss_std=[0.09 0.07 0.09 0.08 0.11 0.14];

errorbar(freq_ex, EPSCss_norm, EPSCss_std,'ks', 'Markersize', 7)
hold on

xlabel('Frequency (Hz)','FontSize', 14);
ylabel ('Normalized EPSC_s_s','FontSize', 14);
axis([0 12 0 1])


% ---------Then Calculate and plot the model frequency response ----------
freq=linspace(0.001,12,50); % frequency range in the units of Hz
freqkHz=freq/1000; % frequency in the units of kHz
Ca0=0.02e2*4/1.5; % initial calcium concentration
KCa=9e2*4/1.5;
krecov0=1E-4; % recovery rate constants
krecovmax=6.6E-3;
Krecov=0.43e2*4/1.5;
Prelmax=0.57; % release probability
Krel=0.015e2*4/1.5;

for i=1:50
   Ca(i)=Ca0+freqkHz(i)*KCa;
   Prelss(i)=Prelmax*Ca(i)^4/(Ca(i)^4+Krel^4);
   krecov(i) = krecov0+(krecovmax-krecov0)*Ca(i)/(Ca(i)+Krecov);
   Rrelss(i)=krecov(i)/(krecov(i)+Prelss(i)*freqkHz(i));
   sim_EPSC(i)=Prelss(i)*Rrelss(i);
end
sim_EPSC=sim_EPSC/sim_EPSC(1); % normalize EPSPs wrt the lowest freq 

% Plot the EPSC response 
plot(freq,sim_EPSC,'b-','LineWidth',1.5)
legend('experiment','model','Location','northeast'); 
legend('boxoff')

% Plot the response of Rrel and Prel 
figure
subplot(2,1,1)
plot(freq,Rrelss,'LineWidth',1.3)
axis([0 12 0 1])
ylabel ('R_r_e_l (r)','FontSize', 14);

subplot(2,1,2)
plot(freq,Prelss,'r','LineWidth',1.3)
axis([0 12 0 1])
xlabel('Frequency (Hz)','FontSize', 14);
ylabel ('P_r_e_l (r)','FontSize', 14);


   