function out = f_random_feature(data)

data_min = min(data, [], 1);
data_max = max(data, [], 1);
data_std = std(data, [], 1);
data_mean = mean(data,1);

N = size(data,2);

N_gen = 50000; %% number of random features

for i=1:N
    temp = data_std(i).*randn(1, N_gen)+data_mean(i);
    rand_gen(:,i) = data_min(i)+(data_max(i)-data_min(i)).*temp*3;
end

for i=1:N_gen
    rand_gen(i,:)=rand_gen(i,:)/sqrt(sum(rand_gen(i,:).^2));
end       

out = rand_gen;
