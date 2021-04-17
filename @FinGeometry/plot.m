function varargout = plot(ThisFinGeometry, varargin)
% plot overloads the builtin plot function for FinGeometry class
% 
%   Depending on the number of outputs in the function call, it exhibits
%   different behaviour as follows:
%
%   ThisFinGeometry.plot() draws the planform of the fin in the current
%   axes and returns no output.
% 
%   h = ThisFinGeometry.plot() returns the handle to the plot in h.
% 
%   [x, y] = ThisFinGeometry.plot() returns the abcissas and ordinates of
%   the corners of the fin planform in x and y respectively. The order of
%   the coordinates are such that plot(x, y) creates a closed figure.
%   This syntax does not generate a plot.
% 
%   The input arguments to this function are same as that of the builtin
%   plot() function, including target axes and Name-Value pairs.

nargoutchk(0,2) % according to function output signatures

% input argument checking will be done inside the builtin plot function and
% exceptions (if any) will be thrown as though they come from this function

origin = [-ThisFinGeometry.rootChord * ThisFinGeometry.sweepLocation, 0];
datapoints = ThisFinGeometry.planformCoordinates(origin);
if nargout == 2 % basically becomes a wrapper for planformCoordinates
    varargout = {datapoints(:,1), datapoints(:,2)};
    return
end

% call genericplot for parsing plot options and target axes
[plotHandle, axesHandle] = genericplot(datapoints, varargin{:});

% modify plot for aesthetic reasons
axis(axesHandle, 'equal') % so that fin doesn't look distorted
grid(axesHandle, 'on') % personal taste
set(axesHandle, 'XAxisLocation', 'origin') % to capture the symmetry
set(axesHandle, 'YAxisLocation', 'origin') % properly
set(axesHandle, 'YDir', 'reverse') % body axes sign convention
xlabel('X_B') % subscript for Body
fooHandle = ylabel('Y_B'); % requires more modifications for consistency
fooPos = get(fooHandle, 'Position');
fooPos(2) = -fooPos(2);
set(fooHandle, 'Position',fooPos, 'VerticalAlignment','bottom');

if nargout == 1, varargout = plotHandle; return, end
varargout = {}; % so that ans isn't created when calling with no outputs

end
