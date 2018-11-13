function [selected_coord, selected_distance] = f_select_minutiae(coord) 

%Eliminate minutia detection error based on spatial and directional
%difference

th_min = 30; %minimum number of minutiae 30
th_distance = 27; %Distance theshold 27

th_distance_min = 15; %Minimum Distance 15
num_neigh = 2; %minimum number of neighber minutiae 2

N1 = size(coord,1);
coord1 = coord;
while(1)      
    
    [distance, only_distance] = f_cal_distance(coord1);         
    
    if(N1 < th_min)
        selected_coord = coord;   
        selected_distance = only_distance;
        break;
    end       
    
    N = length(distance);    
    
    clear temp;
    min_indx = zeros(N,1);
    for i=1:N
        temp(i,1) = length(find(distance(i).distance < th_distance));
        temp_min = find(distance(i).distance<th_distance_min);
        if(~isempty(temp_min))
            if(temp_min(1) <i) %For index order
                min_indx(i,1) = temp_min(1);
            else
                min_indx(i,1) = temp_min(1)+1;
            end
        end
    end 
    max_num_neigh = max(temp);    
    num_min = sum(min_indx);
        
    if(max_num_neigh >= num_neigh) && (num_min == 0) %If very close minutiae exist more than num_neigh
        indx = find(temp == max_num_neigh);       
        temp(indx(1)) = -99;
        indx_for_rep = find(temp ~= -99);
        coord1 = coord1(indx_for_rep,:);                
    elseif (num_min ~= 0) %If any distance is lower than th_distance_min
        r_min_indx = find(min_indx ~= 0);
        min_indx(r_min_indx(1)) = -99;
        indx_for_rep = find(min_indx ~= -99);
        coord1 = coord1(indx_for_rep,:);
    elseif (max_num_neigh < num_neigh) && (num_min == 0)  
        selected_coord = coord1;
        selected_distance = only_distance;
        break;
    end        
    
end