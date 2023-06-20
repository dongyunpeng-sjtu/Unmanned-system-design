function [reward] = get_my_reward(obs, pre_obs)
    target_position = [-1600; 0; 0];  % 目标位置
    target_heading = atan2(target_position(2) - obs(2), target_position(1) - obs(1));  % 目标朝向角度

    position = obs(1:3);
    orientation = obs(4:6);
    velocity = obs(7:9);
    health = obs(10);

    % 计算距离奖励
    distance_reward = -norm(position - target_position);

    % 计算朝向奖励
    current_heading = atan2(velocity(2), velocity(1));  % 当前朝向角度
    heading_error = wrapToPi(target_heading - current_heading);
    heading_reward = cos(heading_error);

    % 计算姿态奖励
    pitch_reward = cos(orientation(2));
    yaw_reward = cos(orientation(3));

    % 计算总奖励
    reward = distance_reward + 0.5 * heading_reward + 0.2 * pitch_reward + 0.2 * yaw_reward;

    % 如果战机失去血量，则给予较大的惩罚
    if health <= 0
        reward = reward - 100;
    end
    
    % 引入时间惩罚
    time_penalty = -0.01;  % 时间惩罚因子
    reward = reward + time_penalty;

    % 调整目标朝向角度
    distance_to_target = norm(position - target_position);
    if distance_to_target < 500  % 当距离目标较近时
        target_heading = current_heading;  % 将目标朝向角度设为当前朝向角度
    end

    % 增加探索因子
    exploration_factor = 0.2;  % 探索因子
    reward = reward + exploration_factor * randn();
    
    % 控制俯仰角，使飞机朝向目标位置
    target_pitch = atan2(target_position(3) - position(3), distance_to_target);
    pitch_error = wrapToPi(target_pitch - orientation(2));
    pitch_reward = cos(pitch_error);
    reward = reward + 0.2 * pitch_reward;

end



