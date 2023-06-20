function [obs] = get_my_obs(org_obs)
    % TODO：observations的优化处理

    % org_obs(1-13)第一架飞机的参数org_obs(14-26)第二架飞机参数
    % org_obs(1-3)x\y\z坐标 范围暂定
    % org_obs(4-6)欧拉角𝜑\𝜃\𝜓对应翻滚(roll)、俯仰(pitch)、偏航(yaw)
    % org_obs(7-9)线速度u\v\w
    % org_obs(10-12)角速度ω\β\η
    % org_obs(13)战机当前血量
    % org_obs(27)对局结束信号，1代表战斗结束，0代表战斗继续
    % 注：在最后一个回合中，org_obs为{0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,0,...
    % 0,0,0,0,0,0,0,0,-1,1}其中两个-1代表两架飞机的血量

    obs = org_obs;
end