function [out] = get_normal_vector2(img, rad)
sz = size(img);
% extend image
img = extend_img(img, rad);
sz2 = size(img);
out = zeros([sz2(1 : 2), 3]);

Px = img(:, :, 1);
Py = img(:, :, 2);
Pz = img(:, :, 3);
% get integral map of xyz channels
Ix = get_integral_map(Px);
Iy = get_integral_map(Py);
Iz = get_integral_map(Pz);
% get integral map of different combination of channels
Ixx = get_integral_map(Px .* Px);
Ixy = get_integral_map(Px .* Py);
Ixz = get_integral_map(Px .* Pz);
Iyy = get_integral_map(Py .* Py);
Iyz = get_integral_map(Py .* Pz);
Izz = get_integral_map(Pz .* Pz);

for r = rad + 1 : rad + sz(1)
    for c = rad + 1 : rad + sz(2)
        % caculate different components of covariance matrix
        Cxx = get_ave_value(Ixx, r, c, rad);
        Cxy = get_ave_value(Ixy, r, c, rad);
        Cxz = get_ave_value(Ixz, r, c, rad);
        Cyy = get_ave_value(Iyy, r, c, rad);
        Cyz = get_ave_value(Iyz, r, c, rad);
        Czz = get_ave_value(Izz, r, c, rad);
        
        Cx = get_ave_value(Ix, r, c, rad);
        Cy = get_ave_value(Iy, r, c, rad);
        Cz = get_ave_value(Iz, r, c, rad);
        % covariance matrix
        Cp = [Cxx, Cxy, Cxz; Cxy, Cyy, Cyz; Cxz, Cyz, Czz] - [Cx, Cy, Cz]' * [Cx, Cy, Cz];
        % caculate eigen vector
        [V, D] = eig(Cp);
        D = diag(D);
        [~, idx] = min(D(:));
        normal_vector = V(:, idx);
        normal_vector = normal_vector / norm(normal_vector);
        out(r, c, :) = normal_vector;
    end
end
out = out(rad + 1 : rad + sz(1), rad + 1 : rad + sz(2), :);
end

