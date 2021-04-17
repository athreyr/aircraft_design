classdef FoilGeometry
    %FOILGEOMETRY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        abcissas
        ordinates
        perimeter
        area
        centroidPerimeter % "perimeter centroid" is a real thing
        centroidArea
        thicknessChord
%         thicknessCamber
        camber
        coordinatesFormat % computed (only 'selig' or 'lednicer' for now)
    end
    
    properties % public
        name % defaults to name of datasrc, just change afterwards
    end
    
    methods
        function ThisFoilGeometry = FoilGeometry(varargin)
        % ThisFoilGeometry = FoilGeometry(datasrc, [nHeaderRows = 1], [nLeadCols = 0])
        % ThisFoilGeometry = FoilGeometry(abcissas, ordinates, [name = 'untitled'])
        
            % get names of input properties and their default values
            Default = defaultInputs('FoilGeometry');
            
            if nargin > 0 % constructor should work with no input
                narginchk(1,3) % according to the multiple function signatures
%                 optionalInputsList = {'abcissas', 'ordinates', 'name'};
%                 [~, optionalInputsIdx] = ismember(optionalInputsList, propertiesList);
%                 defaultValues = valuesList(optionalInputsIdx).';
%                 defaultUserInputValues = {1, 0};
%                 defaultValues = [defaultUserInputValues, defaultPropertyValues];
%                 [propertiesList, valuesList] = parseInputs(defaultValues, varargin);
            end
            
            [inputPropertiesList, valuesList] = parseInputs(Default, varargin);
            
            % assign input properties to object
            for iProp = 1:numel(inputPropertiesList)
                ThisFoilGeometry.(inputPropertiesList{iProp}) = valuesList{iProp};
            end
            
            % compute the remaining properties from inputs
            ThisFoilGeometry = ThisFoilGeometry.setComputedProperties;
            
        end
        
        [tmax, xT] = maxThickness(ThisFoilGeometry);
        [cMax, xC] = maxCamber(ThisFoilGeometry);
        disp(ThisFoilGeometry)
        varargout = plot(ThisFoilGeometry, varargin);
        [xnew, ynew] = switchCoordinatesFormat(ThisFoilGeometry, toFormat);
    end
    
    methods (Access = private, Hidden)
        ThisFoilGeometry = setComputedProperties(ThisFoilGeometry);
        ThisFoilGeometry = setCoordinatesFormat(ThisFoilGeometry);
    end
    %{
%     methods (Static)
%         coordFormat = determineCoordinatesFormat(coords);
%         [xnew, ynew] = switchCoordinatesFormat(x, y, fromFormat, toFormat);
%         UserInputs = unpackInputs(varargin);
%         Props = computeProperties(UserInputs);
%         [newAbcissas,newOrdinates] = makeValid(abcissas,ordinates);
%         varargout = convertDataFormat(dataPoints,toFormatName);
%     end
    %}
end

