function [g] = get_gradient_from_normal_vector(nv, rad)
sz = size(nv);
nv = extend_img(nv, rad);
sz2 = size(nv);
gx = zeros(sz2(1 : 2));
gy = zeros(sz2(1 : 2));
% set parameters
sigma = 0.7;
weight_vector = fspecial('gaussian', [2 * rad + 1, 1], sigma);

for r = rad + 1 : rad + sz(1)
    for c = rad + 1 : rad + sz(2)
        r_max = r + rad;
        r_min = r - rad;
        c_max = c + rad;
        c_min = c - rad;
        % caculate horizontal gradient map
        temp = 0;
        for i = r_min : r_max
            temp = temp + (1 - abs(cacu_cos_simi(nv(i, c_min, :), nv(i, c_max, :)))) * weight_vector(i - r + rad + 1);
        end
        gx(r, c) = temp;
        % caculate vertical gradient map
        temp = 0;
        for i = c_min : c_max
            temp = temp + (1 - abs(cacu_cos_simi(nv(r_min, i, :), nv(r_max, i, :)))) * weight_vector(i - c + rad + 1);
        end
        gy(r, c) = temp;
    end
end
g = sqrt(gx .^ 2 + gy .^ 2);
g = g(rad + 1 : rad + sz(1), rad + 1 : rad + sz(2));
end

