function p = pressure(ThisAtmosphericModel, altitudeGeometric, varargin)
%TEMPERATURE Summary of this function goes here
%   Detailed explanation goes here

p = ThisAtmosphericModel.lookup('pressureStatic', altitudeGeometric, varargin);

end
