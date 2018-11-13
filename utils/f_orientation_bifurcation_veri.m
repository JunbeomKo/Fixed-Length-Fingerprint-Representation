function CO2 = f_orientation_bifurcation_veri(CO)
for i = 1:size(CO,1)       
    
    CO2(i,1:2) = CO(i,1:2);
    if(CO(i,3) >= 256)
        error('over than 255')
    end
    
%     temp = CO(i,3)*360/255;
%     
%     if(temp <= 180)
%         temp = 180-temp;
%     else
%         temp = 360-(temp-180);
%     end  
    
    if(CO(i,3)<=127)
        temp = CO(i,3)*180/128;
        temp = 180-temp;
    else
        temp = CO(i,3)*180/128;
        temp = 360-(temp-180);
    end
    
    CO2(i,3) = temp;
end