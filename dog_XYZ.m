function XYZ = dog_XYZ(wls)
% Calculate XYZ color matching function for the given wavelengths using
% dog L and S sensitivities in place of the human cone sensitivities.

% Original (full) CIE LMS to XYZ transform matrix
M = [...
  1.94735469, -1.41445123, 0.36476327; ...
  0.68990272,  0.34832189, 0.0       ; ...
  0.0,         0.0         1.93485343];

% only use L and S parts
M_ls = M(:,[1,3]);

% dog LS values for the wavelengths
LS = dog_LS(wls);

XYZ = LS * M_ls';

end