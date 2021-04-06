function disp(ThisFinGeometry)
% Overloaded function to control command line display behaviour

fprintf('Reference wing with the following geometry:\n')
fprintf('Reference area     [L^2]   =   %g\n',ThisFinGeometry.referenceArea)
fprintf('Aspect ratio       [-]     =   %g\n',ThisFinGeometry.aspectRatio)
fprintf('Taper ratio        [-]     =   %g\n',ThisFinGeometry.taperRatio)
fprintf('Full span          [L]     =   %g\n',ThisFinGeometry.fullspan)
fprintf('Root chord         [L]     =   %g\n',ThisFinGeometry.rootChord)
fprintf('Sweep angle        [-]     =   %g deg\n',ThisFinGeometry.sweepAngle_deg)
fprintf('Location of sweep  [-]     =   %g%%\n',ThisFinGeometry.sweepLocation * 100)

end
