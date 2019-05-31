function mixture_freq

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
% synapses under mixed effects and plots both experimental & simulated
% results.  The Probability of release and Ratio of realeasable vehsicle
% resposes are also output.  
% Equations used: Eq. (8) - (11)

% Experimental Data source: Henry Markram et al. (1998), differential 
% signaling via the same axon of neocortical pyramidal neurons, PNAS, 
% 95:5323–5328.

% Output: Figure 5A and 5B.  Synaptic plasticity in rat pyramidal neurons 
% under mixed effects. A, The EPSP as a function of frequency, with maximum
% and bandwidth labeled. B, The frequency response of releasable vesicle 
% ratio and release probability by model.
% ------------------------------------------------------------------------


% -----------Plot the experimental frequency response first---------------
close all
freq_ex=[0.86 5.43 10.29 15.43 20.57 25.43 30.29 35.14 40.29 45.14 50.00...
 54.57 59.71 64.86 69.43];
EPSPss=[1.31 2.65 4.31 5.77 6.25 6.13 6.13 5.57 4.35 4.90 4.98 3.52 3.88...
 3.28 3.08];

plot(freq_ex, EPSPss,'ko','MarkerFaceColor','k','Markersize', 4);
hold on

xlabel('Frequency (Hz)','FontSize', 14);
ylabel ('EPSP_s_s (mV)','FontSize', 14);


% ---------Then Calculate and plot the model frequency response ----------
freq=linspace(1,100,40); % frequency range in the units of Hz
freqkHz=freq/1000; % frequency in the units of kHz
Ca0=0.075e2; % calcium dynamics
KCa=5.15e2;
krecov0=0.75E-2; % recovery rate constants
krecovmax=krecov0;
Krecov=0e2;
Prelmax=1; % release probability
Krel=0.2e2;
krecovmax_Prelmax=krecovmax/Prelmax;
nHill=4;

[sim_EPSP Rrelss Prelss] = calc_EPSP(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,freqkHz);
[rresonance] = calc_rreson(Ca0,KCa,Krel,krecovmax_Prelmax,nHill);
rresonkHz=rresonance/1e3; % (kHz)
freq_start0_left=10/1e3;  freq_start0_right=60/1e3;
freq_limit_left= fzero(@(freqkHz) calc_band(Ca0,KCa,Krel,krecovmax...
,Prelmax,nHill,freqkHz,rresonkHz),freq_start0_left);
freq_limit_right= fzero(@(freqkHz) calc_band(Ca0,KCa,Krel,krecovmax...
,Prelmax,nHill,freqkHz,rresonkHz),freq_start0_right);

plot(freq,sim_EPSP,'b-','LineWidth',1.5)
legend('experiment','model','Location','southeast'); 
legend('boxoff')
axis([0 100 0 8])

[sim_EPSP] = calc_EPSP(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,rresonkHz);

% Add additional labels regarding resonance frequency and bandwidth
plot ([rresonance rresonance],[sim_EPSP 0],'b--');
plot ([100 rresonance],[sim_EPSP sim_EPSP],'b--');
plot ([freq_limit_left freq_limit_left]*1e3,[sim_EPSP/2^0.5 0],'r--');
plot ([freq_limit_right freq_limit_right]*1e3,[sim_EPSP/2^0.5 0],'r--');
plot ([freq_limit_left 0.1]*1e3,[sim_EPSP/2^0.5 sim_EPSP/2^0.5],'r--');
text(80,5,'V_m_a_x-3dB','FontSize',14); % text(2,5)
text(87,7,'V_m_a_x','FontSize',14); % text(2,7)

% -----Plot Prel and Rrel-----
figure
subplot(2,1,1)
plot(freq,Rrelss,'LineWidth',1.3)
axis([0 100 0 1])
ylabel ('R_r_e_l (r)','FontSize', 14);

subplot(2,1,2)
plot(freq,Prelss,'r','LineWidth',1.3)
axis([0 100 0 1])
xlabel('Frequency (Hz)','FontSize', 14);
ylabel ('P_r_e_l (r)','FontSize', 14);


% -----------------Functions for calculating rresonance------------------
function [rresonance] = calc_rreson(Ca0,KCa,Krel,krecovmax_Prelmax,nHill)
rresonance = (-Ca0./KCa + (nHill.*(Krel./KCa).^nHill.*...
krecovmax_Prelmax).^(1./(nHill+1)))*1e3; %resonance frequency
return

% -------------------Functions for calculating sim_EPSP-------------------
function [sim_EPSP Rrelss Prelss] = calc_EPSP(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,freqkHz)
Ca=Ca0+freqkHz.*KCa;
Prelss=Prelmax.*Ca.^nHill./(Ca.^nHill+Krel.^nHill);
Rrelss=krecovmax./(krecovmax+Prelss.*freqkHz);
sim_EPSP=Prelss.*Rrelss;
Prel0=Prelmax.*Ca0.^nHill./(Ca0.^nHill+Krel.^nHill);
sim_EPSP=sim_EPSP*34; % normalize EPSPs wrt the lowest freq
return

% -------------------Functions for calculating bandwidth-------------------
function [EPSPzero] = calc_band(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,freqkHz,rresonkHz)
[sim_EPSP] = calc_EPSP(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,freqkHz);
[sim_EPSP_reson] = calc_EPSP(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,rresonkHz);
EPSPzero = sim_EPSP_reson/2^0.5-sim_EPSP;
return

   