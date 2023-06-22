% second image, LHE of 51 x 51 produces better contrast in some of the
% trees than GHE
clear;
clc;
im = double((imread('LC2.jpg')));
[H,W] = size(im);
im2 = im; im2(:,:) = 0;

ws = 25;
numbins = 256;
for i=1:H
    for j=1:W
        minx = max([1,j-ws]);
        maxx = min([W,j+ws]);
        miny = max([1,i-ws]);
        maxy = min([H,i+ws]);
        
        imp = im(miny:maxy,minx:maxx); imp = imp(:);
        limp = length(imp);
        p = zeros(numbins,1);
        for k=1:limp
            fk = floor(imp(k));
            p(fk+1) = p(fk+1)+1;
        end
        p = p/sum(p);
        c = 255*cumsum(p);
        
        im2(i,j) = c(floor(im(i,j))+1);
    end
end

imshow(im/255);
figure(2); imshow(im2/255);
imgl = histeq(uint8(im));
figure(3); imshow(imgl);