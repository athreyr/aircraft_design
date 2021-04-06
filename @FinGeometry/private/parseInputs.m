function inputValues = parseInputs(S, AR, defaultValues, varargin)
% parseInputs parses and validates user inputs that contain optional inputs
% 
%   Helper function for class constructor.
% 
%   Meant for internal use only.

[TR, lambda, lambdaRelPos] = setOptionalInputs(defaultValues, varargin{:});

% validate user inputs
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

if lambda < -180 || lambda > 180
    warning('FinGeometry:sweepAngle_deg:outOfBounds',...
            'Sweep angle (%3.1f deg) is not between -180 deg and 180 deg.',...
            sweepAngle_deg)
end

end

