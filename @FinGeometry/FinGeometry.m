classdef FinGeometry
    % FinGeometry is a template for reference wing, tail geometry, etc.
    %
    %   It doesn't contain any aerodynamic characteristics, just planar
    %   geometry like reference area, chordlengths, sweep angle, etc.
    
    properties (SetAccess = private)        
        referenceArea % S [L^2] (user input)
        aspectRatio % AR = b^2 / S [-] (user input)
        taperRatio % TR = cRoot / cTip [-] (user input)        
        fullspan % b = sqrt(S * AR) [L] (computed)
        rootChord % cRoot = 2 * S / (b * (1 + TR)) [L] (computed)
    end
    
    properties % public because these are only used for plot()
        sweepAngle_deg % Lambda [-] (user input)
        sweepLocation % xBar = x/c : del_Lambda(xBar)/del_y = 0 [-] (user input)
    end
    
    methods % public
        
        % constructor should be in the same m-file as that of class
        function ThisFinGeometry = FinGeometry(S, AR, varargin)
            % The constructor can be called the following ways:
            % ThisFinGeometry = FinGeometry(S, AR)
            % ThisFinGeometry = FinGeometry(S, AR, TR)
            % ThisFinGeometry = FinGeometry(S, AR, TR, lambda)
            % ThisFinGeometry = FinGeometry(S, AR, TR, lambda, lambdaRelPos)
            
            % construct default object whose properties will be overriden
            [propertiesList, defaultValues] = defaultObject('FinGeometry');
            for idx = 1:numel(propertiesList)
                ThisFinGeometry.(propertiesList{idx}) = defaultValues(idx);
            end
            
            if nargin == 0, return, end
            % constructor should work with no input arguments
            
            narginchk(2,5) % according to the multiple function signatures
            
            % modify the default object from inputs
            ThisFinGeometry = ...
                    ThisFinGeometry.setInputProperties(S, AR, varargin{:});
            
            % compute the remaining properties from inputs
            ThisFinGeometry = ThisFinGeometry.setComputedProperties;
            
        end % constructor
        
        % include the function signatures of the other methods
        chordlength = chord(ThisFinGeometry, y);
        disp(ThisFinGeometry)
        h = plot(ThisFinGeometry, varargin);
        
    end % public methods
    
    methods (Access = private, Hidden) % helper functions not meant for user
        ThisFinGeometry = setInputProperties(ThisFinGeometry, S, AR, varargin);
        ThisFinGeometry = setComputedProperties(ThisFinGeometry);
    end
    
end % class definition
