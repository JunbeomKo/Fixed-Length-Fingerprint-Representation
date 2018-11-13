function [final_score, np_result] = f_LGS(input_score, N1, N2)

max_np = 10;
min_np = 4;
mu_p = 35;
t_p = 2/5;


np = min_np+round((max_np-min_np)/(1+exp(-t_p*(min(N1,N2)-mu_p))));

np_temp(1) = np;
np_temp(2) = min(N1,N2);

final_score = sum(input_score(1:np,1))/np;
np_result = input_score(1:np,1);
