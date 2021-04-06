function disp(ThisFinGeometry)
% disp overloads the builtin disp function for ThisFinGeometry class

fprintf('FinGeometry object having the following properties:\n')
fprintf('Reference area             [L^2]   =   %g\n', ThisFinGeometry.referenceArea)
fprintf('Aspect ratio               [-]     =   %g\n', ThisFinGeometry.aspectRatio)
fprintf('Taper ratio                [-]     =   %g\n', ThisFinGeometry.taperRatio)
fprintf('Full span                  [L]     =   %g\n', ThisFinGeometry.fullspan)
fprintf('Root chord                 [L]     =   %g\n', ThisFinGeometry.rootChord)
fprintf('Sweep angle                [-]     =   %g deg\n', ThisFinGeometry.sweepAngle_deg)
fprintf('Location of constant sweep [-]     =   %g%% of chord\n', ...
                                                        ThisFinGeometry.sweepLocation * 100)

end
