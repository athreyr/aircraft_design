classdef AtmosphericModel
    %ATMOSPHERICMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        Table = struct('altitudeGeopotential',[],...
                       'temperature',[],...
                       'pressureStatic',[],...
                       'density',[]);
        RADIUS_OF_EARTH = 6356766; % m, later converted to user units
    end
    
    properties
        % keep units access as public because user might have forgotten
        % to include them while constructing
        % other case of modifying it can be handled with the public modify
        % method
        units = struct('altitude','km',...
                       'temperature','K',...
                       'pressure','Pa',...
                       'density','kg/m^3');
    end
    
    methods
        function ThisAtmosphericModel = AtmosphericModel(varargin)
            %hG,hGUnit,T,TUnit,p,pUnit,rho,rhoUnit,unitconversion)
            UserInputs = AtmosphericModel.unpackInputs(varargin);
            Props = AtmosphericModel.computeProperties(UserInputs);
            
            ThisAtmosphericModel.Table = Props.Table;
            ThisAtmosphericModel.units = Props.units;
            ThisAtmosphericModel.RADIUS_OF_EARTH = ...
                ThisAtmospheriModel.convertUnit(ThisAtmosphericModel.RADIUS_OF_EARTH, 'm');
            
            %ATMOSPHERICMODEL Construct an instance of this class
            %   Detailed explanation goes here
            %{
            
%             ThisAtmosphericModel.make(varargin)
%             narginchk(1,2)

            switch nargin
                case 1
                    filename = varargin;
%                 case 2
%                     filename = 
                
            end
            
            fileID = fopen(unitconversion);
            filedata = textscan(fileID,'%s %f');
            fclose(fileID);
            convertFrom = cell2struct(filedata(:,2),filedata(:,1),1);
            
            hG_m = hG * convertFrom.(hGUnit);
            T_K = T * convertFrom.(TUnit);
            p_Pa = p * convertFrom.(pUnit);
            rho_kgpm3 = rho * convertFrom.(rhoUnit);
            %}
        end
        
        h = altitudeGeopotential(altitudeGeometric,varargin);
        T = temperature(altitudeGeometric,varargin);
        p = pressure(altitudeGeometric,varargin);
        rho = density(altitudeGeometric,varargin);
        valOut = convertUnit(valIn,fromUnit);
        ThisAtmosphericModel = modify(propertyName,newVal);
        
    end
    
    %{
    methods (Access = protected)
        h = geopotentialAltitude(geometricAltitude, RADIUS_OF_EARTH);
    end
    %}
    methods (Static, Hidden)
        UserInputs = unpackInputs(varargin);
        Props = computeProps(UserInputs);
    end
end

