function sz = sizen(A)
%sizen      Size of array, without leading or trailing singleton dimensions
%   sizen(A) returns size(A) if A is not a vector, and numel(A) otherwise
%   Use this when you want to concatenate sizes of two matrices of
%   arbitrary dimensions, and don't want singleton dimensions in between

if isvector(A), sz = numel(A); else, sz = size(A); end

end
