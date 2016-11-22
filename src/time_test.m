function time_test
%%%
%%% Test to see how long it takes for a single image to go through the
%%% network
%%%

NET = create_nn([240, 320]);
NET = vl_simplenn_tidy(NET);
NET.layers{end}.type = 'softmax';

images = create_data('C:\Users\Joshua\Dropbox\AR_Classifier_Images\Images');
im = vl_imreadjpeg(images.data(1));
im = cell2mat(im);
im = reshape(im, 240, 320, 3, 1);

numToAverageOver = 100;
tic;
for i = 1:numToAverageOver
    vl_simplenn(NET, im, [], [], 'Mode', 'test');
end
time = toc / numToAverageOver

end