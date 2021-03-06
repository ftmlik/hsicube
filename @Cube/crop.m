function [obj, tl, br] = crop(obj,tl,br)
%CROP Spatial crop
% Usage:
% CROP([tlx, tly, w, h]) or
% CROP([tlx, tly],[brx, bry]) 
% crops the cube spatially to a rectangle defined by top left corner
% [tlx, tly] and the bottom right corner [brx, bty] (or [tlx + w, tly + h] 
% if only a single vector was supplied. Both corners are included.

% If only a single vector is supplied, use it as if it was [x, y, w, h]
if nargin == 2 && numel(tl) == 4
   br = [tl(1) + tl(3), tl(2) + tl(4)];
   tl = tl(1:2);
end 
    
assert(isequal(size(tl), [1,2]) && isequal(size(br), [1,2]), ...
    'Cube:InvalidCoordinateSize',...
    'Corner coordinates must be supplied as 1x2 matrices [x,y]');
assert(obj.inBounds(tl),...
    'Cube:CornerOutOfBounds', ...
    'Top left corner must be a pair of integers between [1,1] and [%d,%d], was %s',obj.Width,obj.Height, mat2str(tl));
assert(obj.inBounds(br),...
    'Cube:CornerOutOfBounds', ...
    'Bottom right corner must be a pair of integers between [1,1] and [%d,%d], was %s',obj.Width,obj.Height, mat2str(br));
assert(tl(1) <= br(1) && tl(2) <= br(2), ...
    'Cube:InvalidCornerOrder', ...
    'Bottom right corner must have equal or greater coordinate indices compared to the top left corner');

obj.Data = obj.Data(tl(2):br(2), tl(1):br(1), :);
obj.History = {{'Cropped spatially',@crop,tl,br}};
end