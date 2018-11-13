function score_vector = f_score_cal_LS_ED(score_matrix)
[M1 M2] = size(score_matrix);
N = min(M1,M2);
score_vector = ones(N,2)*999;

for i=1:N
    temp_max = min(min(score_matrix));
    if temp_max ~= 999
        [temp_ind_r, temp_ind_c] = find(score_matrix == temp_max);
        score_vector(i,1) = temp_max;
        score_vector(i,2) = temp_ind_r(1);
        score_vector(i,3) = temp_ind_c(1);        
        
        score_matrix(temp_ind_r(1),:) = 999;
        score_matrix(:,temp_ind_c(1)) = 999;       
    end   
end