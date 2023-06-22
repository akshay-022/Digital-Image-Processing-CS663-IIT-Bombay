clear;
clc;
load woman;

im = X;
[H,W] = size(im);
padded_im = padarray(im,[H/2 W/2],'symmetric');

fim = fftshift(fft2(padded_im));

% ideal LPF
ilpf = zeros(2*H,2*W);
uc = H; vc = W;
D = 80; 
ilpf(uc-D:uc+D,vc-D:vc+D) = 1;

ffim = fim.*ilpf;
im2 = ifft2(ifftshift(ffim));
im2 = im2(H-H/2:H+H/2,W-W/2:W+W/2);
figure(3); imshow(im2/255);
figure(4); Z1 = log(abs(ilpf)+1); imagesc(Z1,[min(Z1(:)) max(Z1(:))]); colorbar;

% gaussian LPF
uc = H; vc = W;
sig = 40;
[U,V] = meshgrid(-H:H-1,-W:W-1);
glpf = exp(-(U.^2 + V.^2)/(2*sig*sig));

ffim = fim.*glpf;
im2 = ifft2(ifftshift(ffim));
im2 = im2(H-H/2:H+H/2,W-W/2:W+W/2);
figure(5); imshow(im2/255);
figure(6); Z1 = log(abs(glpf)+1); imagesc(Z1,[min(Z1(:)) max(Z1(:))]); colorbar;


