clear; clc; close all;
addpath('./utils');

%% LS data
LS_path = 'Local Structure\FVC2002\Db2_a\PCA100';
LS_list = dir(fullfile(LS_path, '*.mat'));
N_LS = length(LS_list);
%% Cluster load
load('Center/FVC2002DB2_C4500_PCA100_8040_3f.mat');

%% Bit-training load
load('Bit_training/FVC2002DB2_C4500_PCA100_8040_3f.mat');

%% Save result
save_path = 'Result\result_FVC2002DB2_4500_1selec_case2_bittraining.mat';

%% Mode
mode=1; %0: minutiae only, 1: combined

%% Database inform
N_sample = 8; %total samples per finger
N_train = 3; %training samples per finger
N_sub = 100; %Number of subject

%% Bit-conversion parameter
N_select = 1; %Number of selected cluster for each minutia

%% Fingerprint bit-conversion
cnt = 1;
N_Cluster = size(out_Cluster.Cluster,1);
total_bit = [];

for i=1:N_LS
    
    name = [LS_path '\' LS_list(i).name];    
    load(name);        
    
    fprintf('Current bit_conversion -- %s\t\n', LS_list(i).name);       
    
    structure = out_LS;

    [bit, out_score, min_analysis] = f_conversion_bit_case2(structure, out_Cluster, N_select, mode);  
    
    total_bit(i).name = LS_list(i).name;
    total_bit(i).bit = bit;
    total_bit(i).out_score = out_score;
    total_bit(i).min_analysis = min_analysis;
end

%% Bit-training

for i=1:N_sub
    train_bit = [];
    train_score = [];
    for j=1:N_train
        index = (i-1)*N_sample+j;       
        fprintf('Current bit_training -- %s\t\n', total_bit(index).name);
        train_bit = [train_bit; total_bit(index).bit];
        train_score = [train_score; min(total_bit(index).out_score, [], 1)];
        num_minutiae(j) = sum(total_bit(index).bit);
    end
    
    train_bit = mean(train_bit,1);
    
    Discrim_score = f_Discrim_Power(train_score, Global_mean, Cardinality_Cluster);
    
    Selected_bit_R(i,:) = f_result_bit_train_case2(train_bit, Discrim_score, num_minutiae, N_train);
    
    fprintf('\n');
end

%% Genuine
count = 1;
hist_count_gen=[];

for i=1:N_sub       
    for j=N_train+1:N_sample
        
        index_T = (i-1)*N_sample+j;
        subject_T = split(LS_list(index_T).name, '_');
        fprintf('Genuine current -- Subject: %d, Test: %s\n', i, LS_list(index_T).name);       

        [final_ge(count) analysis]= f_match_bit_total_one(Selected_bit_R(i,:), total_bit(index_T).bit);          

        hist_count_gen(count).T=LS_list(index_T).name;
        hist_count_gen(count).R=i;
        hist_count_gen(count).R_sum=sum(Selected_bit_R(i,:));
        hist_count_gen(count).final_ge=final_ge(count);            
        hist_count_gen(count).analysis = analysis;                         

        count = count+1;     

    end
end


%% Impostor
count = 1;
hist_count_im = [];

for i=1:N_sub       
    for j=i+1:N_sub
        index_T = (j-1)*N_sample+1;        
            
        fprintf('Impostor current -- Subject: %d, Test: %s\n', i, LS_list(index_T).name);       

        [final_im(count) analysis]= f_match_bit_total_one(Selected_bit_R(i,:), total_bit(index_T).bit);          

        hist_count_im(count).T=LS_list(index_T).name;
        hist_count_im(count).R=i;
        hist_count_im(count).R_sum=sum(Selected_bit_R(i,:));
        hist_count_im(count).final_im=final_im(count);                
        hist_count_im(count).analysis = analysis;   

        count = count+1;         
    end    
end

%% EER
 
Impostor_score = final_im;
Genuine_score = final_ge;

Genuine_score = sort(Genuine_score, 'descend');
Impostor_score = sort(Impostor_score, 'descend');

EER = f_calculate_EER(Genuine_score, Impostor_score, 1);
fprintf('EER: %f \n', EER);

save(save_path, 'Genuine_score', 'Impostor_score', 'hist_count_gen', 'hist_count_im');