function load_image_PF

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
% This function can be used to retrieve image from published papers,
% and replot the data at desired scales and sizes.  The experimental data
% are used afterwards for validating the short-term plasticity model.

% Experimental Data source: Dittman, J. S. et al. (2000) Interplay between 
% facilitation, depression, and residual calcium at three presynaptic 
% terminals. J. Neurosci. 20:1374-1385.

% Output: Figure 3C and 3D.  Facilitation in the rat parallel fiber to 
% Purkinje cell synapse. C, The transient EPSC caused by stimuli at 50 Hz. 
% D, The corresponding transient releasable vesicle ratio and release 
% probability by model.
% ------------------------------------------------------------------------

% Load the image from the current directory
% and convert the bitmap file into numerical arrays
img_array = imread('PF_time.bmp','bmp');
imagesc(img_array)
axis image;

% Get the number of intrinsic pixels
dimen=size(img_array);
n_X=dimen(2); % total number of pixels in x direction
n_Y=dimen(1); % total number of pixels in y direction

% Get the pixels that are black
pt_counter=0; %pt_counter serves as the counter to track the number of black points
for i=1:n_X
    for j=1:n_Y
      if img_array(j,i)==0 % Test whether the dot is black
        pt_counter=pt_counter+1;
        X_vect(pt_counter)= i;
        Y_vect(pt_counter)= j;
      end
    end
end

%-------Specify the desired dimension according to original paper----------
X_min = 0; 
X_max = 225;
Y_min = -811;
Y_max = 0;
%--------------------------------------------------------------------------

% Plot the black pixel vectors according to the
% dimension of original experiments 
X=X_min + (X_vect./n_X).*(X_max-X_min);
Y=Y_max - (Y_vect./n_Y).*(Y_max-Y_min);

plot(X,Y,'g-','LineWidth',1.3); %,'MarkerEdgeColor','m'
xlabel('Time (ms)','FontSize', 14);
ylabel ('IEPSC (pA)','FontSize', 14);