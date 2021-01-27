function [temperature_K, pressure_Pa, density_kgpm3] = ...
                     findTemperaturePressureDensity(thisGeometricHeight_km)
%Returns atmospheric conditions at queried geometric altitudes (vectorized)
% 
%   findTemperaturePressureDensity accepts a matrix (with arbitrary
%   dimensions) of geometric altitudes (in km) as input, and returns the
%   temperature (in K), pressure (in Pa), and density (in kg/m3) at those
%   altitudes (supports vectorization).
% 
%   It does so by loading a lookup table for the reference atmosphere from
%   file into memory, and then interpolating between the recorded points to
%   get the results at the queried heights.
% 
%   If the input contains any element that is not a real number, or if any
%   of the queried heights are out-of-range for the lookup table, the
%   function produces a warning, but continues to execute. In such a
%   situation, the outputs at the remaining heights SHOULD be unaffected.
%
%   If all the output variables are not needed, one or more of them can be
%   suppressed using ~.
% 
%   Examples:
%       [T, p, rho] = findTemperaturePressureDensity(25)
%       returns the temperature, pressure, and density (in SI units) at
%       a geometric altitude of 25 km AMSL in the variables T, p, and rho
%       respectively.
% 
%       [~, p, ~] = findTemperaturePressureDensity([2:6:50])
%       returns the pressures alone at every 6 km interval from 2 to 50 km
%       AMSL in the variable p.
% 
%       [~, p, rho] = findTemperaturePressureDensity([20:30;50:60])
%       returns the pressures and  densities at every 1 km interval from 20
%       to 30 km, and between 50 and 60 km AMSL in the variables p and rho.
%       Here, size(p) = [2 11], same as size(rho), and equal to size of the
%       input matrix.
% 
%   See also makeIra, plotIraCharts.

%   Copyright 2021 Athrey Ranjith Krishnanunni

if any(~isreal(thisGeometricHeight_km)) || ...
                                    any(~isnumeric(thisGeometricHeight_km))
    warning('The input contains elements that are not real numbers.')
end

load('IndianReferenceAtmosphere_Sasi1994.mat','IRA','CONST_RADIUS_OF_EARTH_m')

if any(thisGeometricHeight_km < IRA.hG_km(1),'all') || ...
                         any(thisGeometricHeight_km > IRA.hG_km(end),'all')
    warning('The input contains heights outside the range of recorded data.')
end

queryHeight_m = thisGeometricHeight_km * 1000 * CONST_RADIUS_OF_EARTH_m ./ ...
               (thisGeometricHeight_km * 1000 + CONST_RADIUS_OF_EARTH_m);
% geopotential heights (m) at which the information is queried

queryResult = interp1(IRA.h_m,[IRA.T_K, IRA.p_Pa, IRA.rho_kgpm3],queryHeight_m);

% interp1() will return all the interpolated results together in a single
% variable, so the required outputs will have to be unpacked from it.
% Since the query heights could, in general, be in the form of a
% multidimensional array, so could queryResult, albeit with one more
% higher dimension. Therefore, we need to extract all the inner dimensions
% of queryResult and vary the index of the outermost dimension from 1 to 3.

% This requires writing queryResult(:,:,...,1) and so on, except that we
% don't know how many colons will be required. Hence, we need an indexing
% system that will evaluate to ':' sometimes and 1, 2, ... at others. This
% can be achieved using cells.

% The following piece of code was inspired from Matt Fig's answer to
% <a href="matlab:web('https://in.mathworks.com/matlabcentral/answers/49904
% -accessing-certain-dimension-of-multidimensional-array#answer_60965')">
% "Accessing certain dimension of multi-dimensional array"</a>

idx = repmat({':'},[1 ndims(queryResult)]);
% idx = {':'} {':'} ... {':'}, length(idx)= number of dimensions of queryResult

idx{end} = 1;
% replaces content of last cell with [1], i.e. idx = {':'} ... {':'} {[1]}
% idx{:} will now produce the CONTENT inside all the cells, so that
% queryResult(idx{:}) will access all its innermost dimensions, with the
% outermost dimension set to 1.
temperature_K = queryResult(idx{:});

idx{end} = 2;
pressure_Pa = queryResult(idx{:});
% pressure is stored along 2nd index of outermost dimension of queryResult

idx{end} = 3;
density_kgpm3 = queryResult(idx{:});

end