function [data2, p] = local_fitting_shepard(img_patch, seed_point)

z = get_from_sub(seed_point, img_patch);
sz = size(img_patch);

% seed points cloud
data(:,1) = seed_point(:,2);
data(:,2) = seed_point(:,1);
data(:,3) = z;

% least square method
p2 = 3;
[~, p, error] = least_square(data, p2, 0);

[ri, ci] = ind2sub(sz, 1 : sz(1) * sz(2));

xi = ci;
yi = ri;

% generate datum plane
switch p2
    
    case 1
        a= p;
        z = a(1) * xi + a(2) * yi + a(3);
        
    case 2
        b= p;
        z=b(1) * xi .^ 2 + b(2) * yi .^ 2 + b(3) * xi .* yi + b(4) * xi + b(5) * yi + b(6);
        
    case 3
        c = p;
        z = c(1) * xi .^ 3 + c(2) * yi .^ 3 + c(3) * yi .* xi .^ 2 + c(4) * xi .* yi .^ 2 + c(5) * xi .* yi + c(6) * xi + c(7) * yi + c(8);

end

data2(:, 1) = xi;
data2(:, 2) = yi;
data2(:, 3) = z;
end