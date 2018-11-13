clear; clc; close all;
addpath('./utils');

%% Localstructure path
LS_path = 'Local Structure\FVC2002\Db2_a\Raw';
LS_list = dir(fullfile(LS_path, '*.mat'));
N_LS = length(LS_list);

%% PCA path
PCA_path = 'PCA_data/PCA100_10down_rad8040.mat';
% PCA_path = 'PCA_data/PCA50_FVCB_10down_rad8040.mat';
load(PCA_path);

%% Save path
savePath = 'Local Structure\FVC2002\Db2_a\PCA100';
% savePath = 'Local Structure\FVCB\PCA4';

%% Index pre-computation

load('index.mat');

MBLS_index = MBLS_index.MBLS_index;

N_TBLS_index = length(TBLS_index);
N_MBLS_index = length(MBLS_index);

%%

weight = 0.6; % weight of feature-level fusion

for i=1:N_LS
    fprintf('Current file -- %s\n', LS_list(i).name);
    name = [LS_path '\' LS_list(i).name];      
    load(name);   
    
    out_LS.MBLS_PCA = f_PCA_projection(out_structure.MBLS, PCA.MBLS_mapping, MBLS_index,0); % MBLS PCA projection
    out_LS.TBLS_PCA = f_PCA_projection(out_structure.TBLS, PCA.TBLS_mapping, TBLS_index,1); % TBLS PCA projection
    out_LS.Combined_PCA = f_PCA_combination(out_LS, weight);
    
    name = [savePath '\' LS_list(i).name(1:end-4)];
    save(name, 'out_LS');     
end