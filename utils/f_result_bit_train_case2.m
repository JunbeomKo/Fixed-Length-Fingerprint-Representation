function bit_T = f_result_bit_train_case1(total_bit, discrim_score, num_min, N_train, num_conv)

thr_rel = 0.45; %threhold for reliability
thr_rel_min = 1/N_train; %minimum threhold for reliability

thr_score = 0.05; %threhold for discriminative

thr_score_pass = 0.4; %threshold when only small number of bit-positions are selected

bit_T = zeros(1,length(total_bit));

N = size(discrim_score,1);

if (N==0)
    error('0 bit allocation');
end
% cnt=1;
for i=1:N
    if(discrim_score(i,1)>thr_score)
        idx = discrim_score(i,2);
        if(total_bit(idx)>=f_make_threhold(thr_rel, mean(num_min),i/num_conv))  
            bit_T(idx)=1;
        end
    else
        break;
    end    
end

if(sum(bit_T) < 10)
    for i=1:N
        if(discrim_score(i,1)>thr_score_pass)
            idx = discrim_score(i,2);
            if(total_bit(idx)>=thr_rel_min)  
                bit_T(idx)=1;
            end
        else
            break;
        end    
    end
end