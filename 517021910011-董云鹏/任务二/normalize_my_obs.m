function [norm_obs] = normalize_my_obs(obs)
    % TODO：对优化后的observations进行归一化处理
    norm_obs = [0, 0, 0, 0, 0];
    norm_obs(1) = normalization(obs(1), -10000, 10000);
    norm_obs(2) = normalization(obs(2), -10000, 10000);
    norm_obs(3) = normalization(obs(3), -10000, 10000);
    norm_obs(4) = normalization(obs(4), -2 / 3 * pi, 2 / 3 * pi);
    obs(5) = mod(obs(5), 2 * pi);
    norm_obs(5) = normalization(obs(5), 0, 2 * pi);
end