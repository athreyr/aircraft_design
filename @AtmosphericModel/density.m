function rho = density(ThisAtmosphericModel, altitudeGeometric, varargin)
%TEMPERATURE Summary of this function goes here
%   Detailed explanation goes here

rho = ThisAtmosphericModel.lookup('density', altitudeGeometric, varargin);

end
