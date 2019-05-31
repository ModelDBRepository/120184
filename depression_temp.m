function depression_temp

% ========================================================================
% This file is part of the Supplemental Codes of the manuscript 
% entitled "A Kinetic Model Unifying Presynaptic Short-Term Facilitation 
% and Depression" accepted by Journal of Compuational Neuroscience.  
% (Manucript No. #JCNS583R2).
% Authors: Chuang-Chung J. Lee, Mihai Anton, Chi-Sang Poon, Gregory McRae 
%
% Created by Chuang-Chung J. Lee 
% Created in July '07.
% Latest modified in Oct. '08.
% ========================================================================

% ------------------------------------------------------------------------
% This function calculates the transient response of 
% synapses under depression and plots both experimental & simulated
% results.  The Probability of release and Ratio of realeasable vehsicle
% resposes are also output.  
% Equations used: Eq. (1) - (7)

% Experimental Data source: Henrique von Gersdorff et al. (1997) J. 
% Neurosci., 17(21):8137–8146

% Output: Figure 3C and 3D.  Responses of depressing synapses. C, The 
% transient EPSC caused by stimuli at 10 Hz in the rat calyx of Held 
% synapse. D, The corresponding transient releasable vesicle ratio and 
% release probability by model.
% ------------------------------------------------------------------------

close all

% ---Retrieve and plot the experimental and simulation data of EPSC-------
cd Output
load sim_depression;
load RPrel_depression;
sim_data=RPrel_depression;
cd ..

data1= [1,-8.04;2,-4.83;3,-3.66;4,-3.32;5,-2.68;6,-3.1;7,-2.37;8,-2.12;
9,-1.98;10,-2.37;11,-2.46;12,-2.46;13,-2.15;14,-2.35;15,-1.9;16,-2.29;
17,-1.84;18,-2.15;19,-2.35;20,-1.87;21,-2.15;22,-1.73;23,-2.04;24,-2.37;
25,-2.18;26,-2.1;27,-2.04;28,-1.84;29,-2.04;30,-1.82];

sim_data1=sim_depression;

% Get the local maximum of I(EPSC) for 10Hz
local_min1=zeros(30,2);
local_min1(:,1)=linspace(1,30,30)';
grid_n=length(sim_data1(:,1));
f=10;
T=1000/f;
delay_t=0;
for i=1:30
  for n=1:grid_n
    if (sim_data1(n,1)<=delay_t+(i-1)*T) && (sim_data1(n+1,1)>=delay_t+(i-1)*T)
       lower_marker=n;
    end
    if (sim_data1(n,1)<=delay_t+i*T) && (sim_data1(n+1,1)>=delay_t+i*T)
       upper_marker=n;
    end    
  end
   local_min1(i,2)=min(sim_data1(lower_marker:upper_marker,2));  
end

figure
plot(data1(:,1)*1e2,data1(:,2),'o','MarkerEdgeColor','m','MarkerFaceColor','m','MarkerSize',5);
hold on
plot(sim_data1(:,1),sim_data1(:,2)*1e6,'b-','LineWidth',1.5);
xlabel('Time (ms)','FontSize', 14);
ylabel ('EPSC (nA)','FontSize', 14)
axis([0 3100 -10 1])
legend('experiment','model','Location','southeast'); 
legend('boxoff')


% ------------------Plot Prel and Rrel---------------------
figure
subplot(2,1,1)
plot(sim_data(:,1),sim_data(:,2),'LineWidth',1.3)
axis([0 3100 0 1])
ylabel ('R_r_e_l (t)','FontSize', 14);
subplot(2,1,2)
plot(sim_data(:,1),sim_data(:,3),'r','LineWidth',1.3)
axis([0 3100 0 1])
xlabel('Time (ms)','FontSize', 14);
ylabel ('P_r_e_l (t)','FontSize', 14);

