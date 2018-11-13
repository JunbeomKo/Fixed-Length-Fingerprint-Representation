function out = f_MBLS(coord, rad, Num_ngh, circle_div, index, distance)

Num_min = size(coord,1); %Number of minutiae

for i = 1:Num_min	
    cnt_minutiae = 0;        
    cnt = 1;
    neigh_minutiae = [];
    for j = 1:Num_min
        if (j ~= i)		
            
            distance_temp = distance(i,j);
            all_neigh_minutiae(cnt,:)=coord(j,:); %Neighbor minutiae
            cnt = cnt+1;

            if (distance_temp < rad*1.1) %Neighbor minutiae within rad
                cnt_minutiae = cnt_minutiae + 1;                
                if (j<i) %For arrangement of index                   
                    neigh_minutiae(cnt_minutiae) = j;
                else
                    neigh_minutiae(cnt_minutiae) = j-1;
                end
                
            end       
        end
    end
    if (cnt_minutiae >= Num_ngh)                   
        new_neigh_minutiae = f_rotate_minutiae(coord(i,:), all_neigh_minutiae); %Local structure alignment based on direction of central minutia        
        
        if(isempty(neigh_minutiae)) %Empty local structure
            [m_size, n_size] = size(circle_div(:,:,1));
            local_structure(:,:,1) = -ones(m_size,n_size);
            
            N = length(index(1).r);  
            for j=1:N
                local_structure(index(1).r(j), index(1).v(j)) = 0; 
            end
            out(i).local_structure = local_structure;
        else        
            out(i).local_structure= f_make_localstructure(new_neigh_minutiae(neigh_minutiae,:), index, circle_div);   
            out(i).all_neigh = new_neigh_minutiae;
            out(i).neigh = new_neigh_minutiae(neigh_minutiae,:);
            out(i).min_count = size(neigh_minutiae,2);
            out(i).distance = distance(i,:);      
            out(i).central_direction = coord(i,3);
            out(i).central_coord = coord(i,1:2);
        end        
    else
        out(i).local_structure = 0;
    end

    clear neigh_minutiae all_neigh_minutiae temp_neigh_minutiae;    
     
end
