function chordlength = chord(ThisFinGeometry, y)
% chord returns the chordlengths at the queried locations y (N-D array)
% 
%   y is measured from the root of the fin geometry, perpendicular to the
%   root chord, with the direction towards the right fin being assumed
%   positive. For now, this method only supports symmetrical fin
%   geometries, so that y and -y produce the same output. If you're
%   querying at a location more than halfspan, a warning is produced, but
%   the computation proceeds anyway.

validateattributes(y, {'numeric'}, {'real', 'finite', 'nonempty'})

if any(abs(y) > ThisFinGeometry.fullspan/2, 'all')
    warning('FinGeometry:chord:outOfBounds',...
            ['No chord exists at one or more queried positions. Results '...
             'may be infeasible.'])
end

chordlength = ThisFinGeometry.rootChord * ...
              ( 1 + (ThisFinGeometry.taperRatio-1) * abs(y) / (ThisFinGeometry.fullspan/2) );

end
