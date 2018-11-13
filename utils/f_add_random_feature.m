function out = f_add_random_feature(data)

N_dim = size(data,2);
N = size(data,1);

N_gen = 50000; %% number of random features
thr = 0.7; %% threhold for similarity

% rand_indx = randi([2,5], N_gen,1);

for i=1:N_gen
    indx = randperm(N, 2);
    temp_generated(i,:) = mean(data(indx,:),1);
end       

for i=1:size(temp_generated,1)
    temp_generated(i,:)=temp_generated(i,:)/sqrt(sum(temp_generated(i,:).^2));
end 

out = [data; temp_generated];


