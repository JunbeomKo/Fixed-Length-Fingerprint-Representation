function cluster_size = f_comp_clustersize(total_data, Cluster, cidx)

N_Center = size(Cluster,1);

N_c = 300;

for i=1:N_Center
    
    fprintf('Current cluster: %d\n', i);
    
    indx = find(cidx~=i);        
        
    score = sqrt(sum((repmat(Cluster(i,:),[length(indx),1])-total_data(indx,:)).^2,2));
    score = sort(score);    
    
    cluster_size(i,1) = mean(score(1:N_c));    
end