% 可能用到的辅助函数，用来处理可能当作分母的变量，避免除零的现象
function [result] = not_zero(num)
    if(abs(num) < 0.0000001)
        if(num > 0)
            num = 0.0000001;
        elseif(num < 0)
            num = -0.0000001;
        end
    end
    result = num;
end