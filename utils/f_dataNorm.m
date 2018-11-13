function [output] = f_dataNorm(input)
%     [w h] = size(input); 
    sd = std2(input);
    output = double(input - mean2(input)); 
    output = output/sd; 
end