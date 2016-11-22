function images = create_data(baseDir)

% This will hold the images and labels
images.data = cell(0);
images.labels = cell(0);

%% Get the class files and number of classes
classFolders = dir(baseDir);
classFolders = classFolders(3:end);

%% Store the image filenames and their labels
for i = 1:length(classFolders)
    classFiles = dir([baseDir '\' classFolders(i).name '\*.jpg']);
    classFilesNames = cell(0);
    for j = 1:length(classFiles)
        classFilesNames = [classFilesNames [baseDir '\' classFolders(i).name '\' classFiles(j).name]];
    end
    
    images.data = [images.data classFilesNames];
    
    class = repmat(i, length(classFilesNames), 1);
    class = mat2cell(class, ones(length(classFilesNames), 1), 1);
    images.labels = [images.labels, class'];
end

images.labels = cell2mat(images.labels);

end
