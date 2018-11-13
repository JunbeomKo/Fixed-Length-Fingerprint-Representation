function [bit_T, out_score_T] = f_match_comb_bit_single_collect(structure_T, Center, global_mean)

N_Center = size(Center,1);

threshold=6.5;

num_include = 1;

[bit_T out_score_T] = f_conversion_bit(structure_T.total, Center, threshold, num_include);
% [bit_T, out_score_T] = f_conversion_bit2(structure_T.total, Center, threshold, num_include, global_mean);
