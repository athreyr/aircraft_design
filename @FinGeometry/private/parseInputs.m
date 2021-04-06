function inputValues = parseInputs(defaultVals, S, AR, varargin)
% setInputProperties parses, validates, and sets specific object properties 
% 
%   This is a helper function for the class constructor. It's a non-static
%   method because it requires access to the object being constructed.
% 
%   Meant for internal use only.

% parse those inputs
TR = defaultVals(1);
lambda = defaultVals(2);
lambdaRelPos = defaultVals(3);
switch numel(varargin)
    case 1
        TR = varargin;
    case 2
        [TR, lambda] = deal(varargin{:});
    case 3
        [TR, lambda, lambdaRelPos] = deal(varargin{:});
    otherwise
        % do nothing
end % switch number of optional inputs

% validate the inputs
try
    inputValues = [S, AR, TR, lambda, lambdaRelPos]; % may throw horzcat error 
    validateattributes(inputValues, {'numeric'}, {'real', 'finite', 'vector'})
catch ME
    throwAsCaller(ME)
end

% issue warnings about potentially infeasible physical values
if lambdaRelPos < 0 || lambdaRelPos > 1
    warning('FinGeometry:sweepLocation:outOfBounds',...
           ['Location of constant sweep angle relative to chordlength '...
            '(%3.2f) is not between 0 and 1.'],...
            lambdaRelPos)
end

if TR < 0 || TR > 1
    warning('FinGeometry:taperRatio:outOfBounds',...
            'Taper ratio (%3.2f) is not between 0 and 1.',...
            TR)
end

if sweepAngle_deg < -180 || sweepAngle_deg > 180
    warning('FinGeometry:sweepAngle_deg:outOfBounds',...
            'Sweep angle (%3.1f deg) is not between -180 deg and 180 deg.',...
            sweepAngle_deg)
end

%{
% assign values of specific properties corresponding to inputs
inputProperties = defaultObject('FinGeometry');
for argIdx = 1:numel(argin)
    if ~isempty(argin(argIdx))
        ThisFinGeometry.(inputProperties{argIdx}) = argin(argIdx);
    end
end
%}


end

