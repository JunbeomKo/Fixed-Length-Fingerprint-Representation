clear; close all; clc;

addpath('./utils');

%% LS data
LS_path = 'Local Structure\FVC2002\Db2_a\PCA100';
LS_list = dir(fullfile(LS_path, '*.mat'));

N_LS = length(LS_list);

%% Save_path
save_path = 'Center/FVC2002DB2_C4500_PCA100_8040_3f.mat';

%%
mode = 1; %0: only minutiae, 1: combined

N_train = 3; % Number of training fingers
N_sub = 100; % Number of subject
N_sample = 8; % Number of samples per finger
N_PCA = 100; % PCA dimension
if(mode==1)
    N_PCA = N_PCA*2;
end

N_Cluster = 4500; %Number of clusters

%% Clustering
cnt=1;
total_data = zeros(150000, N_PCA);

for i=1:N_sub
    for j=1:N_train
        name = [LS_path '\' LS_list((i-1)*N_sample+j).name];      
        fprintf('Current file -- %s\n', name);            
        load(name);   

        out = f_collect(out_LS, mode);

        NN = size(out.total,1);
        total_data(cnt:cnt+NN-1,:) = out.total;
        cnt = cnt+NN;
    end        
end

total_data = total_data(1:cnt-1,:);
total_data = total_data(~isnan(total_data(:,1)),:);

[cidx, Cluster]= kmeans(total_data, N_Cluster, 'emptyaction', 'singleton', 'maxiter', 1000);

for i=1:size(Cluster,1)
    Cluster(i,:)=Cluster(i,:)/sqrt(sum(Cluster(i,:).^2));
end           

Cluster_size = f_comp_clustersize(total_data, Cluster, cidx);

out_Cluster.Cluster = Cluster;
out_Cluster.cidx = cidx;
out_Cluster.Cluster_size = Cluster_size;

save(save_path, 'out_Cluster');  