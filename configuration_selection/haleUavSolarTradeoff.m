function [weightTakeoff_N,SwRounded_m2,Cl] = ...
                        haleUavSolarTradeoff(altitudeCruise_km,Vcruise_mps)
%Tradeoff study between cruising altitude and cruise speed for HALE UAV
% 
%   haleUavSolarTradeoff is used to perform a tradeoff study between the
%   cruising altitude and cruise speed for a High Altitude Long Endurance
%   Unmanned Aerial Vehicle (HALE UAV) whose lifting surfaces (wings and
%   horizontal stabilizers) are covered with solar cells. (These provide
%   power for daytime flight and also recharge fuel cells that power 
%   nighttime flight.)
% 
%   The inputs can be of arbitrary dimensions, but if both/any of them are/
%   is a vector, it is recommended that the altitudes form a row vector
%   and/or the speeds form a column vector. 
% 
%   The values of the design parameters used in haleUavSolarTradeoff are
%   taken from Romeo et al. (2004), "HELIPLAT(R): Design, Aerodynamic,
%   Structural Analysis of Long-Endurance Solar-Powered Stratospheric
%   Platform", Journal of Aircraft, 41 (6), 1505 - 1520. For more
%   information regarding the equations used here, refer to that.

%   Copyright 2021 Athrey Ranjith Krishnanunni

%% Define constants and design requirements
%
g0_mps2 = 9.805; % acceleration due to gravity at sea level (m/s^2)
SOLAR_CONSTANT_Wpm2 = 1366; % W/m^2

massPayload_kg = 30;
weightPayload_N = massPayload_kg * g0_mps2;

powerPayload_W = 500; % power consumption of payload (in W)
powerAvionics_W = 100; % power consumption of avionics (in W)
%}
%% Use design parameters of HeliPlat
%
etaSolarCell = 0.15; % efficiency of solar cells
etaProp = 0.81; % propulsive efficiency
etaFuelCell = 0.6; % efficiency of fuel cells

Cl3p2_CdCruise = 45; % value of Cl^1.5/Cd optimised for cruise
Cl3p2_CdLoiter = (3^0.75)/2 * Cl3p2_CdCruise; % same thing optimised for loiter

AR = 31; % aspect ratio
nLim = 3.1; % limit load factor

% weight of         solar cells     fuel cells      prop system
weightFractions = [ 0.16;           0.19;           0.06];
%                   /               takeoff weight
%}
%% Find densities at operating altitudes
%
altitudeLoiter_km = 15;

% check if \ira\ is on the MATLAB path
try
[~,~,rhoCruise_kgpm3] = findTemperaturePressureDensity(altitudeCruise_km);
catch ME
    if strcmp(ME.identifier,'MATLAB:UndefinedFunction')
        msg = ['aircraft_design\\ira\\ is not on the MATLAB path. Execute '...
               'runMeFirst.m to add the entire aircraft_design folder to '...
               'the MATLAB path.'];
        ME = MException('MATLAB:ira:notOnPath',msg);
    end
    throw(ME)
end

[~,~,rhoLoiter_kgpm3] = findTemperaturePressureDensity(altitudeLoiter_km);
%}
%% Calculate takeoff weight and wing area
%
MAX_ITERATIONS = 30;
Sw_TOLERANCE_m2 = 0.01; % precision required for wing planform area (in m2)

Sw_m2 = zeros([size(altitudeCruise_km),MAX_ITERATIONS+1]);
% since altitudeCruise_km could, in general, have arbitrary dimensions, we
% can't write Sw_m2(:,:,...,iterNo) because we don't know how many colons
% will be required. Hence, we need an indexing system that will evaluate to
% ':' sometimes and 1, 2, ... at others. This can be achieved using cells.
% See \ira\findTemperatureDensity.m for more info.
idxSw = cell(1,ndims(altitudeCruise_km));
idxSw(:) = {':'};

Sw_m2(idxSw{:},1) = 176; % initial guess (same as that of HeliPlat)

