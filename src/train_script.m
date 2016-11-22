%%% Training script
%%% This is the "manager" of the project

%% Load in the images
imdb.images = create_data('C:\Users\Joshua\Documents\MATLAB\Projects\Jutsu_Classifier\Images');

% Normalize images and save the normalized mean in a variable
if ~exist('rgbMean.mat', 'file')
    NormalizeRGB(imdb.images.data);
end
imdb.meta.mean = load('rgbMean.mat');
imdb.meta.mean = imdb.meta.mean.meanPixel;

% Randomize the images
randOrder = randperm(length(imdb.images.labels));
imdb.images.data = imdb.images.data(randOrder);
imdb.images.labels = imdb.images.labels(randOrder);

% Create the sets
imdb.images.set = ones(length(imdb.images.labels), 1);
imdb.images.set(ceil(length(imdb.images.set) * 9 / 10): end) = 2 * ones(ceil(length(imdb.images.set) / 10), 1);


%% Prepare for training
% Options for cnn_train
opts.backPropDepth = +inf;
opts.batchSize = 16;
opts.numEpochs = 1;
totalNumEpochs = 100;
opts.learningRate = 0.001;
opts.conserveMemory = true;
opts.prefetch = false;

useGpu = false; % Turn this on/off for GPU support
if useGpu
    opts.gpus = [1];
end

% Create the neural network
NET = create_nn([240, 320]);

% Case where training is being resumed
if exist('data/exp', 'dir')
    files = dir('data/exp/net-epoch-*.mat');
    if ~isempty(files)
        oldEpoch = length(files);
        resume = input(['Do you want to resume training from epoch ' num2str(oldEpoch) '? (y/n)\n'], 's');
        if strcmp(resume, 'y')
            load('data/exp/opts.mat'); % Load the previous opts
            opts.numEpochs = oldEpoch;
        % Delete all previous training files if they aren't wanted
        else
            rmdir('data/exp', 's');
        end
    end
end

% Train the net
for i = opts.numEpochs:totalNumEpochs
    [NET, stats] = cnn_train_jutsu(NET, imdb, @getBatch, opts);
       
    % Needed for CNN train to keep going
    opts.numEpochs = opts.numEpochs + 1;
    save('data/exp/opts.mat', 'opts');
end

