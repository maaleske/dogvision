function [obj,im] = dog_rgb(obj)
%RGB Display an RGB representation of the data cube using dog_XYZ
% Usage:
% [cube, im] = cube.rgb() displays the cube data using image. If the cube
%   has WavelengthUnit set to 'nm', it uses the CIE color matching
%   functions to calculate the sRGB values (using the xyz2rgb default 'd65'
%   whitepoint).
%   For other values of WavelengthUnit, it will error unless the cube has
%   exactly 3 bands, in which case it will attempt to display them.
%   In either case, rgb normalizes the data by clipping the values to the
%   interval [0, 1] and applies gamma correction with a 1/2 factor.
%


% Use the dog_CIE CMF to calculate the XYZ coords, then sRGB colors using
% MATLAB xyz2rgb
xyz = dog_XYZ(obj.Wavelength);
obj = obj.mapSpectra(...
    @(x) xyz2rgb(x * xyz, ...
    'ColorSpace', 'sRGB'), ...
    'quantity', 'sRGB', ...
    'wlu', 'Color', ...
    'wl', [1,2,3],... % Placeholder, wl must be numerical
    'fwhm', zeros(1,3));

% Calculate the mean of R and G and use it for both
obj = obj.map(@(x)rg_mean(x));

% Normalize the image and apply gamma correction
obj = obj.mapBands(@(x) min(max(x,0),1).^0.5, 'Normalized sRGB');

h = figure();
im = image(obj.Data);
axis image;

function y = rg_mean(x)
% Calculate the mean of two layers and assign it to both
m = (x(:,:,1)+x(:,:,2))/2;
y = x; 
y(:,:,1) = m;
y(:,:,2) = m;
end

end