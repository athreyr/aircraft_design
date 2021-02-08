%%  Calculate initial estimates of takeoff weight and wing area of Heliplat
%
%	

g0_mps2 = 9.805; % acceleration due to gravity at surface of Earth (m/s2)
SOLAR_CONSTANT_Wpm2 = 1366; % solar constant (in W/m2)

cruisingAltitude_km = 15; % cruising altitude (in km)
loiteringAltitude_km = 15; % loitering altitude (in km)

% calculate densities at operating altitudes
allFunctions = which('findTemperaturePressureDensity.m','-all');
if isempty(allFunctions)
    addpath('../ira')
else
    fullpaths = cell(size(allFunctions));
    foldernames = cell(size(allFunctions));
    for thisFunction = 1:numel(allFunctions)
        [fullpaths{thisFunction},~,~] = fileparts(allFunctions{thisFunction});
        [~,foldernames{thisFunction},~] = fileparts(fullpaths{thisFunction});
    end
    [~,existIra] = ismember('ira',foldernames);
    if ~existIra, warning('Folder structure different from remote repo.'), end
end
[~,~,rhoCruise_kgpm3] = findTemperaturePressureDensity(cruisingAltitude_km);
[~,~,rhoLoiter_kgpm3] = findTemperaturePressureDensity(loiteringAltitude_km);

massPayload_kg = 30;
weightPayload_N = massPayload_kg * g0_mps2; % weight of payload and avionics (kg, converted to N)
powerPayload_W = 500; % power consumption of payload (in W)
powerAvionics_W = 100; % power consumption of avionics (in W)

etaSolarCell = 0.15; % efficiency of solar cells
etaProp = 0.81; % propulsive efficiency
etaFuelCell = 0.60; % efficiency of fuel cells

Cl3p2_CdCruise = 45; % value of Cl^1.5/Cd optimised for cruise
Cl3p2_CdLoiter = (3^0.75)/2 * Cl3p2_CdCruise; % same thing optimised for loiter

AR = 31; % aspect ratio
nLim = 3.1; % limit load factor

% WeightFraction = struct(...
%                         'solarCell',0.16,...
%                         'fuelCell',0.19,...
%                         'propSys',0.06);
% weightFractionSolarCell = 0.16; % weight fraction of solar cells
% weightFractionFuelCell = 0.19; % weight fraction of fuel cells
% weightFractionPropSys = 0.06; % weight fraction of propulsion system
% sumOfWeightFractions = weightFractionSolarCell + weightFractionFuelCell + ...
%                        weightFractionPropSys;
weightFractions = [0.16; 0.19; 0.06];

MAX_ITERATIONS = 30;
TOLERANCE_Sw_m2 = 0.1;

Sw_m2 = zeros(1,MAX_ITERATIONS+1);
Sw_m2(1) = 176; % initial guess of wing reference area (in m2)

for iterNo = 1:MAX_ITERATIONS
    
    weightAirframe_N = 8.75 * nLim^0.311 * AR^0.4665 * Sw_m2(iterNo)^0.7775;
    % weight of airframe (in N)
    
    weightTakeoff_N = (weightPayload_N + weightAirframe_N) / ...
                      (1 - sum(weightFractions));
    
    powerReqCruise_W = Sw_m2(iterNo) * sqrt(2/rhoCruise_kgpm3) * ...
        (weightTakeoff_N/Sw_m2(iterNo))^1.5 / (Cl3p2_CdCruise * etaProp);

    powerReqLoiter_W = Sw_m2(iterNo) * sqrt(2/rhoLoiter_kgpm3) * ...
        (weightTakeoff_N/Sw_m2(iterNo))^1.5 / (Cl3p2_CdLoiter * etaProp);

    powerDischarge_W = powerReqCruise_W + powerPayload_W + powerAvionics_W;
    % at night
    
    powerCharge_W = powerDischarge_W / etaFuelCell; % during day, by solar cells
    % assuming P_discharge = n_cell * P_charge
    
    powerSolarCell_W = powerReqLoiter_W + powerAvionics_W + powerCharge_W;
%         (aerodynamicPowerRequiredForCruising_W + payloadPower_W + avionicsPower_W)/fuelCellEfficiency;
    
    nextSw_m2 = powerSolarCell_W / (SOLAR_CONSTANT_Wpm2 * etaSolarCell * 0.6);
    % think of it either as only 60% of wing area being covered, or only
    % 60% of solar constant being available - it's likely a mix of both
    
    Sw_m2(iterNo+1) = (Sw_m2(iterNo) + nextSw_m2)/2; % for faster convergence
    errorSw_m2 = abs(Sw_m2(iterNo) - Sw_m2(iterNo+1));
    
    if errorSw_m2 < TOLERANCE_Sw_m2
        fprintf('\nSolution converged in %d iterations.\n',iterNo)
        massTakeoff_kg = weightTakeoff_N / g0_mps2;
        fprintf('\nTakeoff weight is %5.1f N (%4.1f kg).\n',...
            weightTakeoff_N,massTakeoff_kg)
        fprintf('\nWing planform area is %4.2f m^2.\n',Sw_m2(iterNo+1))
        return
    end

end

% fprintf(['\nSolution didn''t converge even though there have been %d'...
%          'iterations, current residual is %6.3f and tolerance is 
% Sw_m2(iterNo+1), weightTakeoff_N/g0_mps2