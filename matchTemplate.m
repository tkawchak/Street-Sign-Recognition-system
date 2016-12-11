function [ boundingBox ] = matchTemplate( temp, im )
% matchTemplate - matches the template to the image
% image is a colored image
% template is a cropped street sign that is gray
im_g = rgb2gray(im);
[mt, nt] = size(temp);
[mi, ni] = size(im);
scale = max(mt/mi, nt/ni);

im_g = imresize(im_g, 5*scale);


% MAYBE TRY TO USE DIFFERENT SIZE FILTERS WHEN EXTRACTING FEATURES

% detect the important features from both 
% template and image
image_points = detectSURFFeatures(im_g, 'MetricThreshold', 10,...
    'NumScaleLevels', 6, 'NumOctaves', 2);
temp_points = detectSURFFeatures(temp, 'MetricThreshold', 10,...
    'NumScalelevels', 6, 'NumOctaves', 2);
% subplot(1, 2, 1);
% imshow(im_g);
% title('Feature points');
% hold on;
% plot(image_points);
% subplot(1, 2, 2);
% imshow(temp);
% hold on;
% plot(temp_points);
% figure('units', 'normalized', 'OuterPosition', [0 0 1 1]);

% extract features from the image and template
[im_feat, im_points] = extractFeatures(im_g, image_points);
[temp_feat, temp_points] = extractFeatures(temp, temp_points);
% match those featrues
[pairs, matchVal] = matchFeatures(temp_feat, im_feat, 'Method', 'Exhaustive', ...
    'MatchThreshold', 1, 'MaxRatio', 0.8, 'Unique', true);

% somehow, sort these pairs by increasing match distance
% then, process these in that order.
[top_matches, indices] = sort(matchVal, 'ascend');
pairs = pairs(indices, :);

% plot the mapping between template points
% and points in the scene.
matchedTempPoints = temp_points(pairs(:, 1), :);
matchedScenePoints = im_points(pairs(:, 2), :);

subplot(1, 2, 1);
showMatchedFeatures(temp, im_g, matchedTempPoints, ...
    matchedScenePoints, 'montage');
title('All Matched Points');

numPoints = length(matchedTempPoints);
if numPoints > 12
    numPoints = 12;
end

