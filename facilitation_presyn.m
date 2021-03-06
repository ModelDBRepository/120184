function [sys,x0] = facilitation_presyn(time,x,u,flag,xinit)

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
%  This function transforms calcium currents into the flux of glutamate
%  which later on gets converted into Excitatory Postsynaptic Current
%  (EPSC)
%  It be used in a Simulink model as the component of an S Function block
%  Set the S Function name to facilitation_presyn
% Equations used: Eq. (1) - (7)
%
%  The input vector is the calcium current (ICa)
%  The output vector consists of  
%  1  concentration of bound calcium (Ca)  as well as 
%  2  releasable vesicle ratio (Rrel) 
%  3  release probability (Prel)
%  4  the flux of neurotransmitter (dGlu/dt)
% ------------------------------------------------------------------------

% The number of state, output, and input variables, respectively
zstates = 2;
zoutput = 4;
zinput = 1;

% reaction parameters with fixed values
Ca0=0.47e1; % Initial calcium concentration 
KCa=1.2e2;
krecov0=2.2E-2; % recovery rate constants
krecovmax=krecov0;
Krecov=0e2;
Prelmax=0.9; % release probability
Krel=0.9e1;
TauCa=100;

if (abs(flag) == 1),  %return state derivates
  sys = zeros(zstates, 1);
  Ca = x(1); % conc. of bound calcium
  Rrel = x(2); % releasable vesicle ratio
    
  %species equations
  sys(1) = (1/TauCa)*(-Ca+Ca0+KCa*u); % conc. of bound calcium
  Prel = Prelmax*Ca^4/(Ca^4+Krel^4) ; % release probability   + 0.4 * (Ca /(Ca+ 1))^2
  krecov = krecov0+(krecovmax-krecov0)*Ca/(Ca+Krecov); % recovery rate
  sys(2) = krecov*(1-Rrel)- (Prel*Rrel*u); % releasable vesicle ratio

elseif flag == 3,	% return system outputs
  sys(1:2) = x;
  Ca = x(1); % conc. of bound calcium
  Rrel = x(2); % releasable vesicle ratio
  Prel = Prelmax*Ca^4/(Ca^4+Krel^4); % release probability
  sys(3)= Prel;
  sys(4) = (Rrel*Prel*u)*9.2e5;  %dGlu/dt
 
elseif flag == 0,	% initial conditions, etc
  sys = [zstates, 0, zoutput, zinput, 0, 1];
  if nargin < 5
    %Ca
    x0(1) = 0.47e1;
    %Rrel
    x0(2) = 1;
  else
    x0 = xinit;
  end
else
  sys=[];
end;

