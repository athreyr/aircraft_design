function [xnew, ynew] = switchCoordinatesFormat(ThisFoilGeometry, toFormat)
%CONVERT2FORMAT Summary of this function goes here
%   Detailed explanation goes here
%  fromFormat is required because otherwise it'll try to convert it from
%  its own format, which will lead to horrible errors

x = ThisFoilGeometry.abcissas;
y = ThisFoilGeometry.ordinates;
fromFormat = ThisFoilGeometry.coordinatesFormat;

if strcmpi(fromFormat, toFormat)
    xnew = x;
    ynew = y;
    return
end

try
    switch toFormat
        case 'selig'
%             [~,nextidx] = min(abs(x(2:end) - x(1)));
            idxEdge = numel(x) / 2;
            xnew = [x(idxEdge:-1:1); x(idxEdge+1:end)];
            ynew = [y(idxEdge:-1:1); y(idxEdge+1:end)];
            return
        case 'lednicer'
    %         xmin = min(x);
    %         minidx = find(x == xmin);
    %         ymin = min(abs(y(minidx)));
    %         idxLE = minidx(find(y(minidx) == ymin, 1));
            [~, idxLE] = min(x);
            yupper = y(idxLE:-1:1);
            ylower = y(idxLE:end);
            xupper = x(idxLE:-1:1);
            xlower = x(idxLE:end);

            if numel(xupper) > numel(xlower)
                xnew = [xupper; xupper];
                ylower = spline(xlower, ylower, xupper);
            elseif numel(xupper) < numel(xlower)
                xnew = [xlower; xlower];
                yupper = spline(xupper, yupper, xlower);
            else
                xnew = [xupper; xlower];
            end

            ynew = [yupper; ylower];

        otherwise
            ME = MException('FoilGeometry:invalidToFormat',...
                            ['Conversion to ''%s'' not available (yet). '...
                             'Please use ''selig'' or ''lednicer'' for now.'],...
                            toFormat);
            ME.throw
    end
    
catch MEcause
    if strcmp('FoilGeometry:invalidToFormat', MEcause.identifier)
        MEcause.rethrow
    else
        ME = MException('FoilGeometry:unable2ChangeFormat',...
                        ['Unable to convert coordinates from ''%s'' '...
                         'format to ''%s'' format. Type ME = lasterror; '...
                         'ME.cause at the command prompt for possible '...
                         'reasons.'],...
                         fromFormat, toFormat);
        ME = ME.addCause(MEcause);
        ME.throw;
    end
end
%{
switch fromFormat
    case 'selig'
        [~, idxLE] = min(x);
        yupper = y(idxLE:-1:1);
        ylower = y(idxLE:end);
        xupper = x(idxLE:-1:1);
        xlower = x(idxLE:end);
        
        if numel(xupper) > numel(xlower)
            xmaster = xupper;
            ymaster = yupper;
            
            ylower = spline(xlower, ylower, xmaster);
        else
            xmaster = xlower;
            ymaster = ylower;
            
            ylower = spline(xupper, yupper, xmaster);
        end
        
        varargout = {xmaster, ymaster, ylower};
        
    case 'lednicer'
        
        
end

if ~issorted(x, 'descend')
    [x, sortedIdx] = sort(x, 'descend');
    y = y(sortedIdx);
end

% if strcmpi('selig',

xnew = ThisFoilGeometry;
ynew = toFormat;
%}
end

