function [local_structure]= f_make_localstructure(new_neigh_minutiae1,index, circle_div)

[m_size, n_size] = size(circle_div(:,:,1));
local_structure(:,:,1) = -ones(m_size,n_size);

KK = size(new_neigh_minutiae1,1);
Y_axis = [0 1];           
            
sigy_dist = [0.5275, 0.5597, 0.6424, 0.6485, 0.6873, 0.7447, 0.7873, 0.8608, 0.9015];
sigx_dist = [1.0938, 1.6753, 1.7825, 1.9732, 2.4083, 2.6351, 2.6686, 2.8018, 2.9726];

sigy_dist = ((sqrt(sigy_dist)));
sigx_dist = ((sqrt(sigx_dist)));

N = length(index(1).r);  

for k=1:KK
    posx_nbr_new = new_neigh_minutiae1(k,1); 
    posy_nbr_new = new_neigh_minutiae1(k,2); 
    distance_m1_m2_temp(k) = sqrt(posx_nbr_new^2+posy_nbr_new^2);
    theta_temp(k) = atan2(Y_axis(2),Y_axis(1))*180/pi - atan2(posy_nbr_new,posx_nbr_new)*180/pi;
    
%% quantized
    alpha = 3.5; %For shape of 2DGF
    if (distance_m1_m2_temp(k) < 15) 
        sigy_temp(k) = sigy_dist(1)+alpha; sigx_temp(k) = sigx_dist(1)+alpha;
    elseif (15 <= distance_m1_m2_temp(k)) && (distance_m1_m2_temp(k) < 25)
        sigy_temp(k) = sigy_dist(2)+alpha; sigx_temp(k) = sigx_dist(2)+alpha; 
    elseif (25 <= distance_m1_m2_temp(k)) && (distance_m1_m2_temp(k) < 35)
        sigy_temp(k) = sigy_dist(3)+alpha; sigx_temp(k) = sigx_dist(3)+alpha; 
    elseif (35 <= distance_m1_m2_temp(k)) && (distance_m1_m2_temp(k) < 45)
        sigy_temp(k) = sigy_dist(4)+alpha; sigx_temp(k) = sigx_dist(4)+alpha; 
    elseif (45 <= distance_m1_m2_temp(k)) && (distance_m1_m2_temp(k) < 55)
        sigy_temp(k) = sigy_dist(5)+alpha; sigx_temp(k) = sigx_dist(5)+alpha; 
    elseif (55 <= distance_m1_m2_temp(k)) && (distance_m1_m2_temp(k) < 65)
        sigy_temp(k) = sigy_dist(6)+alpha; sigx_temp(k) = sigx_dist(6)+alpha; 
    elseif (65 <= distance_m1_m2_temp(k)) && (distance_m1_m2_temp(k) < 75)
        sigy_temp(k) = sigy_dist(7)+alpha; sigx_temp(k) = sigx_dist(7)+alpha; 
    elseif (75 <= distance_m1_m2_temp(k)) && (distance_m1_m2_temp(k) < 85)
        sigy_temp(k) = sigy_dist(8)+alpha; sigx_temp(k) = sigx_dist(8)+alpha;     
    elseif (85 <= distance_m1_m2_temp(k)) && (distance_m1_m2_temp(k) < 95)
        sigy_temp(k) = sigy_dist(9)+alpha; sigx_temp(k) = sigx_dist(9)+alpha;     
    end             

    a_temp(k) = ((cos(theta_temp(k)*pi/180).^2) / (2*sigx_temp(k).^2)) + ((sin(theta_temp(k)*pi/180).^2) / (2*sigy_temp(k).^2)); %
    b_temp(k) = -1*((sin(2*theta_temp(k)*pi/180)) / (4*sigx_temp(k).^2)) + ((sin(2*theta_temp(k)*pi/180)) / (4*sigy_temp(k).^2)); %
    c_temp(k) = ((sin(theta_temp(k)*pi/180).^2) / (2*sigx_temp(k).^2)) + ((cos(theta_temp(k)*pi/180).^2) / (2*sigy_temp(k).^2)); %
    K(k) = 2*pi*sigy_temp(k)*sigx_temp(k); %For scale down of pixel intensity
end        

for j=1:N
    x = circle_div(index(1).r(j), index(1).v(j),4);
    y = circle_div(index(1).r(j), index(1).v(j),5);

    Probability = 0;

%%%%%%%%%%% Minutiae feature %%%%%%%%%%%

       for k=1:KK
                       
               posx_nbr_new = new_neigh_minutiae1(k,1); %
               posy_nbr_new = new_neigh_minutiae1(k,2); %

               tempx = (x-posx_nbr_new);
               tempy = (y-posy_nbr_new);
               
               a = a_temp(k);
               b = b_temp(k);
               c = c_temp(k);                           

               temp_G = a*tempx.^2 + 2*b*tempx.*tempy + c*tempy.^2;                                       

%                Gaussian_Probability = exp(-1 * temp_G)/K(k);
               Gaussian_Probability = exp(-1 * temp_G);

               Probability = Probability + Gaussian_Probability;   
       end

       local_structure(index(1).r(j), index(1).v(j)) = Probability; 
end  
