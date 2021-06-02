classdef Unit
%Unit   Template for compound physical units
%   Unit is a class for representing any physical unit, complete with
%   symbol, definition, dimensions, and multiplicative coefficients.
%   Relative temperature can also be represented, and the constructor
%   supports returning array of objects if the input symbols are cell
%   arrays of character vectors or string arrays.
%   
%   Example:
%       pascal = Unit('Pa');
%       knots = Unit('kts', {'nmi', 'h'}, [0 1 -1], 1)
    
    properties (SetAccess = private)
        symbol
        baseUnitSymbols
        dimensions
        coefficient
    end
    
    methods
        function ThisUnit = Unit(symbolin, varargin)
        % ThisUnit = Unit(symbol, [baseUnits = '0'], [M L T = 0], [coeff = 1])
            
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
                % ------------------ DO COMPARISON --------- !!!!!!!!!!!!!
                
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
        x = rdivide(A, B);
        x = ldivide(A, B);
        x = mrdivide(A, B);
        x = mldivide(A, B);
        x = times(A, B);
        x = mtimes(A, B);
        x = power(A, B);
        x = mpower(A, B);
        % disp(ThisUnit)
        
    end
    
    methods (Static)
        valOut = convert(argin, fromBaseUnit, toBaseUnit);
        UnitOut = eval(unitExpression);
    end
    
end

