clear;
clc;
load woman;

im = X;
[H,W] = size(im);

fim = fftshift(fft2(im));

% ideal LPF
ilpf = zeros(H,W);
uc = H/2; vc = W/2;
D = 80; 
ilpf(uc-D:uc+D,vc-D:vc+D) = 1;

ffim = fim.*ilpf;
im2 = ifft2(ifftshift(ffim));
figure(5); imshow(im2/255);

% gaussian LPF
uc = H/2; vc = W/2;
sig = 20;
[U,V] = meshgrid(-H/2:H/2-1,-W/2:W/2-1);
glpf = exp(-(U.^2 + V.^2)/(2*sig*sig));

ffim = fim.*glpf;
im2 = ifft2(ifftshift(ffim));
figure (6); imshow(im2/255);

