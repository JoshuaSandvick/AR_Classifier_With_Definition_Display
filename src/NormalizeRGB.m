function NormalizeRGB(imageNames)    
    nfiles = length(imageNames);
    images = cell(1, nfiles);
    for ii=1:nfiles
       currentfilename = imageNames{ii};
       currentimage = imread(currentfilename);
       images{ii} = single(currentimage);
    end

    red = 0;
    green = 0;
    blue = 0;

    for ii=1:nfiles
        red = red + mean(mean(images{ii}(:,:,1)));
        green = green + mean(mean(images{ii}(:,:,2)));
        blue = blue + mean(mean(images{ii}(:,:,3)));
    end
    red = red / nfiles;
    green = green / nfiles;
    blue = blue / nfiles;
    
    meanPixel = [red, green, blue];

    save('rgbMean.mat', 'meanPixel');
end