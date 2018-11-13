function out = f_PCA_combination(LS, weight)

N=length(LS.MBLS_PCA);

for i=1:N
    if(~isempty(LS.MBLS_PCA(i).LS) && ~isempty(LS.TBLS_PCA(i).LS))
        temp_MBLS = LS.MBLS_PCA(i).LS;
        temp_TBLS = LS.TBLS_PCA(i).LS;
        
        temp_MBLS = f_dataNorm(temp_MBLS);
        temp_TBLS = f_dataNorm(temp_TBLS);
               
        temp_comb(1,:)=[temp_MBLS'*weight; temp_TBLS'*(1-weight)];       
        temp_comb = temp_comb/sqrt(sum(temp_comb.^2));
        out(i).LS = temp_comb;
    else
        out(i).LS = [];
    end    
end