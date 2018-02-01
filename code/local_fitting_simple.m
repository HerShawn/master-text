function [out] = local_fitting_simple(img, rad, alpha)
sz = size(img);

% smooth depth image
N = boxfilter(ones(sz(1 : 2)), rad);
mean = boxfilter(img, rad) ./ N;
mean2 = boxfilter(img .* img, rad) ./ N;
var = mean2 - mean .^2;

bias = abs(img - mean);

mask = bias > alpha * var;

img_f = mask .* mean + ~mask .* img;

% least square method
data = img2pointcloud(img_f);
[datum, ~, ~] = least_square(data, 3);
depth_img = pointcloud2img(datum, sz(1 : 2));
out = depth_img(:, :, 3);
end