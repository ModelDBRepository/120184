function facilitation_temp

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
% This function calculates the transient response of 
% synapses under facilitation and plots both experimental & simulated
% results.  The Probability of release and Ratio of realeasable vehsicle
% resposes are also output.  
% Equations used: Eq. (1) - (7)

% Experimental Data source: Dittman, J. S. et al. (2000) Interplay between 
% facilitation, depression, and residual calcium at three presynaptic 
% terminals. J. Neurosci. 20:1374-1385.

% Output: Figure 3C and 3D.  Facilitation in the rat parallel fiber to 
% Purkinje cell synapse. C, The transient EPSC caused by stimuli at 50 Hz. 
% D, The corresponding transient releasable vesicle ratio and release 
% probability by model.
% ------------------------------------------------------------------------

close all

% ---Retrieve and plot the experimental and simulation data of EPSC-------
cd Input;
load_image_PF
hold on
cd ..

cd Output
load sim_facilitation;
load RPrel_facilitation;
cd ..

sim_data1=sim_facilitation;
sim_data2=RPrel_facilitation;

plot(sim_data1(:,1),sim_data1(:,2)*1e9,'k-','LineWidth',1.3);
xlabel('Time (ms)','FontSize', 14);
ylabel ('EPSC (pA)','FontSize', 14)
axis([0 220 -800 0])
legend('Experiment','Model','Location','Southwest')
legend('boxoff')

% ------------------Plot Prel and Rrel---------------------
figure
subplot(2,1,1)
plot(sim_data2(:,1),sim_data2(:,2),'LineWidth',1.3)
axis([0 220 0 1])
ylabel ('R_r_e_l (t)','FontSize', 14);

subplot(2,1,2)
plot(sim_data2(:,1),sim_data2(:,3),'r','LineWidth',1.3)
axis([0 220 0 1])
xlabel('Time (ms)','FontSize', 14);
ylabel ('P_r_e_l (t)','FontSize', 14);
