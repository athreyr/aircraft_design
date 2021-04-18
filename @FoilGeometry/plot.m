function varargout = plot(ThisFoilGeometry, varargin)
% plot overloads the builtin plot function for FoilGeometry class
% 
%   Depending on the number of outputs in the function call, it exhibits
%   different behaviour as follows:
%
%   ThisFoilGeometry.plot() draws the planform of the foil in the current
%   axes and returns no output.
% 
%   h = ThisFoilGeometry.plot() returns the handle to the plot in h.
% 
%   [x, y] = ThisFoilGeometry.plot() returns the abcissas and ordinates of
%   the foil in x and y respectively. The order of the coordinates are such
%   that plot(x, y) creates a closed figure. This syntax does not generate
%   a plot.
% 
%   The input arguments to this function are same as that of the builtin
%   plot() function, including target axes and Name-Value pairs.

nargoutchk(0,2) % according to function output signatures

% input argument checking will be done inside the builtin plot function and
% exceptions (if any) will be thrown as though they come from this function

% x = ThisFoilGeometry.abcissas;
% y = ThisFoilGeometry.ordinates;
% coordFormat = ThisFoilGeometry.coordinatesFormat;
[xnew, ynew] = ThisFoilGeometry.switchCoordinatesFormat('selig');
if nargout == 2 % basically becomes a wrapper for switchCoordinatesFormat
    varargout = {xnew, ynew};
    return
end

% call genericplot for parsing plot options and target axes
[plotHandle, axesHandle] = genericplot([xnew, ynew], varargin{:});

% modify plot for aesthetic reasons
axis(axesHandle, 'equal') % so that foil doesn't look distorted
grid(axesHandle, 'on') % personal taste
set(axesHandle, 'XAxisLocation', 'origin') % to look at chord

if nargout == 1, varargout = plotHandle; return, end
varargout = {}; % so that ans isn't created when calling with no outputs

end
