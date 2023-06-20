% 可能用到的辅助函数，将输入的num按照其最小最大值归约到-1~1
function [norm] = normalization(num, min, max)
    norm = ((num - min) / (max - min) - 0.5) * 2;
end