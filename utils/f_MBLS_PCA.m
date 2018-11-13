function out = f_MBLS_PCA(structure_MBLS, mapping_MBLS, index_MBLS)

if(length(structure_MBLS) ~= 1)
    temp_MBLS = structure_MBLS(index_MBLS);
    num_T = sqrt(sum(temp_MBLS.^2));
    temp_MBLS = temp_MBLS/num_T;
    temp_MBLS  = (temp_MBLS'-mapping_MBLS.mean)*mapping_MBLS.M;        

    temp_MBLS = temp_MBLS/sqrt(sum(temp_MBLS.^2));
    
    out = temp_MBLS;
else
    out=[];
end

