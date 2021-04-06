classdef FinGeometry
    %WING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        referenceArea
        aspectRatio
        fullspan
        taperRatio
        rootChord
    end
    
    properties
        sweepAngle_deg
        sweepLocation
    end
    
    methods
        function ThisFinGeometry = FinGeometry(S,AR,varargin)
            %WING Construct an instance of this class
            %   Detailed explanation goes here                 
            narginchk(2,5)
            switch nargin
                case 2
                    TR = 1;
                    lambda = 0;
                    lambdaRelPos = 0;
                case 3
                    TR = deal(varargin{:});
                    lambda = 0;
                    lambdaRelPos = 0.25;
                case 4
                    [TR,lambda] = deal(varargin{:});
                    lambdaRelPos = 0.25;
                case 5
                    [TR,lambda,lambdaRelPos] = deal(varargin{:});
                otherwise
                    % do nothing
%                     if nargin < 2, error(message('MATLAB:minrhs')), end
%                     if nargin > 5, error(message('MATLAB:TooManyInputs')), end
            end % switch number of inputs
            
            if TR < 0 || TR > 1
                warning(['Taper ratio is unconventional. Results may be '...
                         'infeasible.'])
            end
            
            % compute entire geometry from inputs
            b = sqrt(S * AR);
            cRoot = 2 * S / (b * (1 + TR));
            
            ThisFinGeometry.referenceArea = S;
            ThisFinGeometry.aspectRatio = AR;
            ThisFinGeometry.fullspan = b;
            ThisFinGeometry.taperRatio = TR;
            ThisFinGeometry.rootChord = cRoot;
            ThisFinGeometry.sweepAngle_deg = lambda;
            ThisFinGeometry.sweepLocation = lambdaRelPos;
        end
        %{
        function ThisFinGeometry = set.referenceArea(ThisFinGeometry,S)
            ThisFinGeometry.referenceArea = S;
            ThisFinGeometry.aspectRatio = AR;
            ThisFinGeometry.fullspan = b;
            ThisFinGeometry.taperRatio = TR;
            ThisFinGeometry.rootChord = cRoot;
        end
        %}
        chordVal = chord(ThisWing,y);
        disp(ThisWing);
        h = plot(ThisWing,varargin);
    end
end

