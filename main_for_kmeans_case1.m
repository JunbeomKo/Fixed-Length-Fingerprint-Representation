clear; close all; clc;

addpath('./utils');

%% Training Data 
mode = 1; %0: only minutiae, 1: combined

N_PCA = 50; % PCA dimension
if(mode==1)
    N_PCA = N_PCA*2;
end

N_Cluster = 15000; %Number of clusters

%% Save_path
save_path = 'Center/FVC2002DB2_C15000_PCA50_8040_case1.mat';

%% LS data
path(1).LS_path = 'Local Structure\FVC2002\Db1_a\PCA50';
path(1).N_sub = 100; % Number of subject
path(1).N_sample = 8; % Number of samples per a finger
path(1).N_train = 8; % Number of samples used for training per a finger

path(2).LS_path = ;
path(2).N_sub = ; % Number of subject
path(2).N_sample = ; % Number of samples per finger
path(2).N_train = ; % Number of samples per finger

%% Clustering
total_data = [];

for i=1:length(path)
    temp_data = f_collect_path(path(i), N_PCA, mode);    
    total_data = [total_data; temp_data];
end

[cidx, Cluster]= kmeans(total_data, N_Cluster, 'emptyaction', 'singleton', 'Maxiter', 1000);

for i=1:size(Cluster,1)
    Cluster(i,:)=Cluster(i,:)/sqrt(sum(Cluster(i,:).^2));
end           

Cluster_size = f_comp_clustersize(total_data, Cluster, cidx);

out_Cluster.Cluster = Cluster;
out_Cluster.cidx = cidx;
out_Cluster.Cluster_size = Cluster_size;

save(save_path, 'out_Cluster');  