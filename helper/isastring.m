function tf = isastring(A)
%isastring      isstring for backward compatibility
%   isastring(A) calls isstring(A) if version of MATLAB is above R2016b,
%   and returns false if otherwise

if verLessThan('matlab','9.1') %R2016b
    tf = false;
else
    tf = isstring(A);
end

end
