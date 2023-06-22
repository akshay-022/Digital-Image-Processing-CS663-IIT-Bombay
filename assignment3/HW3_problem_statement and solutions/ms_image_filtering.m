clear; clc; close all;

im = double(imread ('kodak24.png'));
[H,W] = size(im);
im = im + randn(H,W)*5;
im2 = im; im2(:,:) = 0;

figure(1); imshow(im/255);

epsilon = 0.0001; % tolderance for convergence
P = 11; % radius of window to compute mean, so window will be 23 x 23
sig1 = 3; sig2 = 15; % kernel parameters for xy nd itnensity respectively
numiters = zeros(H,W); % array to record number of iterations to reach convergence (for book-keeping, not abs. essential)
cells = cell(H,W); % cells{i,j} will contain a list of all those points which converged to a point with spatial coordinates (i,j). All such points will be assigned to one and the same segment!
tol_xy = 8; % tolerance in x and y when it comes to segmenting points

for i=1:H
    fprintf (' %d',i);
    for j=1:W
        curr = [i j squeeze(im(i,j))']; % a point is [x,y,I]
        oldcurr = curr;

        while (1)
            numiters(i,j) = numiters(i,j)+1; % increment iteration count
            currx = floor(curr(2)); 
            curry = floor(curr(1));            
            
            if currx <= 0 || curry <= 0 || curry > H || currx > W, break; end
            
            [X,Y] = meshgrid(max(currx-P,1):min(currx+P,W),max(curry-P,1):min(curry+P,H));
	        Z = im(max(curry-P,1):min(curry+P,H),max(currx-P,1):min(currx+P,W));
            weights = exp(-((X-j).^2+(Y-i).^2)/(2*sig1*sig1) -((Z-im(i,j)).^2)/(2*sig2*sig2));
        
            curr(1) = sum(weights(:).*Y(:))/sum(weights(:));
            curr(2) = sum(weights(:).*X(:))/sum(weights(:));
            curr(3) = sum(weights(:).*Z(:))/sum(weights(:));
            
            if sum((curr-oldcurr).^2) < epsilon, break; end % convergence reached!
            oldcurr = curr;
        end
        im2(i,j) = curr(3);  % copy color values into "filtered image"      

        % cells{yy,xx} [see below for what is yy and xx] will contain a list of all those points which converged to a point with spatial coordinates (i,j). All such points will be assigned to one and the same segment!
        yy = ceil(curr(1)/tol_xy); xx = ceil(curr(2)/tol_xy);
        cells{yy,xx} = [cells{yy,xx} [i;j;curr(3)]];
    end
end

im2(im2 < 0)= 0;
im2(im2 > 255) = 255;
figure(2); imshow(im2/255);

