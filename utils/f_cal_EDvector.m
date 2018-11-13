function out = f_cal_EDvector(path, Center, mode)

%% mode=0 Minutiae-only, mode=1 Combined

%%

total_score = [];

for i=1:path.N_subject
    temp_score = [];
    
    for j=1:path.N_train_finger
        if mode==0
            LS_list = dir(fullfile(path.LS_path, '*.mat'));
            name = [path.LS_path '\' LS_list((i-1)*path.N_sample+j).name];
            load(name);
                
            fprintf('current: %s\n', name);
            
            structure_PCA = f_collect(out_LS, mode);

            out_score = f_cal_EDcenter(structure_PCA.total, Center);

            out_score = min(out_score,[],1);
        
        else
                        
            LS_list = dir(fullfile(path.LS_path, '*.mat'));
            name = [path.LS_path '\' LS_list((i-1)*path.N_sample+j).name];
            load(name);                        
            
            fprintf('current: %s\n', name);
            
            structure_PCA = f_collect(out_LS, mode);

            out_score = f_cal_EDcenter(structure_PCA.total, Center);

            out_score = min(out_score,[],1);
        end        
        
         temp_score = [temp_score; out_score];          
    end        
    
    temp_score(isnan(temp_score))=0;
    total_score = [total_score; temp_score];    
end

out = total_score;