for iterNo = 1:MAX_ITERATIONS
    
    weightAirframe_N = ...
                8.75 * nLim^0.311 * AR^0.4665 * Sw_m2(idxSw{:},iterNo).^0.7775;
    
    weightTakeoff_N = (weightPayload_N + weightAirframe_N) / ...
                      (1 - sum(weightFractions));
    
    powerReqCruise_W = Sw_m2(idxSw{:},iterNo) .* sqrt(2./rhoCruise_kgpm3) .* ...
        (weightTakeoff_N./Sw_m2(idxSw{:},iterNo)).^1.5 / (Cl3p2_CdCruise * etaProp);

    powerReqLoiter_W = Sw_m2(idxSw{:},iterNo) * sqrt(2/rhoLoiter_kgpm3) .* ...
        (weightTakeoff_N./Sw_m2(idxSw{:},iterNo)).^1.5 / (Cl3p2_CdLoiter * etaProp);

    powerDischarge_W = powerReqCruise_W + powerPayload_W + powerAvionics_W;
    % at night
    
    powerCharge_W = powerDischarge_W / etaFuelCell;
    % assuming P_discharge = eta_fuelcell * P_charge
    
    powerSolarCell_W = powerReqLoiter_W + powerAvionics_W + powerCharge_W;
    % during the day
    
    SwNext_m2 = powerSolarCell_W / (SOLAR_CONSTANT_Wpm2 * etaSolarCell * 0.6);
    % think of it either as only 60% of wing area being covered, or only
    % 60% of solar constant being available - it's likely a mix of both
    
    Sw_m2(idxSw{:},iterNo+1) = (Sw_m2(idxSw{:},iterNo) + SwNext_m2)/2;
    % for faster convergence
    
    SwMaxError_m2 = ...
        max(abs(Sw_m2(idxSw{:},iterNo) - Sw_m2(idxSw{:},iterNo+1)),[],'all');
    
    if SwMaxError_m2 < Sw_TOLERANCE_m2
        fprintf('\nSolution converged in %d iterations.\n',iterNo)
        SwRounded_m2 = ...
            Sw_TOLERANCE_m2 * round(Sw_m2(idxSw{:},iterNo+1)/Sw_TOLERANCE_m2);
        break
    end

end
%}
%% Return nothing if solution didn't converge
%
if iterNo == MAX_ITERATIONS
    fprintf(['\nWing area did not converge even though there has been\n'...
               '%d iterations. Current residual is %g m^2 and\n'...
               'tolerance is %g m^2.\n'],...
               MAX_ITERATIONS,SwMaxError_m2,Sw_TOLERANCE_m2);
    weightTakeoff_N = [];
    SwRounded_m2 = [];
    Cl = [];
    return
end
%}
%% Calculate Cl
%
Cl = zeros([nonSingletonSize(altitudeCruise_km), nonSingletonSize(Vcruise_mps)]);

% Cl will be calculated for each combination of cruising altitude and
% cruise speed, so its size will be a combination of both. However, this
% can lead to singleton dimensions in between, so it has been initialized
% this way.

% Now, since the dimensions of Cl constructed like this will be arbitrary,
% neither vectorization nor implicit expansion is not possible (because it
% requires "arrays of compatible sizes", which in the general case,
% altitudeCruise_km and Vcruise_mps will not be).

% This leaves us with no choice but to use a for loop over the "outer"
% dimensions, i.e. for each value of Vcruise_mps. To do this, we need to be
% able to write Cl(:,:,...,iVcruise) except we don't know how many colons
% will be required. This calls for another cell-based indexing system.

% However, because we had removed singleton dimensions from
% altitudeCruise_km when we initialized Cl, they will have to be removed
% from the indexing system as well. We didn't need to do this in Sw_m2
% because it was initialized with the simple size() - it was not an output
% of the function, so it didn't need careful formatting.

% Initializing Cl using size() and then using squeeze(Cl) right before it's
% returned would have been an alternative, if not for the fact that it
% removes _all_ the singleton dimensions.

if ~isvector(altitudeCruise_km)
    idxCl = cell(1,ndims(altitudeCruise_km));
else % you can write Cl(:,iVcruise)
    idxCl = cell(1);
end

idxCl(:) = {':'};

% looping over the cruise speeds
for iVcruise = 1:numel(Vcruise_mps)
    Cl(idxCl{:},iVcruise) = weightTakeoff_N ./ ...
         (0.5 * rhoCruise_kgpm3 .* SwRounded_m2 * Vcruise_mps(iVcruise)^2);
end
%}
end

function szout = nonSingletonSize(argin)
%Returns number of elements if input is a vector, and size ouputs otherwise
    if isvector(argin), szout = numel(argin); return, end
    szout = size(argin);
end