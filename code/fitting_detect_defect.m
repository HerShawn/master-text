function [bw] = fitting_detect_defect(img, half_win_sz, thresh)

sz = size(img);
bw = zeros(sz(1 : 2));

% add SFM tool box path
addpath(genpath('../sfm_chanvese_demo/'))

% set parameters
alpha = 1;
fitting_rad = floor(sqrt(2 * half_win_sz));
sfm_rad = floor(half_win_sz / 2);
iterations = 100;
lam = 0.1;
pixel_num_thresh = 20;

% using sliding window detect defect
for r = half_win_sz + 1 : half_win_sz : sz(1) - half_win_sz
    for c = half_win_sz + 1 : half_win_sz : sz(2) - half_win_sz
        
        % obtain sub image
        depth_patch = img(r - half_win_sz : r + half_win_sz - 1, c - half_win_sz : c + half_win_sz - 1);
        
        % local datum plane fitting
        datum_patch = local_fitting_simple(depth_patch, fitting_rad, alpha);
        
        % seed generation
        depth_bias = datum_patch - depth_patch;
        mask = depth_bias > thresh;
        
        % SFM segmentation
        bw_patch = sfm_local_chanvese(depth_bias, mask, iterations, lam, sfm_rad, 0);
        bw_patch = filter_cc(bw_patch, pixel_num_thresh);
        bw(r - half_win_sz : r + half_win_sz - 1, c - half_win_sz : c + half_win_sz - 1) = bw(r - half_win_sz : r + half_win_sz - 1, c - half_win_sz : c + half_win_sz - 1) + bw_patch;
    end
end
bw = logical(bw);
end

