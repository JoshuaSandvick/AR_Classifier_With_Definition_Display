camList = webcamlist();
cam = webcam(camList{end});
cam.Resolution = '320x240';

im = snapshot(cam);
imshow(im);

% Load in the images
imdb.images = create_data('C:\Users\Joshua\Documents\MATLAB\Projects\Jutsu_Classifier\Images');