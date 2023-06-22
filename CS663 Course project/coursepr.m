numimages=12;
numfeat= 2;
hinit = zeros(numimages, numimages, 3, 3);
hfinal = zeros(numimages, numimages, 3, 3);
u = zeros(numimages, numfeat, 3);  %x,y,1
u(1,1,:)= [5,6,7];

%
%u2 = zeros(3,3,3);
%u2(1,1,2)= 1;
%u2(1,1,:)
%

r = zeros(numimages, numimages, numfeat, 3);
l = zeros(numimages, numimages);
f = zeros(numimages,numimages, numfeat);

fu = @(x)myfun(x,r,u,l,f, numimages, numfeat);

hfinal = lsqnonlin(fu,hinit)



function sum = myfun(hinit,r,u,l,f,numimages, numfeat)
    sum=0;
    h= zeros(numimages, numimages, numfeat);
    for i=1:numimages
        for j=1:numimages
            for k=1:numfeat
                r(i,j,k,1) = u(i,k,1) - (    (hinit(i,j,1,1)* u(j,k,1))  +    (hinit(i,j,1,2)* u(j,k,1))    +     (hinit(i,j,1,3)* u(j,k,1))    );
                r(i,j,k,2) = u(i,k,2) - (    (hinit(i,j,2,1)* u(j,k,2))  +    (hinit(i,j,2,2)* u(j,k,2))    +     (hinit(i,j,2,3)* u(j,k,2))    );
                r(i,j,k,3) = u(i,k,3) - (    (hinit(i,j,3,1)* u(j,k,3))  +    (hinit(i,j,3,2)* u(j,k,3))    +     (hinit(i,j,3,3)* u(j,k,3))    );
                sqsum= r(i,j,k,1)^2 + r(i,j,k,2)^2 + r(i,j,k,3)^2;
                if sqsum<2
                    h(i,j,k)= sqsum^2;
                else
                    h(i,j,k)= 4*(sqsum-1);
                end
                sum = sum + (h(i,j,k)*l(i,j)*f(i,j,k));
            end
        end
    end
end


