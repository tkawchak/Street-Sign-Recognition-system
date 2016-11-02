%% create a convolutional neural net
% this convolutional neural net will have the following layers to start:
% 20x20 input image layer
% convolution layer - 4x4 convolution applied to image
conv1 = rand(4, 4);
% ReLU layer
% convolution layer - 3x3 convolution applied to image
conv2 = rand(3, 3);
% ReLU layer
% maxpool layer - reduce size to 10x10
% convolution layer - 3x3 convolution applied
conv3 = rand(3, 3);
% ReLU layer
% full connect layer - 10x10 image to 1 output value
full_conn = rand(10, 10);
% softmax layer - threshold the output value

%% load an input image
im = rand(20, 20);

% smooth image

% subtract median value

%% process the input image

% load in some sample images here like a black square so I can test the
% performance.  All of the weights should tend toward black


%% perorm a forward pass
im = imfilter(im, conv1);
im = ReLU(im);
im = imfilter(im, conv2);
im = ReLU(im);
im = maxpool(im);
im = imfilter(im, conv3);
im = ReLU(im);
im = fullconnect(im, full_conn);
im = softmax(im);

out = im;


%% perform a backward pass - training
full_conn = full_conn - 0.05 * (target - out) * out * (1 - out) * full_conn;

% HOW TO DO WEIGHT UPDATING FOR CONVOLUTIONAL LAYER??



