function [score_match, analysis] = f_match_bit_total_one(bit_T1, bit_R1)

sum_T = sum(bit_T1);
sum_R = sum(bit_R1);
sum_bit = sum(bit_T1.*bit_R1);

analysis=find(bit_T1.*bit_R1==1);

score_match = ((sum_T+sum_R)*sum_bit)/(sum_T^2 + sum_R^2);
