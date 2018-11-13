function out = f_euclidean_distance_cluster(LS, cluster)

N_cluster = size(cluster,1);

temp_LS = repmat(LS, [N_cluster 1]);

out = sqrt(sum((temp_LS-cluster).^2,2));