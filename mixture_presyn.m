function [sys,x0] = mixture_presyn(time,x,u,flag,xinit)
%  This function transforms calcium currents into the flux of glutamate
%  It be used in a Simulink model as the component of an S Function block
%  Set the S Function name to mixture_presyn
%
%  The input vector is the calcium current (ICa)
%  The output vector consists of  
%  1  concentration of bound calcium (Ca)  as well as 
%  2  releasable vesicle ratio (Rrel) 
%  3  release probability (Prel)
%  4  the flux of neurotransmitter (dGlu/dt)

% Supplemental materials of "A Synaptic Model of Short Term Depression and 
% Facilitation"
% 10 Aug 2006 by Chuang-Chung Lee

% model parameters
zstates = 2;
zoutput = 4;
zinput = 1;

% reaction parameters with fixed values
Ca0=0.075e2; % calcium dynamics
KCa=5.15e2;
krecov0=0.75E-2; % recovery rate constants
krecovmax=krecov0;
Krecov=0e2;
Prelmax=1; % release probability
Krel=0.2e2;
TauCa=450;

if (abs(flag) == 1),  %return state derivates
  sys = zeros(zstates, 1);
  Ca = x(1); % conc. of bound calcium
  Rrel = x(2); % releasable vesicle ratio
    
  %species equations
  sys(1) = (1/TauCa)*(-Ca+Ca0+KCa*u); % conc. of bound calcium
  Prel = Prelmax*Ca^4/(Ca^4+Krel^4); % release probability
  krecov = krecov0+(krecovmax-krecov0)*Ca/(Ca+Krecov); % recovery rate
  sys(2) = krecov*(1-Rrel)- (Prel*Rrel*u); % releasable vesicle ratio

elseif flag == 3,	% return system outputs
  sys(1:2) = x;
  Ca = x(1); % conc. of bound calcium
  Rrel = x(2); % releasable vesicle ratio
  Prel = Prelmax*Ca^4/(Ca^4+Krel^4); % release probability
  sys(3)= Prel;
  sys(4) = (Rrel*Prel*u)*9.5e6;  %dGlu/dt
 
elseif flag == 0,	% initial conditions, etc
  sys = [zstates, 0, zoutput, zinput, 0, 1];
  if nargin < 5
    %Ca
    x0(1) = 0.075e2;
    %Rrel
    x0(2) = 1;
  else
    x0 = xinit;
  end
else
  sys=[];
end;

