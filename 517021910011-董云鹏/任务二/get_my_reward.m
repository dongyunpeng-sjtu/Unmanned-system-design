function [reward] = get_my_reward(obs, pre_obs)
    % TODO：计算reward
    % 根据传入的本轮observations以及上一轮的observations计算reward
    % 注：第一回合中obs = pre_obs
    if pre_obs(6) - obs(6) > 5
        reward = 70;
    else
        reward = -0.2 + (- 10 * abs(obs(4)) + 100 * abs(pre_obs(5)) - 100 * abs(obs(5)));
        % reward = 20 + (- 20 * abs(obs(4)) - 20 * abs(obs(5)));
    end
end