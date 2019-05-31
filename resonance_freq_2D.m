function resonance_freq_2D

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
% synapses with different parameters and plots its 2D response
% Equations used: Eq. (13)

% Data source for the central point of the perturbation analysis: Henry 
% Markram et al. (1998), differential signaling via
% the same axon of neocortical pyramidal neurons, PNAS, 95:5323–5328.

% Output: Figure 6A and 6C.  Perturbation analysis of resonance frequency 
% as a function of various physiological parameters based on Eq. (13). The 
% vertical arrows indicate the x-axis that each curve belongs to.
% The color bars indicate the value of resonance frequency at the synapse. 
% A, The 2-D plot of resonance frequency against initial calcium conc. and 
% gain of calcium current to concentration.  C, The 2-D plot of resonance 
% frequency against recovery rate constant and calcium sensitivity.
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

% ----------Plot the resonance frequency versus nHill, and Krel----------
KCa_vec=linspace(200,1000,100);%515
Ca0_vec=linspace(0,16,60); %7.5

rresonance1 = calc_rreson(Ca0_vec,KCa,Krel,krecovmax_Prelmax,nHill); 
rresonance2 = calc_rreson(Ca0,KCa_vec,Krel,krecovmax_Prelmax,nHill); 

figure
plot(Ca0_vec,rresonance1,'Color','b','LineWidth',1.5);
hl1 = line(Ca0_vec,rresonance1,'Color','b','LineWidth',1.5);
ax1 = gca;
set(ax1,'XColor','k','YColor','k','XTick',[0 4 8 12 16]);
axis([0 16 0 50])
xlabel ('Ca_i_0 (\muM)','FontSize', 14);
ylabel('Resonance frequency (Hz)','FontSize', 14);

ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','left',...
           'Color','none',...
           'XColor','k','YColor','k');
hl2 = line(KCa_vec,rresonance2,'Color','r','LineWidth',1.1,'Parent',ax2);
axis([200 1000 0 50])
xlabel('K_C_a (\muMms^-^1)','FontSize', 14);
ylabel(' depression                          facilitation ','FontSize', 14);

% Add extra labels
annotation('line',[0.96 0.96],[0.37 0.655],'LineWidth',1);
annotation('line',[0.96 0.935],[0.655 0.655],'LineWidth',1);
annotation('line',[0.935 0.96],[0.655 0.37],'LineWidth',1);
annotation('arrow',[0.75 0.75],[0.34 0.44],'LineWidth',1,'Color','r','HeadStyle','vback2','HeadLength',4,'HeadWidth',5);
annotation('arrow',[0.75 0.75],[0.27 0.17],'LineWidth',1.3,'Color','b','HeadStyle','vback2','HeadLength',4,'HeadWidth',5);


% ----------Plot the resonance frequency versus Ca0, and krecov------------
Krel_vec=linspace(10,30,100);%20
krecovmax_Prelmax_vec = linspace(1E-5,2E-2,60);%0.75E-2

%[Ca0_mat,krecovmax_Prelmax_mat] = meshgrid(Ca0_vec,krecovmax_Prelmax_vec);
rresonance1 = calc_rreson(Ca0,KCa,Krel,krecovmax_Prelmax_vec,nHill); 
rresonance2 = calc_rreson(Ca0,KCa,Krel_vec,krecovmax_Prelmax,nHill); 

figure
plot(krecovmax_Prelmax_vec,rresonance1,'Color','b','LineWidth',1.5);
hl1 = line(krecovmax_Prelmax_vec,rresonance1,'Color','b','LineWidth',1.5);
ax1 = gca;
set(ax1,'XColor','k','YColor','k');
axis([0 0.02 0 50])
xlabel('k_r_e_c_o_v (ms^-^1)','FontSize', 14);
ylabel('Resonance frequency (Hz)','FontSize', 14);

ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','left',...
           'Color','none',...
           'XColor','k','YColor','k');
hl2 = line(Krel_vec,rresonance2,'Color','r','LineWidth',1.1,'Parent',ax2);
axis([10 30 0 50])
xlabel('K_r_e_l_,_1_/_2 (\muM)','FontSize', 14);
ylabel(' depression                          facilitation ','FontSize', 14);

% Add extra labels
annotation('line',[0.96 0.96],[0.37 0.655],'LineWidth',1);
annotation('line',[0.96 0.935],[0.655 0.655],'LineWidth',1);
annotation('line',[0.935 0.96],[0.655 0.37],'LineWidth',1);
annotation('arrow',[0.77 0.77],[0.64 0.74],'LineWidth',1,'Color','r','HeadStyle','vback2','HeadLength',4,'HeadWidth',5);
annotation('arrow',[0.77 0.77],[0.54 0.44],'LineWidth',1.3,'Color','b','HeadStyle','vback2','HeadLength',4,'HeadWidth',5);


% ---------------Functions for calculating rresonance---------------
function [rresonance] = calc_rreson(Ca0,KCa,Krel,krecovmax_Prelmax,nHill);
rresonance = (-Ca0./KCa + (nHill.*(Krel./KCa).^nHill.*...
krecovmax_Prelmax).^(1./(nHill+1)))*1e3; %resonance frequency
return


