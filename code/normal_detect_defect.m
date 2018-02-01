function [bw] = normal_detect_defect(img, rad, thresh)
% generate normal vector
nv = get_normal_vector2(img, rad);
% caculate gradient map of normal vector
g = get_gradient_from_normal_vector(nv, 1);
g = mat2gray(g);
high_level = 0.05;
zoom_scaling = 0.4;
% dual threshold segmentation
bw = dual_threshold_seg(g, high_level, zoom_scaling);
% depth verify
bw = depth_verify(img(:, :, 3), bw, thresh);
end

