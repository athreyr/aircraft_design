classdef AtmosphericModel
%AtmosphericModel   Reference atmosphere.
%   Template for reference atmosphere models from which temperature,
%   pressure, and density can be looked up, lapse rate can be found out,
%   etc.
% 
%   In the method signatures, a pipe ('|') preceeding an argument means
%   that the argument is optional.

% The comments in this class definition are written to produce properly
% formatted output with the help or doc commands, and will therefore not be
% user-friendly. If you are a user, you shouldn't have needed to open this
% anyway, since you should use those help and doc commands.

    properties (SetAccess = protected)
        
        % In unit SaveUnits.altitude
        %
        % See also geopotentialAltitude, SaveUnits, DisplayUnits.
        altitudesGeopotential
        
        % Outside Air Temperature (OAT) in unit SaveUnits.temperature
        %
        % This value is that of ABSOLUTE temperature, i.e. with unit 'K' or
        % '0R'. DO NOT use relative temperature units ('0C' or '0F'), by
        % passing it as a field of SaveUnits to the constructor, or
        % changing the field of DisplayUnits after an object has been
        % constructed.
        %
        % If you really need the temperature in '0C' or '0F' at a
        % particular altitude, you can pass isRelTemp argument as true when
        % calling the temperature() method.
        %
        % See also temperature, SaveUnits, DisplayUnits, convert.
        temperatures
        
        % In unit SaveUnits.pressure
        %
        % See also pressure, SaveUnits, DisplayUnits.
        pressuresStatic
        
        % In unit SaveUnits.density
        %
        % See also density, SaveUnits, DisplayUnits.
        densities
        
        % Extents of gradient/isothermal regions, in unit SaveUnits.altitude
        %
        % First element of the vector is altitudesGeopotential(1), and the
        % following ones are altitudes at which the lapse rate changes (or
        % becomes 0).
        %
        % See also lapseRates, lapseRate, SaveUnits, DisplayUnits.
        regionLimitsGeopotential
        
        % Change in temperature per unit altitude, in computed units
        %
        % Vector containing lapse rates of regions bounded by consecutive
        % elements of regionLimitsGeopotential, in unit
        % SaveUnits.temperature / SaveUnits.altitude. Isothermal regions
        % have a lapse rate of 0.
        %
        % See also lapseRate, regionLimitsGeopotential, SaveUnits,
        % DisplayUnits.
        lapseRates % VAL FOR ISO SHOULD BE NAN BECAUSE OF PRECISION --- ???
        
        % In unit SaveUnits.radius (user input)
        %
        % See also ACCELERATION_DUE_TO_GRAVITY, SPECIFIC_GAS_CONSTANT,
        % SaveUnits, DisplayUnits.
        RADIUS_OF_EARTH
        
        % In unit SaveUnits.acceleration (user input)
        %
        % See also RADIUS_OF_EARTH, SPECIFIC_GAS_CONSTANT, SaveUnits,
        % DisplayUnits.
        ACCELERATION_DUE_TO_GRAVITY
        
        % In unit SaveUnits.gasConst_Mass (computed)
        %
        % SaveUnits.gasConst_Mass is the same as SaveUnits.pressure / 
        % (SaveUnits.density * SaveUnits.temperature).
        %
        % See also RADIUS_OF_EARTH, ACCELERATION_DUE_TO_GRAVITY, SaveUnits,
        % DisplayUnits.
        SPECIFIC_GAS_CONSTANT
        
        % Struct containing units of the other properties
        % 
        % The fields are altitude, temperature, pressure, density, radius,
        % acceleration, and gasConst_Mass.
        %
        % To be passed to the class constructor if the supplied values for
        % these quantities are in units different from the default.
        %
        % If the object has already been created, the units can be changed
        % by changing the particular fields of DisplayUnits, to make the
        % object behave as if it were constructed using those units.
        %
        % See also DisplayUnits, convert.
        SaveUnits
        
    end
    
    properties
        % Struct used to change units of existing object
        % 
        % By default, all fields of DisplayUnits will have the same value
        % as that of SaveUnits, but they can be changed anytime to make the
        % object behave as if it were created using the new set of units.
        % 
        % See also SaveUnits, convert.
        DisplayUnits 
    end
    
    methods
        
        % constructor has to be in the same m-file as that of class
        function ThisAtmosphericModel = AtmosphericModel(varargin)
        %AtmosphericModel   Class constructor
        %   AM = AtmosphericModel creates the object AM representing the
        %   International Standard Atmosphere (ISA). See 
        %   documentation\atmosphere.docx for details.
        %   
        %   In the following signatures, default value of each argument can
        %   be found in data\default_inputs\AtmosphericModel.txt.
        %
        %   AM = AtmosphericModel(deltaT, |[hMax dh hMin], ...
        %       |[hUb lapseRates], |Ref, |SaveUnits);
        %   creates a reference atmosphere AM from the following mandatory
        %   inputs:
        %       deltaT -- temperature offset from ISA, scalar (#)
        %   and these optional inputs:
        %       [hMax dh hMin] -- upper limit, precision (step-size), and
        %           lower limit of geopotential altitudes in AM,
        %           respectively. Use NaN to skip entering the full array.
        %       [hUb, lapseRates] -- upper geopotential altitude bounds of
        %           regions in AM, and their lapse rates. The highest bound
        %           should be equal to or greater than hMax.
        %       Ref -- struct with fields (all of which are optional):
        %           h (reference geopotential altitude, conditions at which
        %               are used to compute specific gas constant of air,
        %               which should be greater than or equal to hMin + dh)
        %           T (temperature at reference altitude)
        %           p (pressure at reference altitude)
        %           rho (density at reference altitude)
        %           RADIUS_OF_EARTH
        %           ACCELERATION_DUE_TO_GRAVITY
        %       SaveUnits -- struct denoting units in which corresponding
        %           types of values are present in AM, with fields (all of
        %           which are optional):
        %           altitude
        %           temperature
        %           pressure
        %           density
        %           radius
        %           acceleration
        %
        %   (#) Support for non-scalar temperature offsets, i.e. different
        %       offsets for different altitude regions, will be added in
        %       a future release.
        %
        %   -------------------------- BETA -------------------------------
        %   AM = AtmosphericModel([hG T], [hGUb isGrad], |Ref, |SaveUnits)
        %   creates a reference atmosphere AM from the following mandatory
        %   inputs:
        %       [hG, T] -- geometric altitudes and temperatures
        %           corresponding to them, respectively
        %       [hGUb, isGrad] -- upper geometric altitude bounds, and
        %           column containing 1 for each gradient region and 0 for
        %           each isothermal region, respectively
        %   and these optional inputs:
        %       Ref -- struct with fields (all of which are optional):
        %           T, p, rho (conditions used to compute specific gas
        %               constant of air(!))
        %           RADIUS_OF_EARTH
        %           ACCELERATION_DUE_TO_GRAVITY
        %       SaveUnits -- same as in the previous signature
        %
        %   (!) Altering these fields from their default values is NOT
        %       RECOMMENDED, because support for this approach is limited
        %       and accuracy is not guaranteed.
            
            % get names of input properties and their default values
            Default = defaultInputs('AtmosphericModel');
            
            if nargin > 0 % constructor should work with no input
                narginchk(1,5) % according to the multiple function signatures
            end
            
            [inputPropertiesList, valuesList, OtherInputs] = ...
                parseInputs(Default, varargin);
            
            % assign input properties to object
            for iprop = 1:numel(inputPropertiesList)
                ThisAtmosphericModel.(inputPropertiesList{iprop}) = ...
                    valuesList{iprop};
            end
            
            % compute the remaining properties from inputs
            ThisAtmosphericModel = ...
                ThisAtmosphericModel.setComputedProperties(OtherInputs);
            
        end % constructor
        
        % include signatures of other methods in class definition
        h = geopotentialAltitude(ThisAtmosphericModel, hG, varargin);
        hG = geometricAltitude(ThisAtmosphericModel, h, varargin);
        T = temperature(ThisAtmosphericModel, hG, varargin);
        p = pressure(ThisAtmosphericModel, hG, varargin);
        rho = density(ThisAtmosphericModel, hG, varargin);
        a = lapseRate(ThisAtmosphericModel, hG, varargin);
        hG = densityAltitude(ThisAtmosphericModel, rho, varargin);
        hG = pressureAltitude(ThisAtmosphericModel, p, varargin);

    end % public methods
    
    methods (Access = protected, Hidden)
%         disp(ThisAtmosphericModel)
        ThisAtmosphericModel = setComputedProperties(ThisAtmosphericModel, ...
            OtherInputs);
    end
    
    methods (Access = protected, Hidden)
        val = lookup(ThisAtmosphericModel, propname, hG, units);
        hG = invlookup(ThisAtmosphericModel, propname, val, units);
        % C = vertcat(varargin); % for non-scalar deltaT (WON'T WORK)---!!!
    end
    
end % AtmosphericModel
