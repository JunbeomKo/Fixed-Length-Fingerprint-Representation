function EER = f_calculate_EER(Genuine_score, Impostor_score, mode)

cnt=0; FAR=[]; FRR=[];

max_score = max(max(Genuine_score), max(Impostor_score));

if(mode==0)
    Genuine_score = max_score - Genuine_score;
    Impostor_score = max_score - Impostor_score;
end

max_score = max(max(Genuine_score), max(Impostor_score));
min_score = min(min(Genuine_score), min(Impostor_score));

for j=min_score:0.001:max_score
    cnt=cnt+1;
    buff_FAR = []; buff_FRR = [];
    buff_FAR = find(Impostor_score >= j);
    FAR(cnt,1) = size(buff_FAR)/size(Impostor_score);
    
    buff_FRR = find(Genuine_score < j);
    FRR(cnt,1) = size(buff_FRR)/size(Genuine_score);    
end

indx=[];
for j=1:size(FAR)
    if(FRR(j)>=FAR(j))
        indx = j;
        break;    
    end
end

EER = (FRR(j)+FAR(j))/2*100;  