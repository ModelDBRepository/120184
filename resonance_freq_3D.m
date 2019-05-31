function resonance_freq_3D

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
% This function calculates the resonance frequency response of 
% synapses with different parameters and plots its 3D response.  In
% addition, it generates the perturbation surfaces, 
% resonance frequency, and the bandwidth of frequency response.
% Equations used: Eq. (11) and Eq. (13)

% Data source for the central point of the perturbation analysis: Henry 
% Markram et al. (1998), differential signaling via
% the same axon of neocortical pyramidal neurons, PNAS, 95:5323–5328.

% Output1: Figure 6B and 6D.  Perturbation analysis of resonance frequency 
% as a function of various physiological parameters based on Eq. (13). The 
% vertical arrows indicate the x-axis that each curve belongs to. The color
% bars indicate the value of resonance frequency at the synapse. B, The 3-D
% plot of resonance frequency against initial calcium concentration and 
% gain of calcium current to concentration. D, The 3-D plot of resonance 
% frequency against recovery rate constant and calcium sensitivity.

% Output2: Figure 7A and 7B.  Figure 7. Frequency response surfaces 
% constructed by changing physiological parameters based on Eq. (11). The 
% center line indicates the resonance frequency and the lines on the both 
% sides label the half-power bandwidth (-3dB). A, The frequency response as
% a function of concentration gain per action potential (KCa). B, The 
% frequency response as a function of initial recovery rate constant 
% (krecov0).

% ------------------------------------------------------------------------

close all

% --------------Define the basic parameter values---------------
Ca0=0.075e2; % initial calcium concentration
krecov0=0.75E-2; % recovery rate constants
krecovmax=krecov0;
Krecov=0;
Prelmax=1; % release probability
Krel=0.2e2;
krecovmax_Prelmax=krecovmax/Prelmax;
KCa=5.15e2;%
nHill=4;

%------Plot the resonance frequency versus Ca0, and KCa (Fig. 6B)------
Ca0_vec=linspace(0,16,300); %7.5
KCa_vec = linspace(150,900,300);%0.75E-2
[Ca0_mat,KCa_mat] = meshgrid(Ca0_vec,KCa_vec);
[rresonance] = calc_rreson(Ca0_mat,KCa_mat,Krel,krecovmax_Prelmax,nHill); 

figure
mesh(Ca0_mat,KCa_mat,rresonance);
xlabel('Ca_i_0 (\muM)','FontSize', 12);
ylabel ('K_C_a (\muMms^-^1)','FontSize', 12);
zlabel('Resonance frequency (Hz)','FontSize', 12);
colorbar('EastOutside')
axis([0 20 0 1000 0 100])

%------Plot the resonance frequency versus krecov and Krel (Fig. 6D)------
krecov_vec=linspace(0.001,2E-2,300);
Krel_vec=linspace(10,30,300);%515
[krecov_mat,Krel_mat] = meshgrid(krecov_vec,Krel_vec);
[rresonance] = calc_rreson(Ca0,KCa,Krel_mat,krecov_mat,nHill); 

figure
mesh(krecov_mat,Krel_mat,rresonance);
xlabel('k_r_e_c_o_v (ms^-^1)','FontSize', 12);
ylabel ('K_r_e_l_,_1_/_2 (\muM)','FontSize', 12);
zlabel('Resonance frequency (Hz)','FontSize', 12);
colorbar('EastOutside')
axis([0.001 0.02 10 30 0 50])

%-----------Plot the frequency response versus KCa (Fig. 7A)------------
freq=linspace(1,100,200); % frequency range in the units of Hz
freqkHz=freq/1000; % frequency in the units of kHz
KCa_vec=linspace(2,8,200)*1e2; %515
[freqkHz_mat,KCa_mat] = meshgrid(freqkHz,KCa_vec);
[sim_EPSP] = calc_EPSP(Ca0,KCa_mat,Krel,krecovmax,Prelmax,nHill,freqkHz_mat);

% Plot the frequency response
figure
mesh(freqkHz*1e3,KCa_vec,sim_EPSP);
xlabel('Freq (Hz)','FontSize', 12);
ylabel ('K_C_a (\muMms^-^1)','FontSize', 12);
zlabel('Normalized EPSP','FontSize', 12);
colorbar('EastOutside')
hold on