if (numPoints >= 4)
    best_inliers = 0;
    error_threshold = 10;
    best_H = zeros(3, 3);
    H = zeros(8, 8);
    H(1,3)=1; H(2,6)=1; H(3,3)=1; H(4,6)=1; H(5,3)=1; H(6,6)=1; H(7,3)=1; H(8,6)=1;

    combinations = ones(numPoints, 4);
    row = 1;
    % make sure these are all unique
    for i=1:numPoints
        for j=1:numPoints
            for k=1:numPoints
                for l=1:numPoints
                    if (length(unique([i, j, k, l])) ~= 4)
                        combinations(row, :) = [i, j, k, l];
                    row = row + 1;
                    end
                end
            end
        end
    end
    %fprintf('rows: %d\n', row);

    numCombinations = length(combinations);
    for i=1:numCombinations
       %fprintf('estimating homography\n');
       % choose a random subset of four points
       points = combinations(i, :);
       %fprintf('iter: %d\n', i);

       p1 = matchedTempPoints(points(1)).Location;
       p2 = matchedTempPoints(points(2)).Location;
       p3 = matchedTempPoints(points(3)).Location;
       p4 = matchedTempPoints(points(4)).Location;
       x1 = round(p1(1, 1));
       y1 = round(p1(1, 2));
       x2 = round(p2(1, 1));
       y2 = round(p2(1, 2));
       x3 = round(p3(1, 1));
       y3 = round(p3(1, 2));
       x4 = round(p4(1, 1));
       y4 = round(p4(1, 2));

       p_1 = matchedScenePoints(points(1)).Location;
       p_2 = matchedScenePoints(points(2)).Location;
       p_3 = matchedScenePoints(points(3)).Location;
       p_4 = matchedScenePoints(points(4)).Location;
       x_1 = round(p_1(1, 1));
       y_1 = round(p_1(1, 2));
       x_2 = round(p_2(1, 1));
       y_2 = round(p_2(1, 2));
       x_3 = round(p_3(1, 1));
       y_3 = round(p_3(1, 2));
       x_4 = round(p_4(1, 1));
       y_4 = round(p_4(1, 2));

       % estimate the homography
       H(1,1)=x1;H(1,2)=y1;H(1,7)=(-x1*x_1);H(1,8)=(-y1*x_1);
       H(2,4)=x1;H(2,5)=y1;H(2,7)=(-x1*y_1);H(2,8)=(-y1*y_1);
       H(3,1)=x2;H(3,2)=y2;H(3,7)=(-x2*x_2);H(3,8)=(-y2*x_2);
       H(4,4)=x2;H(4,5)=y2;H(4,7)=(-x2*y_2);H(4,8)=(-y2*y_2);
       H(5,1)=x3;H(5,2)=y3;H(5,7)=(-x3*x_3);H(5,8)=(-y3*x_3);
       H(6,4)=x3;H(6,5)=y3;H(6,7)=(-x3*y_3);H(6,8)=(-y3*y_3);
       H(7,1)=x4;H(7,2)=y4;H(7,7)=(-x4*x_4);H(7,8)=(-y4*x_4);
       H(8,4)=x4;H(8,5)=y4;H(8,7)=(-x4*y_4);H(8,8)=(-y4*y_4);
       x = [x_1; y_1; x_2; y_2; x_3; y_3; x_4; y_4];

       warning('off', 'all');
       h = zeros(9, 1);
       h(1:8) = H\x;
       h(9) = 1;
       h = reshape(h, 3, 3)';
       warning('on', 'all');

       inlier_count = 0;
       %fprintf('estimating outliers\n');
       % transform all of the points
       for j=1:numPoints
           p = matchedTempPoints(j).Location;
           x = p(1, 1);
           y = p(1, 2);
           p_ = matchedScenePoints(j).Location;
           x_ = p_(1, 1);
           y_ = p_(1, 2);

           proj = h * [x; y; 1];
           proj = proj / proj(3);

           error = proj - [x_ y_ 1]';
           if (norm(error, 1) < error_threshold)
               inlier_count = inlier_count + 1;
           end
           %fprintf('point: %d, error: %.3f\n', j, norm(error, 1));
           %fprintf('x: %.3f, x_: %.3f, y: %.3f, y_: %.3f, z: %.3f, z_: %.3f\n', ...
                %proj(1), x_, proj(2), y_, proj(3), 1); 
       end

       % estimate which points are inliers
       if (inlier_count > best_inliers)
            best_H = h;
            best_inliers = inlier_count;
       end

    end

    %boundingBox = transformPointsForward(tform, boundingBox);
    ul = best_H * [1; 1; 1]; p1 = ul(1:2)/ul(3);
    ur = best_H * [size(temp, 2); 1; 1]; p2 = ur(1:2)/ur(3);
    br = best_H * [size(temp, 2); size(temp, 1); 1]; p3 = br(1:2)/br(3);
    bl = best_H * [1; size(temp, 2); 1]; p4 = bl(1:2)/bl(3);
    
    % estimate whether or not the bounding box is a rectangle-ish shape
    % if not then return 0
    top = ur-ul; top_norm = norm(top, 2);
    left = ul-bl; left_norm = norm(left, 2);
    bottom = bl-br; bottom_norm = norm(bottom, 2);
    right = br-ur; right_norm = norm(right, 2);
    ang_tl = acosd(top' * left  / (top_norm * left_norm));
    ang_bl = acosd(left' * bottom / (left_norm * bottom_norm));
    ang_br = acosd(bottom' * right / (bottom_norm * right_norm));
    ang_ur = acosd(right' * top / (right_norm * top_norm));
    fprintf('angles: %.2f, %.2f, %.2f, %.2f\n', ang_tl, ang_bl, ang_br, ang_ur);
    angle_error = abs(90-[ang_tl; ang_bl; ang_br; ang_ur]);
    fprintf('angle error: %.2f\n', max(angle_error));
    norm_ratios = [top_norm / left_norm;
        left_norm / bottom_norm;
        bottom_norm / right_norm;
        right_norm / top_norm];
    fprintf('norm_ratios: %.2f, %.2f, %.2f, %.2f\n', norm_ratios(1), ...
        norm_ratios(2), norm_ratios(3), norm_ratios(4));
    if max(angle_error) > 25
        boundingBox = 0;
        fprintf('angles too skewed\n\n');
    elseif ((max(norm_ratios) > 1.4) || (min(norm_ratios) < (1/1.4)))
        boundingBox = 0;
        fprintf('max: %.2f, min: %.2f\n', max(norm_ratios), min(norm_ratios));
        fprintf('sides too skewed\n\n');
    else
        % plot the box
        fprintf('good match\n\n');
        boundingBox = [p1'; p2'; p3'; p4'; p1';] / (5 * scale);
        subplot(1, 2, 2);
        imshow(im);
        hold on;
        line(boundingBox(:, 1), boundingBox(:, 2), 'Color', 'g');
        title('Detected Sign');
    end
    
else
    boundingBox = 0;
    fprintf('not enough points\n\n');
end

end

