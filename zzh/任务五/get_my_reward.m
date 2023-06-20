function [reward] = get_my_reward(obs, pre_obs)
    % TODO：计算reward
    % 根据传入的本轮observations以及上一轮的observations计算reward
    % 注：第一回合中obs = pre_obs
    reward = -0.2;

    % 血量奖励和惩罚
    if pre_obs(9) - obs(9) > 5
        reward = reward + 70;
    end
    if pre_obs(8) - obs(8) > 5
        reward = reward - 40;
    end

    distance = sqrt(obs(1) ^ 2 + obs(2) ^ 2 + obs(3) ^ 2);
    pre_distance = sqrt(pre_obs(1) ^ 2 + pre_obs(2) ^ 2 + pre_obs(3) ^ 2);

    distance_reward = pre_distance - distance;
     angle_reward = - 10 * abs(obs(4)) + 100 * abs(pre_obs(5)) - 100 * abs(obs(5));
     angle_penalty = - 5 * abs(obs(6)) + 50 * abs(pre_obs(7)) - 50 * abs(obs(7));

    normalReward = distance_reward + angle_reward + angle_penalty;

    reward = reward + normalReward;
end