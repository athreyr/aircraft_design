classdef AtmosphericModel
    %ATMOSPHERICMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        geometricAltitude
        geometricAltitudeUnit
        temperature
        temperatureUnit
        staticPressure
        staticPressureUnit
        density
        densityUnit
    end
    
    properties
        displayUnits = struct('altitude','km',...
                              'temperature','K',...
                              'pressure','Pa',...
                              'density','kg/m^3');
        convertFrom = struct('ft', 0.3048,...
                             'm',  0.001, ...
                             'nm', 1.852);%, ...
    end
    
    methods
        function obj = AtmosphericModel(hG,hGUnit,T,TUnit,P,PUnit,rho,rhoUnit)
            %ATMOSPHERICMODEL Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = hG + T;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

