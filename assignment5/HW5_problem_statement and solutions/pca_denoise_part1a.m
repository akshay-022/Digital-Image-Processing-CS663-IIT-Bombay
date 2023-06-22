clear;
close all;

im = double(imread ('barbara256.png'));
%im = im(1:256,257:512);
imorig = im;
figure,imshow (imorig/255);
sigma = 20;
im = im + randn(size(im))*sigma;
figure,imshow (im/255);

[H,W] = size(im);
ps = 8;
ws = 10;
im2 = im; im2(:,:) = 0;
numcount = im2;

P = zeros(ps*ps,(H-ps+1)*(W-ps+1));

count = 0;
for i=1:H-ps+1
    for j=1:W-ps+1
        count = count+1;
        v = im(i:i+ps-1,j:j+ps-1);
        P(:,count) = v(:);
    end
end
C = P*P';
[V,D] = eig(C);
eigcoeffs = V'*P;       
mean_eigcoeffs_squared = mean(eigcoeffs.^2,2)-sigma*sigma;       
mean_eigcoeffs_squared(mean_eigcoeffs_squared < 0) = 0;
mean_eigcoeffs_squared = repmat(mean_eigcoeffs_squared,1,count);      
eigcoeffs = eigcoeffs./(1+sigma*sigma./mean_eigcoeffs_squared);
P = V*eigcoeffs;
count = 0;
for i=1:H-ps+1
    for j=1:W-ps+1
        count = count+1;
        v = P(:,count);
        v = reshape(v,ps,ps);
        im2(i:i+ps-1,j:j+ps-1) = im2(i:i+ps-1,j:j+ps-1) + v;
        numcount(i:i+ps-1,j:j+ps-1) = numcount(i:i+ps-1,j:j+ps-1) + 1;
    end
end
im2 = im2./numcount;
figure,imshow (im2/255);
err = sum((imorig(:)-im2(:)).^2)/(H*W);
fprintf ('\nMSE w.r.t. original clean image = %f',err);