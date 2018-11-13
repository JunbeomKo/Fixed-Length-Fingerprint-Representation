function out = f_PCA_projection(structure, mapping, index, mode)

N = length(structure);

if mode==0
    for i=1:N
        out(i).LS = f_MBLS_PCA(structure(i).local_structure, mapping, index);
        out(i).central_direction = structure(i).central_direction;
    end
else
    for i=1:N
        out(i).LS = f_TBLS_PCA(structure(i).local_structure, mapping, index);
        out(i).central_direction = structure(i).central_direction;
    end
end