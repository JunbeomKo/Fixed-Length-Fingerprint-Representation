clear; clc; close all;
addpath('./utils');

%% Minutia information path '*.txt'
min_path = 'Database\FVC2002\Db2_a';

min_list = dir(fullfile(min_path, '*.txt'));
N=length(min_list);
%% Fingerprint image path
img_path = 'Database\FVC2002\Db2_a';

img_list = dir(fullfile(img_path, '*.tif'));
%% MBLS, TBLS savePath
savePath = 'Local Structure\FVC2002\Db2_a\Raw';

%% Radius for MBLS and TBLS
MBLS_Rad = 80;
TBLS_Rad = 40;

%% Minimum number of neighbor minutiae to construct local structure
Num_neigh = 1;

%% 
circle_div_TBLS = f_re_make_circle(TBLS_Rad*2+1,1); 
[TBLS_index] = find(circle_div_TBLS(:,:,1) ~= -1);

%% Downscale local structure for lower computation
circle_div_MBLS = f_re_make_circle(MBLS_Rad*2+1,10); 
[MBLS_index(1).r, MBLS_index(1).v] = find(circle_div_MBLS(:,:,1) ~= -1);
[MBLS_index.MBLS_index] = find(circle_div_MBLS(:,:,1) ~= -1);

save('index.mat', 'TBLS_index', 'MBLS_index')

%% Local structure construction
for i=1:N    

    CO_R = f_orientation_bifurcation_veri(f_extract_min_COORD([min_path '\' min_list(i).name])); %Read Minutiae information from textfile    
    [CO_R, distance] = f_select_minutiae(CO_R); % Eliminate minutia detection error and pre-computation of Euclidean distance
    
    img = imread([img_path '\' img_list(i).name]);    

    fprintf('%d - current image : %s\n', i, img_list(i).name);
    tic
    out_structure.MBLS = f_MBLS(CO_R, MBLS_Rad, Num_neigh, circle_div_MBLS, MBLS_index, distance); % MBLS construction   
    toc;
    
    tic
    out_structure.TBLS = f_TBLS(CO_R, TBLS_Rad, img, circle_div_TBLS, TBLS_index); %TBLS construction
    toc;    

    name = [savePath '\' img_list(i).name(1:end-4)];
    save(name, 'out_structure'); 
end