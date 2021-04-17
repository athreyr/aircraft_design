function sweepAngle = sweep(ThisFinGeometry, xBar, varargin)
%SWEEP Summary of this function goes here
%   Detailed explanation goes here

narginchk(2,3)

if any(xBar < 0, 'all') || any(xBar > 1, 'all')
    warning('FinGeometry:sweep:outOfBounds',...
            ['Sweep does not exist at one or more queried locations,'...
             'Results may be infeasible.'])
end
    
AR = ThisFinGeometry.aspectRatio;
TR = ThisFinGeometry.taperRatio;
lambda_deg = ThisFinGeometry.sweepAngle_deg;
xLambda = ThisFinGeometry.sweepLocation;

const = tand(lambda_deg) + 4/AR * (1-TR)/(1+TR) * xLambda;

angleUnit = 'deg';
if ~isempty(varargin), angleUnit = varargin{:}; end

if strcmpi('deg', angleUnit)
    sweepAngle = atand(const -  4/AR * (1-TR)/(1+TR) * xBar);
elseif strcmpi('rad', angleUnit)
    sweepAngle = atan(const -  4/AR * (1-TR)/(1+TR) * xBar);
else
    ME = MException('FinGeometry:sweep:invalidInput',...
                    ['Conversion from degree to %s not available (yet).',...
                     ' Please use ''deg'' or ''rad'' for now.'],...
                     angleUnit);
    ME.throw;
end

end

