function out = f_TBLS(CO_R, Rad, img, circle_div, index)

Num_min = size(CO_R,1);

cnt_valid=0;
cnt_invalid=0;
for i = 1:Num_min	    
    
    x = CO_R(i,1);
    y = CO_R(i,2);
    degree = CO_R(i,3);
    
    local_img = zeros(Rad*2+1, Rad*2+1);
    
    if(y-Rad>0) && (y+Rad<=size(img,1)) && (x-Rad>0) && (x+Rad<=size(img,2))
        local_img = img(y-Rad:y+Rad,x-Rad:x+Rad,1);
    elseif (y-Rad>0) && (y+Rad<size(img,1)) && (x-Rad<=0)        
        local_img(:,Rad+2-x:end) = img(y-Rad:y+Rad,1:x+Rad,1);
    elseif (y-Rad>0) && (y+Rad<size(img,1)) && (x+Rad>size(img,2))       
        local_img(:,1:Rad*2+1-((size(local_img,2)-Rad+x-1)-size(img,2))) = img(y-Rad:y+Rad,x-Rad:size(img,2),1);
    elseif (y-Rad<=0) && (x-Rad>0) && (x+Rad<=size(img,2))
        local_img(Rad+2-y:end,:) = img(1:y+Rad,x-Rad:x+Rad,1);
    elseif (y+Rad>size(img,1)) && (x-Rad>0) && (x+Rad<=size(img,2))
        local_img(1:Rad*2+1-((size(local_img,1)-Rad+y-1)-size(img,1)),:) = img(y-Rad:size(img,1),x-Rad:x+Rad,1);
    end
    
    rotated_local_img = imrotate(local_img, -degree);
    center_point = round((size(rotated_local_img)+1)/2);
    rotated_local_img = rotated_local_img(center_point-Rad:center_point+Rad, center_point-Rad:center_point+Rad);
    
    temp_img = rotated_local_img(index);
    if(std(double(temp_img))~=0)        

        out(i).local_structure= f_make_local_ridge(temp_img, index, circle_div);        
        out(i).central_direction = CO_R(i,3);
        out(i).central_coord = CO_R(i,1:2);      
        cnt_valid = cnt_valid+1;
    else
        out(i).local_structure = [];
        cnt_invalid = cnt_invalid+1;
    end
    
%     out(i).CO_R = CO_R;   

    clear neigh_minutiae all_neigh_minutiae temp_neigh_minutiae;         
end
