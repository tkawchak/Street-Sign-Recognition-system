%% create a convolutional neural net
% this convolutional neural net will have the following layers to start:
% 20x20 input image layer
% convolution layer - 3x3 convolution applied to image
w1 = rand(3, 3);
b1 = rand(1, 1);
% ReLU layer
% convolution layer - 3x3 convolution applied to image
w2 = rand(3, 3);
b2 = rand(1, 1);
% ReLU layer
% maxpool layer - reduce size to 10x10
% convolution layer - 3x3 convolution applied
w3 = rand(3, 3);
b3 = rand(1, 1);
% ReLU layer
% full connect layer - 10x10 image to 10x1
w4 = rand(10, 1);
b4 = rand(1, 1);
% weights to get output from 10x1 array
w5 = rand(10, 1);
b5 = rand(1, 1);

%% load an input image
im = rand(20, 20);

% smooth image

% subtract median value

%% process the input image

% load in some sample images here like a black square so I can test the
% performance.  All of the weights should tend toward black


%% perorm a forward pass

net1 = imfilter(im, w1) + b1;
out1 = 1/(1 + exp(-net1));

net2 = imfilter(out1, w2) + b2;
out2 = 1/(1 + exp(-net2));

pool1 = maxpool(out2);

net3 = imfilter(pool1, w3) + b3;
out3 = 1/(1 + exp(-net3));

net4 = reshape(out3, 100, 1);
net4(end+1) = 1;

net4 = net4' * w4;
out4 = 1/(1 + exp(-net4));

net5 = out4;
net5(end+1) = 1;
net5 = net5' * w5;
out5 = 1/(1 + exp(-net5));


%% perform a backward pass - training
target = 1;
eta = 1;
eta_conv = eta;

% a 10x10 image
% convoved with 3x3 filter
im = 2*[ones(5, 10); zeros(5, 10)] - 1;
im2 = 2*[zeros(5, 10); ones(5, 10)] - 1;
out2 = padarray(im, [1 1], 0, 'both');

% 10 x 10 (or 100 x 1)
% we add a 1 for the bias (101 x 1)
%out3 = rand(10, 10);
%out3 = reshape(out3, 100, 1);
%out3(end+1) = 1;

% 3x3 filter
w1 = 2*rand(3, 3)-1;
% 3x3 filter
w2 = 2*rand(3, 3)-1;
% 1 x 1 bias value
b2 = 0.2;
% 3x3 filter
w3 = 2*rand(3, 3)-1;
w3_init = w3;
% bias value (scalar)
b3 = 0.2;
% 101 x 10
w4 = 2*rand(101, 10)-1;
w4_init = w4;
% 11 x 1
w5 = 2*rand(11, 1)-1;
w5_init = w5;

for i=1:1000
    % forward pass
    
    % 10 x 10
    net2 = imfilter(out1(2:end-1, 2:end-1), w2) + b2);
    % 10 x 10
    out2 = max(net2, 0);
    %fprintf('forward layer 2\n');
    
    pool1 = maxpool(out2);
    
    % 10 x 10
    net3 = imfilter(out2(2:end-1, 2:end-1), w3) + b3;
    % 10 x 10
    out3 = max(net3, 0);
    %fprintf('forward layer 3\n');
    
    % 100 x 1
    out3 = reshape(out3, 100, 1);
    % 101 x 1
    out3(end+1) = 1;
    % 10 x 1
    net4 = w4' * out3;
    % 10 x 1
    out4 = 1./(1+exp(-net4));
    % 11 x 1
    out4(end+1) = 1;
    %fprintf('forward layer 4\n');
    
    % 1 x 1
    net5 = w5' * out4;
    % 1 x 1
    out5 = 1./(1+exp(-net5));
    %fprintf('forward layer 5\n');
    fprintf('output for iteration %d: %.3f\n', i, out5);

    % backward propogation of error
    % 1 x 1
    e5 = target - out5;
    % 1 x 1
    delta5 = - e5 .* (out5.*(1-out5));
    % 11 x 1
    w5 = w5 - eta * out4 * delta5(1:1, 1)';
    %fprintf('back prop layer 5\n');
    
    % 11 x 1
    e4 = w5 * delta5;
    % 11 x 1
    delta4 =  - e4 .* (out4 .* (1-out4));
    % 10 x 1
    delta4 = delta4(1:10, 1);
    % 101 x 10
    w4 = w4 - eta * out3 * delta4';
    %fprintf('back prop layer 4\n');
    
    % 101 x 1
    e3 = w4 * delta4;
    %fprintf('here\n');
    % 101 x 1
    delta3 = zeros(101, 1);
    %fprintf('here\n');
    for k=1:length(e3)
        if (out3(k) == 0)
            delta3(k) = 0;
        else
            % should this be negative???
            delta3(k) = e3(k);
        end
    end
    
    % 10 x 10
    delta3 = delta3(1:100, :);
    delta3 = reshape(delta3, 10, 10);
    [m, n] = size(delta3);
    
    maxout = zeros(10, 10);
    
    % 3 x 3
    % loop through the output image
    for k=1:m
        for j=1:n
            % loop through the size of the filter
            for s=[1 2 3]
                for t = [1 2 3]
                    w3(s, t) = w3(s, t) - eta_conv * delta3(k, j) * ...
                        out2(k+s-1, j+t-1);
                    e2(k, j) = delta3(k, j)
                end
            end
        end
    end
    
    
    
    %fprintf('back prop layer 3\n');
    
end


%% SOME NOTES ON THE IMPLEMENTATION

% back propogation involves the chain rule
% being applied many times as follows

% for each node, we should store:
%   the error due to the input
%   the error due to the output

% e_n is the change in total error with
% respect to the output of layer n

% delta_n is the change in total error
% with respect to the value of layer n
% before the logistic function is applied

% w_n this is the update to the weights
% of layer n

% net_n is the input to layer n

% out_n is the output of layer n

% w_n is a weight from out_n to net_(n+1)

% HOW TO DO WEIGHT UPDATING FOR CONVOLUTIONAL LAYER??
%   updates will occur for each weight multiple times
% derivative of the ReLU layer:
%   1 or x != 0
%   0 for x = 0
% updates for convolution operation:
%   error at the output from the convolution
%   multiplied by the input to the convolution
%   so for each node in the output
%   we update each of the weights in the convolution
%   for this I will only update the weights for
%   values that are not on the border so we do not have to deal with
%   any bordering values and such
