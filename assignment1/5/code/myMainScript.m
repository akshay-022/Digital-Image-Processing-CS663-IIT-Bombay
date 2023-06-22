im1=imread('goi1.jpg');
im2=imread('goi2_downsampled.jpg');
imshow(im1);
imshow(im2);



for i=1:12, 
    imshow(im1);
    [x1(i), y1(i)] = ginput(1);
    imshow(im2);
    [x2(i), y2(i)] = ginput(1);
end;
one1= ones(1,12);
init= [x1; y1; one1];
final= [x2; y2; one1];
A= final/init;




im3= im2;
for r = 1:size(im2, 1)    % for number of rows of the image
    for c = 1:size(im2, 2)    % for number of columns of the image
        k1= inv(A)* [r; c; 1];
        k2= round(k1);
        indic= 1;
        if((k2(1)<=0 | k2(1)>size(im1, 1))) 
            indic=0;
        end
        if((k2(2)<=0 | k2(2)>size(im1, 2))) 
            indic=0;
        end
        if(indic==1)
            im3(r,c)= im1(k2(1),k2(2));
        else
            im3(r,c)= 0;
        end 
        % increment counter loop
        
    end
    
end
imshow(im3);









im4= im2;
for r = 1:size(im2, 1)    % for number of rows of the image
    for c = 1:size(im2, 2)    % for number of columns of the image
        k1= inv(A)* [r; c; 1];
        k2= floor(k1);
        k3= ceil(k1);
        indic= 1;
        if((k2(1)<=0 | k3(1)>size(im1, 1))) 
            indic=0;
        end
        if((k2(2)<=0 | k3(2)>size(im1, 2))) 
            indic=0;
        end
        if(indic==1)
            im4(r,c)=     round(((im1(k2(1),k2(2))*(k3(1)-k1(1))*(k3(2)-k1(2)))     +     (im1(k2(1),k3(2))*(k3(1)-k1(1))*(k1(2)-k2(2)))    +      (im1(k3(1),k2(2))*(k1(1)-k2(1))*(k3(2)-k1(2)))   +    (im1(k3(1),k3(2))*(k1(1)-k2(1))*(k1(2)-k2(2))))    ) ;            
        else
            im4(r,c)= 0;
        end 
    end
end
imshow(im4);








for i=1:12, 
    x1(i) = i;
    y1(i) = i;
    x2(i) = i+1;
    y2(i) = i+1;
end;
one1= ones(1,12);
init= [x1; y1; one1];
final= [x2; y2; one1];
A= final/init;
im3=im2/255 ;
for r = 1:size(im1, 1)    % for number of rows of the image
    for c = 1:size(im1, 2)    % for number of columns of the image
        k1= A* [r; c; 1];
        k2= round(k1);
        indic= 1;
        if((k2(1)<=0 | k2(1)>size(im1, 1))) 
            indic=0;
        end
        if((k2(2)<=0 | k2(2)>size(im1, 2))) 
            indic=0;
        end
        if(indic==1)
            im3(k2(1),k2(2))= im1(r,c);
        else
            im3(k2(1),k2(2))= 0;
        end 
    end
end
imshow(im3);








