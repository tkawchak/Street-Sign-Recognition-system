function [ template ] = makeTemplate( image, rows, cols, scale)
%MAKETEMPLATE makes a template of the image
    %image = double(image);
    imshow(image);
    figure;
    image_grey = rgb2gray(image);
    imshow(image_grey);
    figure;
    im_crop = image_grey(rows, cols);
    imshow(im_crop);
    figure;
    template = double(im_crop) - mean2(im_crop);
    template = imresize(template, scale);
    imshow(template);
end

