function [out, only_distance] = f_cal_distance(coord) %spatial distance + direction distance

Num_min = size(coord,1);
only_distance = ones(Num_min,Num_min)*99;
for i = 1:Num_min
	ref_min = coord(i,:);
    cnt = 1;
    for j = 1:Num_min
        if (j ~= i)
			posx = coord(j,1);
			posy = coord(j,2);
            
            delta_angle = min(abs(coord(i,3)-coord(j,3)),360-abs(coord(i,3)-coord(j,3)));
        
            distance = sqrt((ref_min(1)-posx)^2+(ref_min(2)-posy)^2) + delta_angle*0.2;
            only_distance(i,j) = distance-delta_angle*0.2;
            out(i).distance(cnt) = distance;
            out(i).num_min = i;
            cnt = cnt+1;
        end
    end
end