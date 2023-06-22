clear;
close all;

im = double(imread ('barbara256.png'));
imorig = im;
figure, imshow(imorig/255);
sigma = 20;
im = im + randn(size(im))*sigma;
figure, imshow(im/255);

[H,W] = size(im);
ps = 8;
ws = 15;
im2 = im; im2(:,:) = 0;
numcount = im2;
K = 200; % K = 25

% K = 250 and ws = 16 is also fine

for i=1:H-ps+1
    fprintf (' %d',i);
    for j=1:W-ps+1
        top = max([1 i-ws+1]);
        bottom = min([H-ps+1 i+ws-1]);
        left = max([1 j-ws+1]);
        right = min([W-ps+1 j+ws-1]);
        Pref = im(i:i+ps-1,j:j+ps-1);
        
        P = zeros(ps*ps,(bottom-top+1)*(right-left+1));
        count = 0;
        flags = zeros((bottom-top+1)*(right-left+1),1); dist = flags;
        indices = zeros((bottom-top+1)*(right-left+1),2);
        for k=top:bottom
            for l=left:right
                count = count+1;
                v = im(k:k+ps-1,l:l+ps-1);
                P(:,count) = v(:);
                dist(count) = sum((Pref(:)-v(:)).^2);
                indices(count,:) = [k l]; 
                flags(count) = 0;
            end
        end
        [dist,sortedindices] = sort(dist);
        P = P(:,sortedindices(1:K));
        flags(sortedindices(1:K))  = 1;
        
        CP = P*P';
        [V,D] = eig(CP);
        eigcoeffs = V'*P;
        mean_eigcoeffs_squared = mean(eigcoeffs.^2,2)-sigma*sigma;
        mean_eigcoeffs_squared(mean_eigcoeffs_squared < 0) = 0;
        mean_eigcoeffs_squared = repmat(mean_eigcoeffs_squared,1,K);      
        eigcoeffs(mean_eigcoeffs_squared~=0) = eigcoeffs(mean_eigcoeffs_squared~=0)./(1+sigma*sigma./mean_eigcoeffs_squared(mean_eigcoeffs_squared~=0));
        eigcoeffs(mean_eigcoeffs_squared==0) = 0;

        Prec = V*eigcoeffs(:,1);                
        y = indices(sortedindices(1),1); x = indices(sortedindices(1),2);
        im2(y:y+ps-1,x:x+ps-1) = im2(y:y+ps-1,x:x+ps-1) + reshape(Prec,ps,ps);       
        numcount(y:y+ps-1,x:x+ps-1) = numcount(y:y+ps-1,x:x+ps-1) + 1;
    end
end
im2 = im2./numcount;
imshow (im2/255);
err = sum((imorig(:)-im2(:)).^2)/(H*W);
fprintf ('\nMSE w.r.t. original clean image = %f',err);