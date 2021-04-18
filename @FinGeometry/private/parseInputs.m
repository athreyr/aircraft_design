function [inputPropertiesList, valuesList] = parseInputs(Default, userInputValues)
% parseInputs parses and validates user inputs that contain optional inputs
% 
%   Helper function for class constructor.
% 
%   Meant for internal use only.

inputPropertiesList = {'referenceArea'; ...
                       'aspectRatio'; ...
                       'taperRatio'; ...
                       'sweepAngle_deg'; ...
                       'sweepLocation'};
valuesList = {Default.S; ...
              Default.AR; ...
              Default.TR; ...
              Default.lambda_deg; ...
              Default.lambdaRelPos};
                   
if isempty(userInputValues), return, end

[S, AR] = deal(userInputValues{1:2});

defaultValues = {Default.TR, Default.lambda_deg, Default.lambdaRelPos};
[TR, lambda_deg, lambdaRelPos] = setOptionalInputs(defaultValues, userInputValues(3:end));

valuesList = {S; AR; TR; lambda_deg; lambdaRelPos};

% validate user inputs
for argidx = 1:numel(valuesList) % since validation is same for all inputs
    try
        validateattributes(valuesList{argidx}, {'numeric'}, {'real', 'finite', 'scalar'})
    catch ME
        foostr = sprintf('Parse error at user input number %i:\n', argidx);
        ME = MException(ME.identifier, [foostr, ME.message]);
        ME.throwAsCaller
    end
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

if lambda_deg < -180 || lambda_deg > 180
    warning('FinGeometry:sweepAngle_deg:outOfBounds',...
            'Sweep angle (%3.1f deg) is not between -180 deg and 180 deg.',...
            sweepAngle_deg)
end

end

