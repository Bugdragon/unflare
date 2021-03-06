clc; clear;
warning off;

display('# Compiling UnFlare algorithms...');

mex detectFlare.cpp MxArray.cpp ../Processing/FlareDetector.cpp CXXFLAGS="$CXXFLAGS -F../" LDFLAGS="$LDFLAGS -F../ -framework opencv2"
mex inpaintFlare.cpp MxArray.cpp ../Processing/FlareInpainter.cpp CXXFLAGS="$CXXFLAGS -F../" LDFLAGS="$LDFLAGS -F../ -framework opencv2"

display('# Running algorithm on test pictures...');

files = dir('Images/*.jpg');
for f = 1:size(files, 1);
    display(files(f).name);
    image = imread(sprintf('Images/%s', files(f).name));
    
    % Detection
    params.minThreshold = 50;
    params.maxThreshold = 255;
    params.thresholdStep = 10;
    params.minDistBetweenBlobs = 50;
    
    params.filterByCircularity = true;
    params.minCircularity = 0.4;
    params.maxCircularity = 1;
    
    params.filterByArea = true;
    params.minArea = 400;
    params.maxArea = 1500;
    
    params.filterByConvexity = true;
    params.minConvexity = 0.8;
    params.maxConvexity = 1;
    
    params.filterByInertia = true;
    params.minInertiaRatio = 0.7;
    params.maxInertiaRatio = 1;
    
    mask = detectFlare(image, params);
    
    % Inpainting
    params.inpaintingType = 2;
    params.windowSize = 300;
    params.patchSize = 15;

    inpainted = inpaintFlare(image, mask, params);

    figure(f);
    imshow(inpainted);
end
