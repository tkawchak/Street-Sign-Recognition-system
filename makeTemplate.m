function [ template ] = makeTemplate( image, dim, pad)
%MAKETEMPLATE makes a template of the image
    template = rgb2gray(image);
    imshow(template); figure;
    [m, n] = size(template);
    max_dim = max(m, n);
    scale = (dim-pad) / (max_dim);
    template = imresize(template, scale);
    [m, n] = size(template);
    back = ones(dim, dim);
    back((pad/2):(pad/2+m-1), (pad/2):(pad/2+n-1)) = mat2gray(template);
    template = back;
    imshow(template);
end

