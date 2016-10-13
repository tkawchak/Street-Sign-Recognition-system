function [ boundingBox ] = matchTemplate( temp, im )
% matchTemplate - matches the template to the image
% image is a colored image
% template is a cropped street sign that is gray
im_g = rgb2gray(im);
%temp = rgb2gray(template);

image_points = detectSURFFeatures(im_g);
temp_points = detectSURFFeatures(temp);
imshow(im_g);
title('100 strongest Feature points');
hold on;
plot(selectStrongest(image_points, 200));

[im_feat, im_points] = extractFeatures(im_g, image_points);
[temp_feat, temp_points] = extractFeatures(temp, temp_points);

pairs = matchFeatures(im_feat, temp_feat);

matchedBoxPoints = im_points(pairs(:, 1), :);
matchedScenePoints = temp_points(pairs(:, 2), :);
figure;
showMatchedFeatures(im_g, temp, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Matched Points (Including Outliers)');

end

