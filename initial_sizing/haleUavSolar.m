%%  Estimate weight and wing area of HALE UAV with solar and fuel cells
% 
%   haleUavSolar is used to calculate the initial estimates of takeoff
%   weight and wing planform area of a High Altitude Long Endurance
%   Unmanned Aerial Vehicle (HALE UAV) whose lifting surfaces (wings and
%   horizontal stabilizers) are covered with solar cells. These provide
%   power for daytime flight and also recharge fuel cells that power 
%   nighttime flight.
% 
%   The values of the variables used in haleUavSolar are taken from Romeo
%   et al. (2004), "HELIPLAT(R): Design, Aerodynamic, Structural Analysis
%   of Long-Endurance Solar-Powered Stratospheric Platform", Journal of
%   Aircraft, Vol. 41, No. 6, pp. 1505 - 1520. For more information
%   regarding the equations used in this program, refer that paper.
% 
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
cruisingAltitude_km = 15;
loiteringAltitude_km = 15;
% check if \ira\ is on the MATLAB path
try
    [~,~,rhoCruise_kgpm3] = findTemperaturePressureDensity(cruisingAltitude_km);
catch ME
    if strcmp(ME.identifier,'MATLAB:UndefinedFunction')
        msg = ['aircraft_design\\ira\\ is not on the MATLAB path. Execute '...
               'runMeFirst.m to add the entire aircraft_design folder to '...
               'the MATLAB path.'];
        ME = MException('MATLAB:ira:notOnPath',msg);
    end
    throw(ME)
end
[~,~,rhoLoiter_kgpm3] = findTemperaturePressureDensity(loiteringAltitude_km);
%}
%% Calculate takeoff weight and wing area
%
MAX_ITERATIONS = 30;
TOLERANCE_Sw_m2 = 0.01; % precision required for wing planform area (in m2)

Sw_m2 = zeros(1,MAX_ITERATIONS+1);
Sw_m2(1) = 176; % initial guess (same as that of HeliPlat)

for iterNo = 1:MAX_ITERATIONS
    
    weightAirframe_N = 8.75 * nLim^0.311 * AR^0.4665 * Sw_m2(iterNo)^0.7775;
    
    weightTakeoff_N = (weightPayload_N + weightAirframe_N) / ...
                      (1 - sum(weightFractions));
    
    powerReqCruise_W = Sw_m2(iterNo) * sqrt(2/rhoCruise_kgpm3) * ...
        (weightTakeoff_N/Sw_m2(iterNo))^1.5 / (Cl3p2_CdCruise * etaProp);

    powerReqLoiter_W = Sw_m2(iterNo) * sqrt(2/rhoLoiter_kgpm3) * ...
        (weightTakeoff_N/Sw_m2(iterNo))^1.5 / (Cl3p2_CdLoiter * etaProp);

    powerDischarge_W = powerReqCruise_W + powerPayload_W + powerAvionics_W;
    % at night
    
    powerCharge_W = powerDischarge_W / etaFuelCell;
    % assuming P_discharge = eta_fuelcell * P_charge
    
    powerSolarCell_W = powerReqLoiter_W + powerAvionics_W + powerCharge_W;
    % during the day
    
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
            
        roundedSw_m2 = TOLERANCE_Sw_m2 * round(Sw_m2(iterNo+1)/TOLERANCE_Sw_m2);
        fprintf('\nWing planform area is %g m^2.\n',roundedSw_m2)
        return
    end

end

fprintf(['\nWing area did not converge even though there has been\n'...
           '%d iterations. Current residual is %g m^2 and\n'...
           'tolerance is %g m^2.\n'],...
           MAX_ITERATIONS,errorSw_m2,TOLERANCE_Sw_m2);
      