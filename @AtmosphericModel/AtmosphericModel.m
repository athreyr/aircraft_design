classdef AtmosphericModel
    %ATMOSPHERICMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        altitudesGeopotential
        temperatures
        pressuresStatic
        densities
        regionLimitsGeopotential
        % isGradientRegions
        lapseRates
        % isothermalTemperatures
        RADIUS_OF_EARTH
        ACCELERATION_DUE_TO_GRAVITY
        SPECIFIC_GAS_CONSTANT
    end
    %
    properties
        % keep units access as public because user might have forgotten
        % to include them while constructing
        SaveUnits
        DisplayUnits
    end
    %}
    methods
        
        % constructor has to be in the same m-file as that of class
        function ThisAtmosphericModel = AtmosphericModel(varargin)
        % AM = AtmosphericModel(mfilename, 
            
            % get names of input properties and their default values
            Default = defaultInputs('AtmosphericModel');
            
            if nargin > 0 % constructor should work with no input
                narginchk(1,5) % according to the multiple function signatures
            end
            
            [inputPropertiesList, valuesList, OtherInputs] = ...
                parseInputs(Default, varargin);
            
            % assign input properties to object
            for idx = 1:numel(inputPropertiesList)
                ThisAtmosphericModel.(inputPropertiesList{idx}) = valuesList{idx};
            end
            
            % compute the remaining properties from inputs
            ThisAtmosphericModel = ...
                ThisAtmosphericModel.setComputedProperties(OtherInputs);
            
        end % constructor
                
        h = geopotentialAltitude(ThisAtmosphericModel, altitudeGeometric, varargin);
        % rename as geopoentialAltitude (like pressure, density altitudes)
        T = temperature(ThisAtmosphericModel, altitudeGeometric, varargin);
        p = pressure(ThisAtmosphericModel, altitudeGeometric, varargin);
        rho = density(ThisAtmosphericModel, altitudeGeometric, varargin);
%         valOut = convertUnit(valIn, fromUnit);
%         ThisAtmosphericModel = modify(propertyName, newVal);
        hG = densityAltitude(ThisAtmosphericModel, rho, varargin);
        hG = pressureAltitude(ThisAtmosphericModel, p, varargin);
        a = lapseRate(ThisAtmosphericModel, altitudeGeometric, varargin);
        hG = geometricAltitude(ThisAtmosphericModel, h, varargin);

    end
    
    methods (Access = protected, Hidden)
        val = lookup(ThisAtmosphericModel, propq, altitudeGeometric, varargin);
        hG = invlookup(ThisAtmosphericModel, propname, propval, varargin);
        % vertcat
        % for concatenating different tables
    end
    
%     methods (Static, Hidden)
%         UserInputs = unpackInputs(varargin);
%         Props = computeProperties(UserInputs);
%     end
end

