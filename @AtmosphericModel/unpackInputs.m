function UserInputs = unpackInputs(varargin)
%UNPACK Summary of this function goes here
%   Detailed explanation goes here
% This class can be initialised in the following ways:
%
%   Atm = AtmosphericModel(matFilename, varnameList);
%   Atm = AtmosphericModel(matFilename, varnameList, units);
% 
%   Atm = AtmosphericModel(RefTable, fieldnameList);
%   Atm = AtmosphericModel(RefTable, fieldnameList, units);

if nargin == 0, UserInputs = struct([]); return, end
% constructor should work with no input arguments

narginchk(2,3)

if nargin == 2, units = struct([]); else, units = varargin{end}; end

if exist(varargin{1}, 'file') == 2
    matFilename = varargin{1};
    varnameList = varargin{2};
    RefTable = load(matFilename, varnameList);
    UserInputs = match(RefTable, varnameList);
elseif exist(varargin{1}, 'var')
    RefAtmStruct = varargin{1};
    fieldnameList = varargin{2};
    UserInputs = match(RefAtmStruct, fieldnameList);
end
UserInputs.units = units;

end

function UserInputs = match(RefTable, fieldnameList)

if numel(fieldnameList) ~= 4
    error('There should only be exactly 4 fieldnames.')
end

[hVarname, TVarname, pVarname, rhoVarname] = deal(fieldnameList{:});

UserInputs.altitudeGeopotential = RefTable.(hVarname);
UserInputs.temperature = RefTable.(TVarname);
UserInputs.pressureStatic = RefTable.(pVarname);
UserInputs.density = RefTable.(rhoVarname);

end
