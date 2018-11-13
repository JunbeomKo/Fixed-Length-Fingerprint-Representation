clear; clc; close all;
addpath('./utils');

%% LS data
LS_path = 'Local Structure\FVC2002\Db2_a\PCA100';
LS_list = dir(fullfile(LS_path, '*.mat'));
N_LS = length(LS_list);
%% Cluster load
load('Center/FVC2002DB2_C4500_PCA100_8040_3f.mat');

%% Save result
save_path = 'Result\result_FVC2002DB2_4500_1selec_case2.mat';

%% Mode
mode=1; %0: minutiae only, 1: combined

%% Matching
N_sample = 8; %Total samples per a finger
N_train = 3; %Training samples per a finger
N_sub = 100; %Total number of fingers

N_select = 1; %Number of selected cluster for each minutia

%% Fingerprint bit-conversion
cnt = 1;
N_Cluster = size(out_Cluster.Cluster,1);
total_bit = [];

for i=1:N_LS
    
    name = [LS_path '\' LS_list(i).name];    
    load(name);        
    
    fprintf('Current -- %s\t\n', LS_list(i).name);       
    
    structure = out_LS;

    [bit, out_score, min_analysis] = f_conversion_bit_case2(structure, out_Cluster, N_select, mode);  
    
    total_bit(i).name = LS_list(i).name;
    total_bit(i).bit = bit;
    total_bit(i).out_score = out_score;
    total_bit(i).min_analysis = min_analysis;
end

%% Genuine
count = 1;
hist_count_gen=[];

for i=1:N_sub   
    for k=1+N_train:N_sample
        index_T = (i-1)*N_sample+k;
        for index_R=index_T+1:N_LS

                subject_R = split(LS_list(index_R).name, '_');
                subject_T = split(LS_list(index_T).name, '_');

                if(strcmp(string(subject_R(1)), string(subject_T(1))))

                    fprintf('Genuine current -- %s\t%s\n', LS_list(index_T).name, LS_list(index_R).name);       

                    [final_ge(count), analysis]= f_match_bit_total_one(total_bit(index_T).bit,total_bit(index_R).bit);          

                    hist_count_gen(count).T=LS_list(index_T).name;
                    hist_count_gen(count).sum_T=sum(total_bit(index_T).bit);
                    hist_count_gen(count).R=LS_list(index_R).name;
                    hist_count_gen(count).sum_R=sum(total_bit(index_R).bit);
                    hist_count_gen(count).final_ge=final_ge(count);            
                    hist_count_gen(count).analysis = analysis;                         

                    count = count+1;
                end
%             end
        end
    end
end


%% Impostor
count = 1;
hist_count_im = [];

for i=1:N_sub       
    for k=1+N_train:N_sample
        index_T = (i-1)*N_sample+k;
        if(str2num(LS_list(index_T).name(end-4)) == N_train+1) && (LS_list(index_T).name(end-3)=='.')            
            for index_R=index_T+1:N_LS

                    if(str2num(LS_list(index_R).name(end-4)) == N_train+1) && (LS_list(index_R).name(end-3)=='.')

                        fprintf('Impostor current -- %s\t%s\n', LS_list(index_T).name, LS_list(index_R).name);

                        [final_im(count), analysis]= f_match_bit_total_one(total_bit(index_T).bit,total_bit(index_R).bit);          

                        hist_count_im(count).T=LS_list(index_T).name;
                        hist_count_im(count).sum_T=sum(total_bit(index_T).bit);
                        hist_count_im(count).R=LS_list(index_R).name;
                        hist_count_im(count).sum_R=sum(total_bit(index_R).bit);
                        hist_count_im(count).final_im=final_im(count);                
                        hist_count_im(count).analysis = analysis;   

                        count = count+1;               

                    end
%                 end
            end    
        end
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