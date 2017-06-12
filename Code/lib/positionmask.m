function [x,y] = positionmask(xrep,yrep,xspacing,yspacing,positionrandom)
    [x,y] = meshgrid(0:xrep,0:yrep);
    if positionrandom
        for k=1:yrep+1
            x(k,:) = x(k,randperm(xrep+1));
        end

        for k=1:xrep+1
           y(:,k) = y(randperm(yrep+1),k); 
        end

        for k=1:xrep+1
            x(:,k) =x(y(:,k)+1,k);
        end
    end
    x=x*xspacing;
    y=y*yspacing;

end