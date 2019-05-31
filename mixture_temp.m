function mixture_temp

% ========================================================================
% This file is part of the Supplemental Codes of the manuscript 
% entitled "A Kinetic Model Unifying Presynaptic Short-Term Facilitation 
% and Depression" accepted by Journal of Compuational Neuroscience.  
% (Manucript No. #JCNS583R2).
% Authors: Chuang-Chung J. Lee, Mihai Anton, Chi-Sang Poon, Gregory McRae 
%
% Created by Chuang-Chung J. Lee 
% Created in Sep. '07.
% Latest modified in Oct. '08.
% ========================================================================

% ------------------------------------------------------------------------
% This function calculates the transient response of 
% synapses under mixed effects and plots both experimental & simulated
% results.  The Probability of release and Ratio of realeasable vehsicle
% resposes are also output.  
% Equations used: Eq. (1) - (7)

% Experimental Data source: Henry Markram et al. (1998), differential 
% signaling via the same axon of neocortical pyramidal neurons, PNAS, 
% 95:5323–5328.

% Output: Figure 5C and 5D.  Synaptic plasticity in rat pyramidal neurons 
% under mixed effects. C, The transient EPSP caused by stimuli at 30 Hz. 
% D, The corresponding transient releasable vesicle ratio and release 
% probability by model.
% ------------------------------------------------------------------------

close all

% ---Retrieve and plot the experimental and simulation data of EPSP-------
cd Input;
load_image_pyramidal
hold on
cd ..

cd Output
load sim_mixture;
load RPrel_mixture;
cd ..

sim_data1=sim_mixture;
sim_data2=RPrel_mixture;

plot(sim_data1(:,1),sim_data1(:,2),'k-','LineWidth',1.3);
xlabel('Time (ms)','FontSize', 14);
ylabel ('EPSP (mV)','FontSize', 14)
axis([0 800 0 25])
legend('Experiment','Model','Location','Northwest')
legend('boxoff')

% ------------------Plot Prel and Rrel---------------------
figure
subplot(2,1,1)
plot(sim_data2(:,1),sim_data2(:,2),'LineWidth',1.3)
axis([0 800 0 1])
ylabel ('R_r_e_l (t)','FontSize', 14);

subplot(2,1,2)
plot(sim_data2(:,1),sim_data2(:,3),'r','LineWidth',1.3)
axis([0 800 0 1])
xlabel('Time (ms)','FontSize', 14);
ylabel ('P_r_e_l (t)','FontSize', 14);