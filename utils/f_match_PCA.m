function score_match = f_match_PCA(structure_T, structure_R, mode)

N = length(structure_T.MBLS_PCA);
NN = length(structure_R.MBLS_PCA);

score = 99*ones(N,NN);

for i=1:N         
    for j=1:NN
        if(abs(structure_T.MBLS_PCA(i).central_direction-structure_R.MBLS_PCA(j).central_direction) < 90)       
            if mode==0
                if(~isempty(structure_T.MBLS_PCA(i).LS) && ~isempty(structure_R.MBLS_PCA(j).LS))
                    score(i,j) = f_euclidean_distance(structure_T.MBLS_PCA(i).LS, structure_R.MBLS_PCA(j).LS);
                end            
            elseif mode==1
                if(~isempty(structure_T.Combined_PCA(i).LS) && ~isempty(structure_R.Combined_PCA(j).LS))
                    score(i,j) = f_euclidean_distance(structure_T.Combined_PCA(i).LS, structure_R.Combined_PCA(j).LS);        
                end
            end
        end
    end   
end

score_match = score;