function Props = computeProperties(UserInputs)
%COMPUTEPROPERTIES Summary of this function goes here
%   Detailed explanation goes here

% Inititalise output structure so we know what fields it would have
Props = struct('abcissas', 0, ...
               'ordinates', 0, ...
               'perimeter', 0, ...
               'area', 0, ...
               'centroidPerimeter', [0,0], ...
               'centroidArea', [0,0], ...
               'thicknessChord', 0, ...
               ...'thicknessCamber', 0, ...
               'camber', 0);
fid = fopen('defaultObjectProperties.csv');
scannedCells = textscan(fid,'%s,%d');
% Props = cell2struct(scannedCells(:,2),scannedCells(:,1),1);
fields = scannedCells{1};
vars = scannedCells{2};
for thisField = 1:numel(fields)
    Props.(fields(thisField)) = vars(thisField);
end
%{
[Props.abcissas, Props.ordinates] = FoilGeometry.makeValid(UserInputs.x, UserInputs.y);

ds = [0; sqrt(diff(Props.abcissas).^2 + diff(Props.ordinates).^2)];
Props.perimeter = sum(ds);
Props.centroidPerimeter = 1/Props.perimeter * ...
                        [sum(Props.ordinates.*ds), sum(Props.abcissas.*ds)];

Props.area = trapz(Props.abcissas,Props.ordinates);

yPos = Props.ordinates(Props.ordinates > 0);
yNeg = Props.ordinates(Props.ordinates < 0);
                    
dA = [0; diff(Props.abcissas)/2 .* [diff()]];
%}
               
[x,y] = FoilGeometry.convertDataFormat([UserInputs.x, UserInputs.y], 'selig');
ds = [0; sqrt(diff(x).^2 + diff(y).^2)];
Props.perimeter = sum(ds);
Props.centroidPerimeter = [sum(x.*ds), sum(y.*ds)] / Props.perimeter;

[xcommon, yupper, ylower] = ...
    FoilGeometry.convertDataFormat([UserInputs.x, UserInputs.y], 'lednicer');
Props.thicknessChord = yupper - ylower;
Props.camber = Props.thicknessChord / 2;

dA = [0; diff(xcommon)/2 .* (Props.thicknessChord(1:end-1) + Props.thicknessChord(2:end))];
Props.area = sum(dA);
Props.centroidArea = [sum(xcommon .* dA), sum(Props.camber .* dA)] / Props.area;


end

