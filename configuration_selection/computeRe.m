function [outputArg1,outputArg2] = computeRe(inputArg1,inputArg2)
%COMPUTERE Summary of this function goes here
%   Detailed explanation goes here

%% Calculate wing dimensions
%
Sw_m2 = weightTakeoff_N ./ WL_Npm2; % wing reference area (in m2)
b_m = sqrt(AR .* Sw_m2); % wing span (in m)
% TR = 0.45; % taper ratio
cRoot_m = 2 * Sw_m2 / (b_m * (1 + TR)); % root chord (in m)
cTip_m = cRoot_m * TR; % tip chord (in m)
MAC_m = 2/3 * cRoot_m * (1 + TR + TR^2)/(1 + TR) % mean aerodynamic chord (m)

[T_K,~,rho_kgpm3] = findTemperaturePressureDensity(altitudeCruise_km);
% temperature (in K) density (in kg/m3) at cruising altitude 
mu_kgpms = 1.458e-6 * T_K^1.5 / (T_K + 110.4);
% viscosity at cruising altitude (in kg/m.s)
% Vcruise = 24; % cruising velocity (in m/s)
Re = rho_kgpm3 * Vcruise * MAC_m / mu_kgpms; % Reynolds number
%}
end

