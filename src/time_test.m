function time_test

NET = create_nn([240, 320]);
NET = vl_simplenn_tidy(NET);
NET.layers{end}.type = 'softmax';

images = create_data('C:\Users\Joshua\Documents\MATLAB\Projects\Jutsu_Classifier\Images');
im = vl_imreadjpeg(images.data(1));
im = cell2mat(im);
im = reshape(im, 240, 320, 3, 1);

tic;
for i = 1:10
    vl_simplenn(NET, im, [], [], 'Mode', 'test');
end
time = toc / 10;

aend