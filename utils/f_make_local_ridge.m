function [local_ridge_structure]= f_make_local_ridge(local_img, index, circle_div)

[m_size n_size] = size(circle_div(:,:,1));
local_ridge_structure = -ones(m_size,n_size);

% local_img = double(local_img);
% local_img = local_img/255;
% local_img = f_dataNorm(local_img);

local_ridge_structure(index) = local_img; 
