function ThisFinGeometry = setComputedProperties(ThisFinGeometry)
%setComputedProperties sets object properties that don't come from inputs
% 
%   Helper function for class constructor (non-static hidden method).
% 
%   Meant for internal use only.

% copy properties that came from inputs
S = ThisFinGeometry.referenceArea;
AR = ThisFinGeometry.aspectRatio;
TR = ThisFinGeometry.taperRatio;
            
% use inputs to calculate remaining info
b = sqrt(S * AR);
cRoot = 2 * S / (b * (1 + TR));

% assign the remaining properties
ThisFinGeometry.fullspan = b;
ThisFinGeometry.rootChord = cRoot;

end
