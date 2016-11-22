function NET = create_nn(imSize)
%%%
%%% imSize = [row#, col#]
%%%

% Create the net
NET.layers = {};

%% Create the convolutional layers
numCLayers = 3;

numFMapsOld = 3;
numFMapsNew = 16;
for i = 1:numCLayers
    fSize = [3 + 2 * (i - 1), 3 + 2 * (i - 1), numFMapsOld, numFMapsNew];
    bSize = [1, numFMapsNew];
    
    NET.layers{end + 1}.type = 'dropout';
    NET.layers{end}.rate = 0.5;
    
    NET.layers{end + 1}.type = 'conv';
    NET.layers{end}.size = fSize;
    NET.layers{end}.weights{1} = randn(fSize, 'single') * 0.001;
    NET.layers{end}.weights{2} = zeros(bSize, 'single');
    NET.layers{end}.meanavg{1} = zeros(fSize, 'single');
    NET.layers{end}.meanavg{2} = zeros(bSize, 'single');
    NET.layers{end}.varavg{1} = zeros(fSize, 'single');
    NET.layers{end}.varavg{2} = zeros(bSize, 'single');
    NET.layers{end}.pad = i;
    
    NET.layers{end + 1}.type = 'relu';
    NET.layers{end}.leak = 0.3;
    
    NET.layers{end + 1}.type = 'pool';
    NET.layers{end}.pool = 2;
    NET.layers{end}.method = 'max';
    NET.layers{end}.stride = 2;
    
    % Change the feature map sizes
    numFMapsOld = numFMapsNew;
    numFMapsNew = numFMapsNew * 2 ^ i;
end

%% Create the fully-convolutional layers
imSizeLeft = imSize ./ 2 ^ numCLayers;

for i = 1:2
    fSize = [imSizeLeft(1), imSizeLeft(2), numFMapsOld, numFMapsNew];
    bSize = [1, numFMapsNew];
    
    NET.layers{end + 1}.type = 'dropout';
    NET.layers{end}.rate = 0.5;
    
    NET.layers{end + 1}.type = 'conv';
    NET.layers{end}.size = fSize;
    NET.layers{end}.weights{1} = randn(fSize, 'single') * 0.001;
    NET.layers{end}.weights{2} = zeros(bSize, 'single');
    NET.layers{end}.meanavg{1} = zeros(fSize, 'single');
    NET.layers{end}.meanavg{2} = zeros(bSize, 'single');
    NET.layers{end}.varavg{1} = zeros(fSize, 'single');
    NET.layers{end}.varavg{2} = zeros(bSize, 'single');
    NET.layers{end}.pad = 0;
    
    if i == 1
        NET.layers{end + 1}.type = 'relu';
        NET.layers{end}.leak = 0.3;
    end
    
    % Change the feature map sizes
    numFMapsOld = numFMapsNew;
    numFMapsNew = 3;
    
    % Indicate the new image size
    imSizeLeft = [1, 1];
end

%% Create the loss layer
NET.layers{end + 1}.type = 'softmaxloss';    

%% Set up some extra parameters for the ADAM algorithm
NET.layers{1}.b1 = 0.9;
NET.layers{1}.b2 = 0.999;
NET.layers{1}.epsilon = 10 ^ -8;
NET.layers{1}.t = 0;

end