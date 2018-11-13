function [bit, out_score, min_analysis] = f_conversion_bit_case1(IN_structure, Cluster, N_select, mode)

threshold = -0.05; % case1

num_include=N_select;

if(mode==0)
    structure=IN_structure.MBLS_PCA;
else
    structure=IN_structure.Combined_PCA;
end

N = length(structure);
N_Cluster = size(Cluster.Cluster,1);

bit = zeros(1,N_Cluster);

for i=1:N
    cnt=0;
    if(~isempty(structure(i).LS))        
        distance = f_euclidean_distance_cluster(structure(i).LS, Cluster.Cluster);
        score = distance-Cluster.Cluster_size;
        out_score = distance';

        for k=1:num_include        
            indx = find(score == min(score));
            if(length(indx==1))
                if(min(score)<threshold)
                    bit(indx(1))=1;
                    min_analysis(i,(k-1)*2+1) = indx(1);
                    min_analysis(i,(k-1)*2+2) = min(score);                
                    cnt=cnt+1;
                else
                    if(cnt==0)
                        min_analysis(i,(k-1)*2+1) = 0;
                        min_analysis(i,(k-1)*2+2) = 99;
                    end
                    break;
                end        
            end    
            score(indx) = 99;
        end    
    end
end