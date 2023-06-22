numImages = 5;
ih = 1024;
iw = 768;

connected_images = zeros(numImages*numImages,2);

for i =1:numImages
    for j=i+1:numImages
        name1 = 'X/image' + string(i) +'.jpeg';
        I1 = rgb2gray(imread(name1));
        points1 = detectORBFeatures(I1);
        
        name2 = 'X/image' + string(j) +'.jpeg';
        I2 = rgb2gray(imread(name2));
        points2 = detectORBFeatures(I2);
        
        features1 = extractFeatures(I1,points1);
        features2 = extractFeatures(I2,points2);
        
        indexPairs = matchFeatures(features1,features2,'MatchThreshold', 40,'MaxRatio',0.3,'Unique',true);
        
        matchedPoints1 = points1(indexPairs(:,1),:);
        matchedPoints2 = points2(indexPairs(:,2),:);
        try
            fRANSAC = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4); 
            connected_images((i-1)*numImages+j,1) = i;
            connected_images((i-1)*numImages+j,2) = j;
        catch
            continue;
        end  
    end      
end

connected_images( ~any(connected_images,2),:) = [];
connected_images = connected_images(:);
connected_images = unique(connected_images,'first');

n_ref = 'X/image' + string(connected_images(1)) +'.jpeg';
Iref = imread(n_ref); 
Final = zeros(ih,iw,7,3);
Original = zeros(ih,iw,7,3);
Original(:,:,1,:) = Iref;
for color=1:3
    Final_images = zeros(ih,iw,7);
    Final_images(:,:,1) = double(Iref(:,:,color));
    for i=connected_images(1):numImages
        name = 'X/image' + string(i) +'.jpeg';
        I = imread(name);
        Original(:,:,i,:) = I;
        Final_images(:,:,i) = imhistmatch(I(:,:,color),Iref(:,:,color));
    end
    Final(:,:,:,color) = Final_images;
end

for i=connected_images(1):numImages
    name = 'X/imageh' + string(i) + '.jpeg';
    Image = uint8(cat(3,Final(:,:,i,1),Final(:,:,i,2),Final(:,:,i,3)));
    imwrite(Image, name, "Quality", 100) ;
end

name_int = 'X/imageh'+string(connected_images(1))+'.jpeg';
I = rgb2gray(imread(name_int));
points = detectORBFeatures(I);
[features, points] = extractFeatures(I,points);

tforms(numImages) = projective2d(eye(3));
imageSize = zeros(numImages,2);
imageSize(1,:) = size(I);
 
for n = connected_images(1):numImages

    pointsPrevious = points;
    featuresPrevious = features;
    name = 'X/imageh' + string(n) +'.jpeg';    
    I = rgb2gray(imread(name));
    imageSize(n,:) = size(I);
    points = detectORBFeatures(I);    
    [features, points] = extractFeatures(I, points);

    indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true);

    matchedPoints = points(indexPairs(:,1), :);
    matchedPointsPrev = pointsPrevious(indexPairs(:,2), :);        

    tforms(n) = estimateGeometricTransform2D(matchedPoints, matchedPointsPrev,'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    tforms(n).T = tforms(n).T*tforms(n-1).T;
end

xlim = zeros(numel(tforms),2);
ylim = zeros(numel(tforms),2);

for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

avgXLim = mean(xlim, 2);
avgYLim = mean(ylim,2);

[~,idx] = sort(avgXLim);
[~,idy] = sort(avgYLim);

centerIdx = floor((numel(tforms)+1)/2);

centerImageIdx = idx(centerIdx);
%centerImageIdy = idy(centerIdx);

Tinvx = invert(tforms(centerImageIdx));
%Tinvy = invert(tforms(centerImageIdy));

for i = 1:numel(tforms)    
     tforms(i).T = tforms(i).T * Tinvx.T;
end

for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end
 
maxImageSize = max(imageSize);
 
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

width  = round(xMax - xMin);
height = round(yMax - yMin);

panorama = zeros([height width 3], 'like', I);

blender = vision.AlphaBlender('Operation', 'Binary mask','MaskSource', 'Input port');  
 
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

for i = connected_images(1):numImages
    
    I = imread('X/imageh'+string(i)+'.jpeg');   
   
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
                     
    mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
    
    panorama = step(blender, panorama, warpedImage, mask);
end

figure
imshow(panorama)
         

