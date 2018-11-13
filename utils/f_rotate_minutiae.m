function new_neigh_minutiae = f_rotate_minutiae(center_minutiae, neigh_minutiae)

N = size(neigh_minutiae,1);

posx_ref_minutia = center_minutiae(1,1);
posy_ref_minutia = center_minutiae(1,2);
rot_angle = center_minutiae(1,3);
rot_rad = rot_angle*pi/180;

for i=1:N
    posx_nbr_minutiae_old = neigh_minutiae(i,1);
    posy_nbr_minutiae_old = neigh_minutiae(i,2);
    
    tempx = (posx_nbr_minutiae_old - posx_ref_minutia);
    tempy = (posy_ref_minutia - posy_nbr_minutiae_old);
%     distance_m1_m2 = sqrt(tempx^2+tempy^2);
    
    new_neigh_minutiae(i,1) = (cos(-1 * rot_rad) * tempx) - (sin(-1 * rot_rad) * tempy);
    new_neigh_minutiae(i,2) = (sin(-1 * rot_rad) * tempx) + (cos(-1 * rot_rad) * tempy);
    new_neigh_minutiae(i,3) = neigh_minutiae(i,3)-rot_angle;
end