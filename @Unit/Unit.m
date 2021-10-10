classdef Unit
%Unit   Template for compound physical units
%   Unit is a class for representing any physical unit, complete with
%   symbol, definition, dimensions, and multiplicative coefficients.
%   Relative temperature can also be represented, and the constructor
%   supports returning array of objects if the input symbols are cell
%   arrays of character vectors or string arrays.
%   
%   Example:
%       Knots = Unit('kts', {'nmi', 'h'}, [0 1 -1 0], 1) creates an object
%       Knots of the Unit class, which has a symbol 'kts', base units 'nmi'
%       (nautical mile) and 'h' (hour), dimensions [0 1 -1 0]
%       (corresponding to mass, length, time, and temperature
%       respectively), and multiplicative coefficient 1.
%       
%       Bar = Unit('bar') creates an object Bar of the Unit class, which
%       has a symbol 'bar', and base units, dimenions, and multiplicative
%       dimensions looked up from data\unit_conversion\definitions.txt.
% 
%       Watt = Unit.evaluate('J*s') creates an object Watt of the Unit
%       class, which has a symbol, base units, and dimensions computed from
%       unit arithmetic.
%       
%   In the method signatures, a pipe symbol ('|') means that the argument
%   is optional.
%
%   If you are a user, you shouldn't need to use this class explicitly, as
%   the unit conversions would be built into the methods of the other
%   classes.

