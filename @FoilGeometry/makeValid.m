function [closedCoords,topDownCoords] = makeValid(inCoords)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% first and last points should be same to calculate perimeter
% no point in calculating topdown coords because you can't plot the closed
% figure with that

% given (x,y) arranged in random order, find order of (x,y) pairs such that
% they represent a closed curve

x = inCoords(:,1);

suctionSurfaceIdx = UserInputs.y >= 0;
suctionSurface = [UserInputs.x(suctionSurfaceIdx), UserInputs.y(suctionSurfaceIdx)];
pressureSurface = [UserInputs.x(~suctionSurfaceIdx), UserInputs.y(~suctionSurfaceIdx)];
           
[Props.x, sortedIdx] = sort(UserInputs.x);
Props.y = UserInputs.y(sortedIdx);

Props.y

closedCoords = xin;
topDownCoords = yin;

end

