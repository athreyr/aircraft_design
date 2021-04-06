function T = temperature(ThisAtmosphericModel, altitudeGeometric, varargin)
%TEMPERATURE Summary of this function goes here
%   Detailed explanation goes here

T = ThisAtmosphericModel.lookup('temperature', altitudeGeometric, varargin);

end