% The comments in this class definition are written to produce properly
% formatted output with the help or doc commands, and will therefore not be
% user-friendly. If you are a user, you shouldn't have needed to open this
% anyway, since you should use those help and doc commands.
    
    properties (SetAccess = protected)
        
        % Cell array of character vectors or string array
        %
        % Unique identifiers for the units, e.g. {'N','lb'} for newton and 
        % pound mass. See data\unit_conversion\definitions.txt for the list
        % of all identifiers.
        symbol
        
        % Units corresponding to mass, length, time, and temperature
        %
        % Set of base units corresponding to the mass (M), length (L), time
        % (T), and temperature (K) dimensions (respectively) of this
        % compound unit. Only those base units whose dimensions are
        % non-zero are included. Represented as a cell row of character
        % vectors.
        %
        % e.g. {'kg', 'cm', 'min'}
        % 
        % See also dimensions, symbol, coefficient.
        baseUnitSymbols
        
        % Power to which each base unit is raised to compute compound unit
        %
        % Dimension (power/ exponent) of each base unit (mass M, length L,
        % time T, and temperature K) in the compound unit. Number of
        % non-zero dimensions should be less than or equal to the number of
        % base unit symbols.
        %
        % e.g. [1, 1, -1, 0] represents a unit of momentum.
        %
        % See also baseUnitSymbols, symbol, coefficient.
        dimensions
        
        % Multiplicative coefficient between base units and compound unit
        %
        % For some compound units, the combination of base units and
        % dimensions is not sufficient to arrive at the final unit, and a
        % multiplicative coefficient is required.
        % 
        % e.g. 1 atm = 101325 kg*m/s^2, where 101325 is the coefficient.
        %
        % See also symbol, baseUnitSymbols, dimensions.
        coefficient
    end
    
    methods
        function ThisUnit = Unit(symbolin, varargin)
        %Unit   Class constructor.
        %   ThisUnit = Unit(symbol, |baseUnits, |[M L T K], |coeff) creates
        %   a scalar object ThisUnit from the following mandatory inputs:
        %       symbol -- unique identifier for the unit, char or string
        %   and the following optional inputs:
        %       baseUnits -- symbols of base units, as a cell row of
        %           character vectors or a string row
        %       [M L T K] -- dimensions corresponding to mass, length,
        %           time, and temperature, with missing ones given as 0
        %       coeff -- multiplicative coefficient between combination of
        %           baseUnits raised to their powers (M, L, T, K) and
        %           symbol
        %   If baseUnits are not provided, then they are looked up from 
        %   data\unit_conversion\definitions.txt. If they are, then
        %   dimensions and coefficient should be provided along with them.
        %
        %   ThisUnitArray = Unit(symbolArray, |baseUnitArray, |dimArray,...
        %        |coeffArray);
        %   creates an array object TheseUnits from the following mandatory
        %   inputs (modified from the scalar case)(!):
        %       symbolArray -- cell array of character vectors or string
        %           array
        %   and the following optional inputs (also modified from scalar
        %   case):
        %       baseUnitArray -- cell row of character vectors or string
        %           row as an additional matrix dimension on top of the
        %           matrix dimensions of symbolArray
        %       dimArray -- an additional matrix dimension of length 4 on
        %           top of those of symbolArray
        %       coeffArray -- array of same size as that of symbolArray
        %   You can specify the base units of only some of the symbols and
        %   keep the remaining as empty character inside a cell, i.e. {''}.
        %
        %   (!) A use case for this form of constructor is yet to be found.
        %       This feature may be removed in a future release.
        % 
        %   Symbols containing arithmetic operators e.g. '(', '*', '/' are
        %   NOT SUPPORTED in this constructor. Create such units using the
        %   static evaluate method.
        %
        %   See also evaluate, convert.
            
            % get names of input properties and their default values
            Default = defaultInputs('Unit');
            
            argin = {};
            if nargin > 0 % constructor should work with no input
                
                narginchk(1,4) % based on the function signatures
                
                % this class/constructor/method is different because it
                % could either accept a cell or a char/string, latter of
                % the cases in which it should be converted into a cell
                % before anything else can be done
                if ischar(symbolin) || isastring(symbolin)
                    symbol = {symbolin};
                else
                    symbol = symbolin;
                end
                
                % because symbol itself is a cell array, [symbol, varargin]
                % would just return symbol instead of {symbol} if varargin
                % is empty, so:
                argin = [{symbol}, varargin];
                
                % This constructor has to construct an array of objects,
                % which can only be done by preallocating ThisUnit object
                % to the last element of the array. But the output of the
                % constructor is also ThisUnit, so you need to write
                % something like ThisUnit(4,14,9) = ThisUnit.
                
                % This works because ThisUnit is created as soon as we
                % enter the constructor, so the object can be used for
                % other purposes.
                
                % The preallocation works by calling the constructor again
                % with no arguments, getting the default object, and
                % copying its value to the other elements of the array.
                
                % Also, since size(ThisUnit) = size(symbol), we need to
                % preallocate the element with indices [size(symbol,1), ...
                % size(symbol,2), ...], except that is difficult to write
                % in the general case.
                
                % Thus we need to do something like
                %       lastidx = num2cell(size(symbol));
                %       ThisUnit(lastidx{:}) = ThisUnit;
                % but this looked 2.5x faster:
                
                lastidx = cell(1, ndims(symbol));
                % so that we know how many outputs to expect from size()
                [lastidx{:}] = size(symbol);
                % collect all the outputs as a comma separated list
                
                ThisUnit(lastidx{:}) = ThisUnit;
                % apparently, this won't call the constructor again if
                % ThisUnit is a row or column vector
                % ---------------- CHECK WHY --------------- !!!!!!!!!!!!!
                
            end
            
            [inputPropertiesList, valuesList] = parseInputs(Default, argin);
            
            % assign input properties to object array
            for iProp = 1:numel(inputPropertiesList)
                [ThisUnit.(inputPropertiesList{iProp})] = deal(valuesList{iProp,:});
            end
            
            % compute the remaining properties from inputs
            ThisUnit = ThisUnit.setComputedProperties;
            
        end % constructor
        
        % include the function signatures of the other methods

    end
    
    methods (Hidden)
        x = rdivide(A, B);
        x = ldivide(A, B);
        x = mrdivide(A, B);
        x = mldivide(A, B);
        x = times(A, B);
        x = mtimes(A, B);
        x = power(A, B);
        x = mpower(A, B);
        % tf = isequal(A, B); equal with number if dimensions are 0 are
        % coefficient is 1, and equal with char if symbol is same, and
        % equal with unit if base units, dimensions, and coefficients are
        % same
        % greater than and less than operators
        disp(ThisUnit)
        multiFact = convertBase(ThisUnit, toUnitList);
        ThisUnit = setSymbol(ThisUnit);
        ThisUnit = setComputedProperties(ThisUnit);
    end
    
    methods (Static)
        valout = convert(valin, fromUnit, toUnit, varargin);
        UnitOut = evaluate(unitExpression);
    end
    
end

