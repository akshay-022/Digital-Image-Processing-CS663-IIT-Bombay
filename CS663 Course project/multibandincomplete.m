numImages = 7;
i_h = 1024;
i_w = 768;
Weights = ones(i_h,i_w,numImages);
Images = zeros(i_h,i_w,numImages);

for i = 1:numImages
    name = 'image' + string(i) + '.jpeg';
    I = rgb2gray(imread(name));
    Images(:,:,i) = I;
end

numTrials = 1;

for k=1:numTrials
    num = zeros(i_h,i_w);
    den = zeros(i_h,i_w);
    for n=1:numImages
        I_sigma = imgaussfilt(Images(:,:,n),sqrt(2*k+1));
        B_k = Images(:,:,n) - I_sigma;
        Weights(:,:,n) = imgaussfilt(Weights(:,:,n),sqrt(2*n+1));
        num = num + B_k.*Weights(:,:,n);
        den = den + Weights(:,:,n);
        Images(:,:,n) = I_sigma;
    end
    I_k = num./den;
end
imshow(I_k)