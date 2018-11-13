function circle_div = f_re_make_circle(m,down_scale)

rad = (m-1)/2;
oned_downscale = sqrt(down_scale);

m = round(rad/oned_downscale*2+1);
n = round(m);

circle_div = -ones(m,n);

for i=1:m
    for j=1:n
        
        x=oned_downscale*j-rad;
        y=rad-oned_downscale*i;
        
        temptemp = x^2+y^2;
        distance = sqrt(temptemp);
        theta = atan2(y,x)*180/pi;
        circle_div(i,j,3) = distance;
        circle_div(i,j,4) = x;
        circle_div(i,j,5) = y;
        if (distance <= rad)
            if((theta>=-30)&& (theta<30))
                circle_div(i,j,1) = 1;
                circle_div(i,j,2) = theta;
            elseif((theta>=30)&& (theta<90))
                circle_div(i,j,1) = 2;            
                circle_div(i,j,2) = theta;
            elseif((theta>=90)&& (theta<150))
                circle_div(i,j,1) = 3;
                circle_div(i,j,2) = theta;
            elseif((theta>=150) || (theta<-150))
                circle_div(i,j,1) = 4;
                circle_div(i,j,2) = theta;
            elseif((theta>=-150)&& (theta<-90))
                circle_div(i,j,1) = 5;
                circle_div(i,j,2) = theta;
            elseif((theta>=-90)&& (theta<-30))
                circle_div(i,j,1) = 6;
                circle_div(i,j,2) = theta;
            end     
        end
    end
end