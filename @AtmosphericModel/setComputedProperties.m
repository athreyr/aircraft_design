function ThisAtmosphericModel = ...
    setComputedProperties(ThisAtmosphericModel, OtherInputs)
%setComputedProperties      Sets properties after computing from inputs.
%   AM = AM.setComputedProperties(OtherInputs) reads the values of input
%   properties from AM and OtherInputs, computes the remaining properties,
%   and assigns it in AM.

% Compute specific gas constant
TRef = OtherInputs.TRef;
pRef = OtherInputs.pRef;
rhoRef = OtherInputs.rhoRef;
R = pRef / (rhoRef * TRef);

% Compute its units
Units = ThisAtmosphericModel.SaveUnits;
RUnit = Unit.evaluate(...
    [Units.pressure,'/(',Units.density,'*',Units.temperature,')']);
Units.gasConst_Mass = RUnit.symbol;

% Compute g0/R (in units of lapse rate)
g0_R = Unit.convert( ThisAtmosphericModel.ACCELERATION_DUE_TO_GRAVITY / R, ...
    ['(',Units.acceleration,')/(',Units.gasConst_Mass,')'], ...
    [Units.temperature,'/',Units.altitude]);

% Compute temperatures vs. geopotential altitudes from user inputs

if isfield(OtherInputs,'hG') % [hG T], [hGUb isGrad], Ref, SaveUnits
% object has T, so save h, hRegLim, lapseRates to it
    h = ThisAtmosphericModel.altitudeGeopotential(OtherInputs.hG);
    T = ThisAtmosphericModel.temperatures;
    hRegLim = ThisAtmosphericModel.altitudeGeopotential(OtherInputs.hGRegLim);
    isGrad = OtherInputs.isGradReg; 
    nRegs = numel(isGrad); % or numel(hRegLim) - 1

    % Find lapse rates by fitting temperature region-wise
    lapseRates = zeros(nRegs, 1);
    for thisReg = 1:nRegs
        thisRegIdx = (hRegLim(thisReg) <= h) & (h <= hRegLim(thisReg+1));
        if isGrad(thisReg)
            lineCoeffs = polyfit(h(thisRegIdx), T(thisRegIdx), 1);
            lapseRates(thisReg) = lineCoeffs(1);            
        end
    end
    
    % there's no concept of reference height in this form of constructor,
    % pressure has to be provided at hG(1) itself, so:
    iRef = 1;
    
    ThisAtmosphericModel.altitudesGeopotential = h;
    ThisAtmosphericModel.regionLimitsGeopotential = hRegLim;
    ThisAtmosphericModel.lapseRates = lapseRates;
    deltaT = 0;

else % deltaT, [hMax dh hMin], [hUb lapseRates], Ref, SaveUnits
% object has hRegLim, lapseRates, so save h and T to it
    hMin = OtherInputs.hMin;
    dh = OtherInputs.dh;
    hMax = OtherInputs.hMax;

    hRef = OtherInputs.hRef;
    h = [hMin:dh:(hRef-dh), hRef:dh:hMax].'; 
    % so that hRef is always included but not twice
    % (if dh > hRef - hMin, hMin will not be included - fixed in
    % parseInputs?)

    T = zeros(size(h));
    iRef = find(h > hRef,1) - 1; % because h is sorted
    T(iRef) = OtherInputs.TRef;
    
    lapseRates = ThisAtmosphericModel.lapseRates;
    T(1) = T(iRef) + lapseRates(1) * (h(1) - h(iRef));
    
    hRegLim = ThisAtmosphericModel.regionLimitsGeopotential;
    
    for thisReg = 1:numel(lapseRates)
        idx = find((hRegLim(thisReg) <= h) & (h <= hRegLim(thisReg+1)));
        T(idx(2:end)) = T(idx(1)) + ...
            lapseRates(thisReg) * (h(idx(2:end)) - h(idx(1)));
    end
        
    ThisAtmosphericModel.altitudesGeopotential = h;
    ThisAtmosphericModel.temperatures = T;
    deltaT = OtherInputs.deltaT;
    
end

% Compute pressures vs. altitudes from temperatures and lapse rates

h = ThisAtmosphericModel.altitudesGeopotential;
T = ThisAtmosphericModel.temperatures;
hRegLim = ThisAtmosphericModel.regionLimitsGeopotential;
lapseRates = ThisAtmosphericModel.lapseRates;

% extrapolate pRef to p(1) so that other p can be calculated in steps
p = zeros(size(h));
p(iRef) = OtherInputs.pRef;
if lapseRates(1)
    p(1) = p(iRef) * (T(1) / T(iRef)) .^ (-g0_R / lapseRates(1));
else
    p(1) = p(iRef) * exp( -g0_R / T(iRef) * (h(1) - h(iRef)) );
end

for thisReg = 1:numel(lapseRates)

    thisRegIdx = find((hRegLim(thisReg) <= h) & (h <= hRegLim(thisReg+1)));
    othidx = thisRegIdx(2:end);

    if lapseRates(thisReg) % gradient region
        T0 = T(thisRegIdx(1));
        p0 = p(thisRegIdx(1));
        p(othidx) = p0 * (T(othidx) / T0) .^ (-g0_R / lapseRates(thisReg));
    else % isothermal region
        h1 = h(thisRegIdx(1));
        T1 = T(thisRegIdx(1));
        p1 = p(thisRegIdx(1));
        p(othidx) = p1 * exp( -g0_R / T1 * (h(othidx) - h1) );
    end

end

% Compute density using perfect gas law and temperature offset
rho = p ./ (R * (T+deltaT));

% Set the object properties to the computed values
ThisAtmosphericModel.temperatures = T + deltaT; % add offset to temperature
ThisAtmosphericModel.pressuresStatic = p;
ThisAtmosphericModel.densities = rho;
ThisAtmosphericModel.SaveUnits = Units;
ThisAtmosphericModel.DisplayUnits = Units;
ThisAtmosphericModel.SPECIFIC_GAS_CONSTANT = R;

end
