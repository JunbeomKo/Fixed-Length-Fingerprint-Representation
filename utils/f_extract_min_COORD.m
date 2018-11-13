
function COORD = f_extract_min_COORD(file)
    fp_R = fopen(file);
    name = fscanf(fp_R, '%s', 1);
    Num_Min = fscanf(fp_R, '%d', 1);
    
    for i = 1:Num_Min
        COORD(i,1) = fscanf(fp_R, '%d', 1);
        COORD(i,2) = fscanf(fp_R, '%d', 1);
        COORD(i,3) = fscanf(fp_R, '%f', 1);
    end
    fclose(fp_R);
end