function [ output ] = edgeDetect( input )
% edgeDetect - apply smoothing and LoG to detect
% edges of a photo.

% could I apply some sort of KNN classifier to detect
% where the signs are located?

% define some vars here
num_corners = 50;
derivative_filter = [-1 0 1];

% preprocessing for image
input = rgb2gray(input);
im = imgaussfilt(input, 1);
imshow(im);
title('pre-processed image');
figure;

% apply LoG filter
LoG = [0 1 0; 1 -4 1; 0 1 0];
temp = imfilter(im, LoG);
imshow(temp);
title('LoG filter');
C = corner(im, 'Harris');
hold on;
%plot(C(:, 1), C(:, 2), 'r*');

% performs simple culstering on the data
idx = kmeans(C, 1);
plot(C(idx==1,1), C(idx==1,2),'r.');
hold on
plot(C(idx==2,1), C(idx==2,2),'b.');
hold on
plot(C(idx==3,1), C(idx==3,2),'g.');
hold on
plot(C(idx==4,1), C(idx==4,2),'y.');
figure;
% TAKE THESE CORNER POINTS AND TRY TO FIT REGULAR SHAPES TO THEM
% IE: TRIANGLES, SQUARES, OCTAGONS, ...

% apply Ix
Ix = imfilter(input, derivative_filter);
imshow(Ix);
title('I_x filter');
figure;

% apply Iy
Iy = imfilter(input, derivative_filter');
imshow(Iy);
title('I_y filter');

output = im;

end

