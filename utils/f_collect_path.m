function out_data = f_collect_path(path, N_PCA, mode)

LS_list = dir(fullfile(path.LS_path, '*.mat'));

total_data = zeros(150000, N_PCA);
cnt=1;
for i=1:path.N_sub
    for j=1:path.N_train
        name = [path.LS_path '\' LS_list((i-1)*path.N_sample+j).name];      
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
out_data = total_data;