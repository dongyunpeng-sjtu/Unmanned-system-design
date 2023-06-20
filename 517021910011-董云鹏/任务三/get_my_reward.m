function [reward] = get_my_reward(obs, pre_obs)
    % TODO：计算reward
    % 根据传入的本轮observations以及上一轮的observations计算reward
    % 注：第一回合中obs = pre_obs

    % %先计算两个飞机之间的相对距离
    dis = sqrt(obs(1) * obs(1) + obs(2) * obs(2) + obs(3) * obs(3));
    pre_dis = sqrt(pre_obs(1) * pre_obs(1) + pre_obs(2) * pre_obs(2) + pre_obs(3) * pre_obs(3));
    if pre_obs(6) - obs(6) > 5
        reward = 500;  
    else
        % reward = -0.2 + (- 10 * abs(obs(4)) + 100 * abs(pre_obs(5)) - 100 * abs(obs(5)));
        % % % reward = 20 + (- 20 * abs(obs(4)) - 20 * abs(obs(5)));
        % if dis > 800
        %     % disp("> 800");
        %     reward = -0.2 + (100 * abs(pre_obs(5)) - 100 * abs(obs(5))) + ((pre_dis - dis) * 50);
        % else 
        %     reward = -0.2 + (100 * abs(pre_obs(5)) - 100 * abs(obs(5))) + (pre_obs(7) - obs(7)) * 50 + (pre_obs(6) - obs(6)) * 100 - (pre_obs(7) - obs(7)) * 50;
        % end   

        reward = -0.2 + (100 * abs(pre_obs(5)) - 100 * abs(obs(5))) - (pre_obs(7) - obs(7)) * 50 + (pre_obs(6) - obs(6)) * 100;
        
        % reward = -0.2 + (100 * abs(pre_obs(5)) - 100 * abs(obs(5))) + (pre_obs(1) - obs(1)) * 50 - abs(obs(2)) * 30- abs(obs(3)) * 30;
    end
end