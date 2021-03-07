%%  Create a lookup table for the Indian Reference Atmosphere (IRA)
% 
%   makeIra reads the empirical data of temperature at every altitude of a
%   (non-standard) atmosphere from file, and creates a structure for the
%   same. The altitude limits of each region of the atmosphere should be
%   explicitly coded, along with their types (gradient or isothermal).
% 
%   From this information, makeIra creates the best fit lines of the
%   empirical data in each region, and saves the lapse rates (for gradient
%   regions) and temperature values (for isothermal regions) in the same
%   structure.
% 
%   If you are using the findTemperaturePressureDensity function to obtain
%   conditions based on the Indian Reference Atmosphere (IRA), you do NOT
%   have to run makeIra, because the MAT-file containing the IRA structure
%   (i.e. the result of running this script) is included with the package.
% 
%   You only need to run makeIra if you need to update said MAT-file, e.g.
%   because you wish to change the names of the variables, or want to read
%   the empirical data from another source, etc.
% 
%   To save the IRA structure (and other constants used to create it),
%   uncomment the last line of this program (see last section).
% 
%   Sections can be skipped from execution by adding a left brace { after
%   the % sign in the first line of each section. This is useful for
%   debugging only particular sections.

%   Copyright 2021 Athrey Ranjith Krishnanunni

%% Read data from file and pre-process it
%{
% clear
dataFilename = 'IRA_1994_temperature.csv'; % Sasi (1994) IJRSP 23(5)
geometricHeightAndTemperatureData = csvread(dataFilename,10,0);

IRA = struct; % initialise Indian Reference Atmosphere structure
IRA.hG_km = geometricHeightAndTemperatureData(:,1); % geometric heights (km)
IRA.T_K = geometricHeightAndTemperatureData(:,2); % temperatures (K)

% NOTE:
% It might be a good idea to use reshape() to ensure that hG_km and T_K
% are column vectors if they're read from another source, like the output
% of another function

if ~issorted(IRA.hG_km)
    [IRA.hG_km,sortedIdx] = sort(IRA.hG_km);
    IRA.T_K = IRA.T_K(sortedIdx);
end

% plot(IRA.T_K,IRA.hG_km), return
% uncomment above line to see where slope (1/lapse rate) changes, or
% becomes infinite (isothermal region), and then record the altitude limits
% of each region in the below variable
IRA.hGRegionLim_km = [0 17 44 50 75 77 79 80];

IRA.isGradientRegion = [true, true, false, true, true, true, false];
% type of region between each altitude limit, false means isothermal

IRA.nRegions = numel(IRA.isGradientRegion);
if numel(IRA.hGRegionLim_km) ~= IRA.nRegions + 1
    error('Number of altitude limits should be one more than number of regions.')
end
%}
%% Find geopotential altitudes and fit temperature data region-wise
%{
CONST_RADIUS_OF_EARTH_m = 6356766;

IRA.h_m = IRA.hG_km * 1000 * CONST_RADIUS_OF_EARTH_m ./ ...
         (IRA.hG_km * 1000 + CONST_RADIUS_OF_EARTH_m);
% geopotential heights (m)

IRA.nGradientRegions = nnz(IRA.isGradientRegion); % number of true values
IRA.nIsothermalRegions = IRA.nRegions - IRA.nGradientRegions;

IRA.coeffBestFitLine = zeros(2,IRA.nGradientRegions);
IRA.temperatureVal_K = zeros(1,IRA.nIsothermalRegions);

iGradientRegion = 1;
iIsothermalRegion = 1;

for thisRegion = 1 : IRA.nRegions
    
    iThisRegion = (IRA.hGRegionLim_km(thisRegion) <= IRA.hG_km) & ...
                  (IRA.hG_km <= IRA.hGRegionLim_km(thisRegion+1));
    % including both upper and lower limits in the index range does not
    % lead to overwriting because they are saved separately (also see
    % similar comment in the pressure loop)
    
    yTemperature_K = IRA.T_K(iThisRegion);
    xHeight_m = IRA.h_m(iThisRegion); % data points for fitting
               
    if IRA.isGradientRegion(thisRegion)
        IRA.coeffBestFitLine(:,iGradientRegion) = ...
                                       polyfit(xHeight_m,yTemperature_K,1);
        iGradientRegion = iGradientRegion + 1;
    else
        IRA.temperatureVal_K(iIsothermalRegion) = mean(yTemperature_K);
        iIsothermalRegion = iIsothermalRegion + 1;
    end
    
end
%}
%% Build pressure, density charts from temperature data and reference values
%
IRA.p_Pa = zeros(size(IRA.hG_km)); % pressures (Pa)
IRA.p_Pa(1) = 101325; % reference pressure (1 atm)

CONST_g0_mps2 = 9.805; % acceleration due to gravity at sea level (m/s2)
CONST_R_JpkgK = 287; % specific gas constant of air (J/kgK)
g0_R = CONST_g0_mps2 / CONST_R_JpkgK; % g0/R

iGradientRegion = 1;
iIsothermalRegion = 1;

for thisRegion = 1 : IRA.nRegions
    
    iThisRegion = find((IRA.hGRegionLim_km(thisRegion) <= IRA.hG_km) & ...
                       (IRA.hG_km <= IRA.hGRegionLim_km(thisRegion+1)));
    % including both upper and lower limits in the index range is necessary
    % because conditions at upper limit of one region serve as the
    % reference values for populating the remaining indices of the next

    idx = iThisRegion(2:end); % index to populate elements other than 1st
    
    if IRA.isGradientRegion(thisRegion)
        
        T0 = IRA.T_K(iThisRegion(1));
        p0 = IRA.p_Pa(iThisRegion(1));
        % conditions at lower altitude limit of this (gradient) region
        
        lapseRate_Kpm = IRA.coeffBestFitLine(1,iGradientRegion);
        
        IRA.p_Pa(idx) = p0 * (IRA.T_K(idx) / T0) .^ (-g0_R / lapseRate_Kpm);
        
        iGradientRegion = iGradientRegion + 1;
        
    else
        
        p1 = IRA.p_Pa(iThisRegion(1));
        h1 = IRA.h_m(iThisRegion(1));
        % conditions at lower altitude limit of this (isothermal) region

        T1 = IRA.temperatureVal_K(iIsothermalRegion);
        
        IRA.p_Pa(idx) = p1 * exp( -g0_R / T1 * (IRA.h_m(idx) - h1) );
        
        iIsothermalRegion = iIsothermalRegion + 1;
        
    end
    
end

% find density from perfect gas law
IRA.rho_kgpm3 = IRA.p_Pa ./ (CONST_R_JpkgK * IRA.T_K); % densities (kg/m3)

% save('IndianReferenceAtmosphere_Sasi1994.mat','IRA','CONST_*')
% uncomment above line to save the Indian Reference Atmosphere structure
% and all the external constants that were used to construct it
%}
