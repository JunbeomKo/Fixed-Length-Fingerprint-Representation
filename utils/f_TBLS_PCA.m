function out = f_TBLS_PCA(structure_TBLS, mapping_TBLS, index_TBLS)
if(length(structure_TBLS) > 1)
    temp_TBLS = structure_TBLS(index_TBLS);        
    temp_TBLS = temp_TBLS/255;
    temp_TBLS = f_dataNorm(temp_TBLS);
    temp_TBLS = (temp_TBLS'-mapping_TBLS.mean)*mapping_TBLS.M;  

    temp_TBLS = temp_TBLS/sqrt(sum(temp_TBLS.^2));
    
    out = temp_TBLS;
else
    out=[];
end
     

