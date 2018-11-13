function out = f_collect(LS, mode)

N=length(LS.MBLS_PCA);

cnt=1;

for i=1:N
    if(mode==0)
        if(~isempty(LS.MBLS_PCA(i).LS))
            out.total(cnt,:) = LS.MBLS_PCA(i).LS;
            cnt=cnt+1;
        end
    elseif (mode==1)
        if(~isempty(LS.Combined_PCA(i).LS))
            out.total(cnt,:) = LS.Combined_PCA(i).LS;
            cnt=cnt+1;
        end
    elseif (mode==2)
        if(~isempty(LS.TBLS_PCA(i).LS))
            out.total(cnt,:) = LS.TBLS_PCA(i).LS;
            cnt=cnt+1;
        end
    end
end