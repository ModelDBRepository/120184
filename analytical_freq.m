function analytical_freq

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
% presynapses by both simulation and average approximation
% Equations used: Eq. (9) and Eq. (10)
% Files used: Root/Output/Cass_freq.mat and Root/Output/Rrelss_freq.mat
% Output: Figure 2. The instantaneous time courses of key biophysical 
% variables caused by impulses and the average time courses.
% ------------------------------------------------------------------------

close all

% Retrieve steady state calcium concentrration and ratio of releasable 
% vesicles from the simulation results

cd Output
load SteadyState_Cass;
load SteadyState_Rrelss;
cd ..
sim_data1=SteadyState_Cass;
sim_data2=SteadyState_Rrelss;


% Plot the steady state calcium concentrration
figure
plot(sim_data1(:,1),sim_data1(:,3),'r','LineWidth',1.0);
hold on
plot(sim_data1(:,1),sim_data1(:,2),'LineWidth',1.5);
hold on
plot([50 350],[4.7 4.7],'k-','LineWidth',1.0);
xlabel('Time (ms)','FontSize', 14);
ylabel ('Ca_i (\mu M)','FontSize', 14)
legend('Ca_i by impulse','Ca_i on average','Location', 'Northwest')
legend boxoff
axis([0 400 4 12])
text(200,5,'Ca_i_0','FontSize', 14)
text(200,11,'K_C_aI_C_a','FontSize', 14)



% Plot the steady state ratio of releasable vesicles
figure
plot(sim_data2(:,1),sim_data2(:,3),'r','LineWidth',1.0);
hold on
plot(sim_data2(:,1),sim_data2(:,2),'LineWidth',1.5);
xlabel('Time (ms)','FontSize', 14);
ylabel ('R_r_e_l','FontSize', 14);
axis([0 400 0 1.1])
legend('R_r_e_l by impulse','R_r_e_l on average','Location', 'Northeast')
legend boxoff
% Additional labeling for the figure
text(300,0.2,'k_r_e_c_o_v_,_s_s','FontSize', 14)
text(300,0.7,'k_r_e_c_o_v_,_s_s +  P_r_e_l_,_s_sI_C_a','FontSize', 14)
