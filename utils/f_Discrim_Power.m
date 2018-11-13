function result_score = f_Discrim_Power(temp_score, global_mean, Global_discrim)

N_t=size(temp_score,1);
N_d=size(temp_score,2);

inter_var = zeros(1,N_d);

for i=1:N_d
    sum=0;
    
    for j=1:N_t
        if ((temp_score(j,i)-global_mean(i)) < 0)
            sum = sum+(temp_score(j,i)-global_mean(i))^2;           
        end
    end
    sum=sum/N_t;

    inter_var(1,i) = sum;
end

inter_var(isnan(inter_var)) = 0;

result_score(:,1) = inter_var.*Global_discrim;
result_score(:,2) = 1:N_d;

result_score = sortrows(result_score, -1);