[rreson_vec] = calc_rreson(Ca0,KCa_vec,Krel,krecovmax_Prelmax,nHill);
rreson_veckHz=rreson_vec./1e3;
[sim_EPSP] = calc_EPSP(Ca0,KCa_vec,Krel,krecovmax,Prelmax,nHill,rreson_veckHz);
plot3(rreson_vec,KCa_vec,sim_EPSP,'k-','LineWidth',2.7)

% Plot the band width
freq_start0=[10 60]/1e3;
for j=1:2
 for i = 1:200
  freq_limit(i,j)= fzero(@(freqkHz) calc_band(Ca0,KCa_vec(i),Krel,krecovmax...
  ,Prelmax,nHill,freqkHz,rreson_veckHz(i)),freq_start0(j));
 end
hold on
plot3(freq_limit(:,j).*1e3,KCa_vec,sim_EPSP./2^0.5,'r-','LineWidth',2.5)
end

%------------Plot the frequency response versus krecov0(Fig. 7B)----------
krecov0_vec=linspace(0.6, 8, 200)*1e-3;   %7.5e-3
[freqkHz_mat,krecov0_mat] = meshgrid(freqkHz,krecov0_vec);
[sim_EPSP] = calc_EPSP(Ca0,KCa,Krel,krecov0_mat,Prelmax,nHill,freqkHz_mat);

% Plot the frequency response
figure
mesh(freqkHz*1e3,krecov0_vec,sim_EPSP);
xlabel('Freq (Hz)','FontSize', 12);
ylabel ('k_r_e_c_o_v_0 (ms^-^1)','FontSize', 12);
zlabel('Normalized EPSP','FontSize', 12);
colorbar('EastOutside')
hold on

[rreson_vec] = calc_rreson(Ca0,KCa,Krel,krecov0_vec,nHill);
rreson_veckHz=rreson_vec./1e3;
[sim_EPSP] = calc_EPSP(Ca0,KCa,Krel,krecov0_vec,Prelmax,nHill,rreson_veckHz);
plot3(rreson_vec,krecov0_vec,sim_EPSP,'k-','LineWidth',2.7)

% Plot the band width
freq_start0=[10 60]/1e3;
for j=1:2
 for i = 1:200
  freq_limit(i,j)= fzero(@(freqkHz) calc_band(Ca0,KCa,Krel,krecov0_vec(i)...
  ,Prelmax,nHill,freqkHz,rreson_veckHz(i)),freq_start0(j));
 end
hold on
plot3(freq_limit(:,j).*1e3,krecov0_vec,sim_EPSP./2^0.5,'r-','LineWidth',2.5)
end


%-----------------Functions for calculating rresonance-----------------
function [rresonance] = calc_rreson(Ca0,KCa,Krel,krecovmax_Prelmax,nHill)
rresonance = (-Ca0./KCa + (nHill.*(Krel./KCa).^nHill.*...
krecovmax_Prelmax).^(1./(nHill+1)))*1e3; %resonance frequency
return

%-----------------Functions for calculating sim_EPSP-------------------
function [sim_EPSP] = calc_EPSP(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,freqkHz)
Ca=Ca0+freqkHz.*KCa;
Prelss=Prelmax.*Ca.^nHill./(Ca.^nHill+Krel.^nHill);
Rrelss=krecovmax./(krecovmax+Prelss.*freqkHz);
sim_EPSP=Prelss.*Rrelss;
Prel0=Prelmax.*Ca0.^nHill./(Ca0.^nHill+Krel.^nHill);
sim_EPSP=sim_EPSP./Prel0; % normalize EPSPs wrt the lowest freq
return

%-----------------Functions for calculating bandwidth-------------------
function [EPSPzero] = calc_band(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,freqkHz,rresonkHz)
[sim_EPSP] = calc_EPSP(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,freqkHz);
[sim_EPSP_reson] = calc_EPSP(Ca0,KCa,Krel,krecovmax,Prelmax,nHill,rresonkHz);
EPSPzero = sim_EPSP_reson/2^0.5-sim_EPSP;
return
