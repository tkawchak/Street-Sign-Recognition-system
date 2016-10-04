function [ output ] = edgeDetect( input )
% edgeDetect - apply smoothing and LoG to detect
% edges of a photo.

% could I apply some sort of KNN classifier to detect
% where the signs are located?

% define some vars here
num_corners = 50;
derivative_filter = [-1 0 1]/2;

imshow(input);
title('original');
figure;

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
Ix = imfilter(im, derivative_filter);
imshow(Ix);
title('I_x filter');
figure;

% apply Iy
Iy = imfilter(im, derivative_filter');
imshow(Iy);
title('I_y filter');
figure;

% grad mag
Imag = sqrt(double(Ix.^2 + Iy.^2));
maxVal = max(max(Imag));
indices = Imag < maxVal-1;
Imag(indices) = 0;
imshow(Imag);
title('I_{mag} filter');
figure;

% matlab edge detection
edges = edge(im);
imshow(edges);
title('matlab edge detection');
figure;

% boundaries
[B,L,N,A] = bwboundaries(edges);
mat = [1 0 0 1 0;
    0 1 0 1 1;
    1 0 0 0 1;
    1 1 1 0 0;
    0 1 1 0 1];
spy(mat);
mat
title('adjacency matrix');
figure;
imshow(L);
title('regions');
figure;

% tutorial on boundaries and such
% https://www.mathworks.com/help/images/ref/bwboundaries.html
imshow(input);
title('boundaries');
hold on;
for k=1:length(B)
    %if(~sum(A(k,:)))
       boundary = B{k};
    %end
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);
end


output = im;

end

