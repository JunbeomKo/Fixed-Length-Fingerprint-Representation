function [finger_score, Num_score] = f_cal_fingerscore(score_match)

Matched_score = f_score_cal_LS_ED(score_match); %Find best matched minutia pair  
finger_score = sortrows(Matched_score,1); %descending order 
Num_score = size(Matched_score,1);           