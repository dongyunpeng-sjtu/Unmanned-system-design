function [norm_obs] = normalize_my_obs(obs)
    % TODO：对优化后的observations进行归一化处理
    norm_obs = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    norm_obs(1) = normalization(obs(1), -10000, 10000);
    norm_obs(2) = normalization(obs(2), -10000, 10000);
    norm_obs(3) = normalization(obs(3), -10000, 10000);

    norm_obs(4) = normalization(obs(4), -5 / 6 * pi, 5 / 6 * pi);
    obs(5) = mod(obs(5), 2 * pi);
    norm_obs(5) = normalization(obs(5), 0, 2 * pi);

    norm_obs(6) = normalization(obs(6), -5 / 6 * pi, 5 / 6 * pi);
    obs(7) = mod(obs(7), 2 * pi);
    norm_obs(7) = normalization(obs(7), 0, 2 * pi);
    
    norm_obs(8) = normalization(obs(8), 0, 1000);
    norm_obs(9) = normalization(obs(9), 0, 1000);
end