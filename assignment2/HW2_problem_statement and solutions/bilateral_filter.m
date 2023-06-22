clear;
clc;
im = double(imread('kodak24.png'));
im1 = im + randn(size(im))*10;
[H,W] = size(im1);

sigma_s = 3;
sigma_r = 15;

im2 = zeros(H,W);
for i=1:H
    fprintf('%d ',i);
    for j=1:W
        minx = max([1,floor(j-3*sigma_s)]);
        maxx = min([W,floor(j+3*sigma_s)]);
        miny = max([1,floor(i-3*sigma_s)]);
        maxy = min([H,floor(i+3*sigma_s)]);
        [X,Y] = meshgrid(minx:maxx,miny:maxy);
        w_s = exp(-((X-j).^2 +(Y-i).^2)/(2*sigma_s*sigma_s));
        w_r = exp(-((im1(i,j)-im1(miny:maxy,minx:maxx)).^2)/(2*sigma_r*sigma_r));
        im2(i,j) = sum(sum(w_s.*w_r.*im1(miny:maxy,minx:maxx)))/sum(sum(w_s.*w_r));
    end
end

figure(1); imshow(im/255);
figure(2); imshow(im1/255);
figure(3); imshow(im2/255);