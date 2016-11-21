function [images, labels] = getBatch(imdb, batch)

images = vl_imreadjpeg(imdb.images.data(batch), 'NumThreads', feature('numCores'));
images = reshape(images, 1, 1, []);
images = cell2mat(images);
images = reshape(images, 240, 320, 3, []);
% Normalize the images
mean = repmat(reshape(imdb.meta.mean, 1, 1, 3), 240, 320);
images = bsxfun(@minus, images, mean);
images = images ./ 255;

labels = imdb.images.labels(batch);

end