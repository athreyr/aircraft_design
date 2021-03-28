classdef FoilGeometry
    %FOILGEOMETRY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        abcissas
        ordinates
        perimeter
        area
        centroidPerimeter
        centroidArea
        thicknessChord
%         thicknessCamber
        camber
    end
    
    methods
        function ThisFoilGeometry = FoilGeometry(varargin)
            %FOILGEOMETRY Construct an instance of this class
            %   Detailed explanation goes here
            
            UserInputs = FoilGeometry.unpackInputs(varargin);            
            Props = FoilGeometry.computeProperties(UserInputs);
            
            ThisFoilGeometry.abcissas = Props.abcissas;
            ThisFoilGeometry.ordinates = Props.ordinates;
            ThisFoilGeometry.perimeter = Props.perimeter;
            ThisFoilGeometry.area = Props.area;
            ThisFoilGeometry.centroidPerimeter = Props.centroidPerimeter;
            ThisFoilGeometry.centroidArea = Props.centroidArea;
            ThisFoilGeometry.thicknessChord = Props.thicknessChord;
%             ThisFoilGeometry.thicknessCamber = Props.thicknessCamber;
            ThisFoilGeometry.camber = Props.camber;
            
        end
    end
    
    methods (Static)
        UserInputs = unpackInputs(varargin);
        Props = computeProperties(UserInputs);
        [newAbcissas,newOrdinates] = makeValid(abcissas,ordinates);
        varargout = convertDataFormat(dataPoints,toFormatName);
    end
end

