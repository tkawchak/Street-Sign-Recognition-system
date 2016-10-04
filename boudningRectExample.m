original = imread('streetsign6.jpg');
img = rgb2gray(original);

BW = edge(img,'canny',0.08);

[B,L,N,A] = bwboundaries(BW);
imshow(L);
title('regions');
figure;

imshow(img);
title('boundaries');
hold on;
for k=1:length(B)
    if(~sum(A(k,:)))
       boundary = B{k};
    end
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
figure;


blobMeasurements = regionprops(logical(BW), 'BoundingBox');
numberOfBlobs = size(blobMeasurements, 1);


rectCollection = [];
for k = 1 : numberOfBlobs % Loop through all blobs.
rects = blobMeasurements(k).BoundingBox; % Get list ofpixels in current blob.
x1 = rects(1);
y1 = rects(2);
x2 = x1 + rects(3);
y2 = y1 + rects(4);
x = [x1 x2 x2 x1 x1];
y = [y1 y1 y2 y2 y1];
rectCollection(k,:,:,:) = [x1; y1; x2; y2];
end

% get min max
xmin=min(rectCollection(:,1));
ymin=min(rectCollection(:,2));
xmax=max(rectCollection(:,3));
ymax=max(rectCollection(:,4));

% define outer rect:
outer_rect=[xmin ymin xmax-xmin ymax-ymin];

crop = imcrop(original,outer_rect);

imshow(crop);
title('cropped');