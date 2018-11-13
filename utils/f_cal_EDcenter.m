function out_score = f_cal_EDcenter(structure, Center)

N = size(structure,1);
N_Center = size(Center,1);

out_score = zeros(N, N_Center);

for i=1:N    
    for j=1:N_Center        
        out_score(i,j) = f_euclidean_distance(structure(i,:), Center(j,:));        
    end    
end


