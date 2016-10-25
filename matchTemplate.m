function [ boundingBox ] = matchTemplate( temp, im )
% matchTemplate - matches the template to the image
% image is a colored image
% template is a cropped street sign that is gray
im_g = rgb2gray(im);
%temp = rgb2gray(template);

% detect the important features from both 
% template and image
image_points = detectSURFFeatures(im_g, 'MetricThreshold', 10,...
    'NumScaleLevels', 6, 'NumOctaves', 2);
temp_points = detectSURFFeatures(temp, 'MetricThreshold', 10,...
    'NumScalelevels', 6, 'NumOctaves', 2);
% figure; imshow(im_g);
% title('Feature points');
% hold on;
% plot(image_points);

% extract features from the image and template
[im_feat, im_points] = extractFeatures(im_g, image_points);
[temp_feat, temp_points] = extractFeatures(temp, temp_points);
% match those featrues
pairs = matchFeatures(temp_feat, im_feat, 'Method', 'Exhaustive', ...
    'MatchThreshold', 2, 'MaxRatio', 0.6, 'Unique', true);

% plot the mapping between template points
% and points in the scene.
matchedTempPoints = temp_points(pairs(:, 1), :);
matchedScenePoints = im_points(pairs(:, 2), :);
subplot(1, 3, 1);
showMatchedFeatures(temp, im_g, matchedTempPoints, ...
    matchedScenePoints, 'montage');
title('All Matched Points');

% get rid of the points in the scene that do not
% corresponding to points in the tempalte.
if (length(matchedTempPoints) >= 4)
    [tform, inlierTempPoints, inlierScenePoints] = ...
        estimateGeometricTransform(matchedTempPoints, matchedScenePoints, ...
        'projective', 'MaxNumTrials', 10000);
    subplot(1, 3, 2);
    showMatchedFeatures(temp, im_g, inlierTempPoints, ...
        inlierScenePoints);
    title('Matched Points (Inliers Only)');

    boundingBox = [1, 1;...                                 % top-left
            size(temp, 2), 1;...                       % top-right
            size(temp, 2), size(temp, 1);...  % bottom-right
            1, size(temp, 1);...                       % bottom-left
            1,1];                         % top-left again to close the polygon

    boundingBox = transformPointsForward(tform, boundingBox);
    subplot(1, 3, 3);
    imshow(im);
    hold on;
    line(boundingBox(:, 1), boundingBox(:, 2), 'Color', 'g');
    title('Detected Sign');
else
    boundingBox = 0;
end

end

