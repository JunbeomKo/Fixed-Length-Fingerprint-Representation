clear; clc; close all;
addpath('./utils');
%% mode
mode=1; %0: minutia-only,1: combined

%% LS path
LS_path = 'Local Structure\FVC2002\Db2_a\PCA100';
LS_list = dir(fullfile(LS_path, '*.mat'));

N_LS = length(LS_list);

%% Result
save_path = 'Result/FVC2002DB2_PCA100_10down_rad8040_w60.mat';
% save_path = 'Result/FVC2006DB2_PCA100_10down_rad80.mat';

%% genuine
count = 1;
hist_count_gen=[];

for i=1:N_LS
    
    name = [LS_path '\' LS_list(i).name];    
    load(name);          

    structure_T = out_LS;      
    
    for j=i+1:N_LS
        subject_R = split(LS_list(i).name, '_');
        subject_T = split(LS_list(j).name, '_');        

        if(strcmp(string(subject_R(1)), string(subject_T(1))))
            name = [LS_path '\' LS_list(j).name];
            load(name);                            
            
            structure_R = out_LS;           
            
            fprintf('Genuine current -- %s\t%s\n', LS_list(i).name, LS_list(j).name);       
            
            tic
            [score_match] = f_match_PCA(structure_T, structure_R, mode); %Localstructure matching 함수
            toc
            
            [finger_score, Num_score] = f_cal_fingerscore(score_match);                       
             
            [final_ge(count), np] = f_LGS(finger_score, size(structure_R,1), size(structure_T,1));           
                        
            hist_count_gen(count).i=i;
            hist_count_gen(count).j=j;
            hist_count_gen(count).final_ge=final_ge(count);
            hist_count_gen(count).N_T = length(structure_T.MBLS_PCA);
            hist_count_gen(count).N_R = length(structure_R.MBLS_PCA);
            hist_count_gen(count).np_result = np;                         
           
            count = count+1;
            
        end
    end
end

%% impostor
count = 1;
hist_count_im = [];

for i=1:N_LS    
    name = [LS_path '\' LS_list(i).name];    
    load(name);      
    structure_T = out_LS;   
    
    if(str2num(LS_list(i).name(end-4)) == 1) && (LS_list(i).name(end-3)=='.') && (LS_list(i).name(end-5)=='_')       
        
        for j=i+1:N_LS

            if(str2num(LS_list(j).name(end-4)) == 1) && (LS_list(j).name(end-3)=='.') && (LS_list(j).name(end-5)=='_')
                name = [LS_path '\' LS_list(j).name];
                load(name);                
                structure_R = out_LS;
                
                fprintf('Impostor current -- %s\t%s\n', LS_list(i).name, LS_list(j).name);
                
                tic
                [score_match] = f_match_PCA(structure_T, structure_R, mode); %Localstructure matching 함수
                toc
  
                [finger_score, Num_score] = f_cal_fingerscore(score_match);                
                  
                [final_im(count), np] = f_LGS(finger_score, size(structure_R,1), size(structure_T,1));

                hist_count_im(count).i=i;
                hist_count_im(count).j=j;
                hist_count_im(count).final_im=final_im(count);
                hist_count_im(count).N_T = length(structure_T.MBLS_PCA);
                hist_count_im(count).N_R = length(structure_R.MBLS_PCA);
                hist_count_im(count).np_result = np;   
                
                count = count+1;               
                
            end
        end    
    end
    
end

%% EER
 
Impostor_score = final_im;
Genuine_score = final_ge;

Genuine_score = sort(Genuine_score, 'descend');
Impostor_score = sort(Impostor_score, 'descend');

EER = f_calculate_EER(Genuine_score, Impostor_score, 0);
fprintf('EER: %f \n', EER);

save(save_path, 'Genuine_score', 'Impostor_score');