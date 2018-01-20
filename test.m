filename = 'tiger.bmp';
outputFileName = 'output.jpg';
imfinfo(filename)
img = imread(filename);

quality = 50;

compressionInfo = jpeg(img, quality, outputFileName);
imfinfo(outputFileName)
compressedImage = imread(outputFileName);

figure()
subplot(1, 2, 1)
imshow(img)
subplot(1, 2, 2)
imshow(compressedImage)
