classdef FinGeometry
% FinGeometry is a template for reference wing, tail geometry, etc.
%
%   It doesn't contain any aerodynamic characteristics, just planar
%   geometry like reference area, chordlengths, sweep angle, etc.
% 
%   Examples:
%       WingGeom = FinGeometry(170, 6); % instantiation
%       c = WingGeom.chord(randn(23, 56, 7)) % chord at those locations
%       h = WingGeom.plot; % draws the wing planform
    
    
    properties (SetAccess = private)        
        referenceArea % S [L^2] (user input)
        aspectRatio % AR = b^2 / S [-] (user input)
        taperRatio % TR = cRoot / cTip [-] (user input)        
        fullspan % b = sqrt(S * AR) [L] (computed)
        rootChord % cRoot = 2 * S / (b * (1 + TR)) [L] (computed)
    end
    
    properties % public because these are only used for plot()
        sweepAngle_deg % lambda [-] (user input)
        sweepLocation % lambdaRelPos is the x/c where lambda is constant [-] (user input)
    end
    
    methods % public
        
        % constructor should be in the same m-file as that of class
        function ThisFinGeometry = FinGeometry(S, AR, varargin)
            % ThisFinGeometry = FinGeometry(S, AR, [TR = 1], [lambda = 0], [lambdaRelPos = 0])
            
            % get names of input properties and their default values
            [inputPropertiesList, inputValues] = defaultInputs('FinGeometry');
            
            if nargin > 0 % constructor should work with no input
                narginchk(2,5) % according to the multiple function signatures
                optionalInputsList = {'taperRatio'; 'sweepAngle_deg'; 'sweepLocation'};
                [~, optionalInputsIdx] = ismember(optionalInputsList, inputPropertiesList);
                defaultValues = inputValues(optionalInputsIdx);
                inputValues = parseInputs(S, AR, defaultValues, varargin{:}).';
            end
            
            % assign input properties to object
            for idx = 1:numel(inputPropertiesList)
                ThisFinGeometry.(inputPropertiesList{idx}) = inputValues(idx);
            end
            
            % compute the remaining properties from inputs
            ThisFinGeometry = ThisFinGeometry.setComputedProperties;
            
        end % constructor
        
        % include the function signatures of the other methods
        chordlength = chord(ThisFinGeometry, y);
        disp(ThisFinGeometry)
        varargout = plot(ThisFinGeometry, varargin);
        
    end % public methods
    
    methods (Access = private, Hidden) % helper functions not meant for user
        ThisFinGeometry = setComputedProperties(ThisFinGeometry);
        datapoints = planformCoordinates(ThisFinGeometry, varargin);
    end
    
end % class definition