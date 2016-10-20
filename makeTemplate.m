function [ template ] = makeTemplate( image, dim)
%MAKETEMPLATE makes a template of the image
    template = rgb2gray(image);
    [m, n] = size(template);
    max_dim = max(m, n);
    scale = dim / max_dim;
    template = imresize(template, scale);
    imshow(template);
end

