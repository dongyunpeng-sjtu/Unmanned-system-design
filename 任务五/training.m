% 执行该脚本来开始训练
% TODO：根据自己的设计对相应参数进行修改，如：最大训练轮数等
% 定义一次训练的最大轮数
maxepisodes = 1000;
% 每轮训练支持的最大回合
maxsteps = ceil(Tf/Ts);
% 当agent在m个连续情节中获得的平均累积奖励大于n时，停止训练
m = 20;
n = 5000;
% 当训练中某一回合的reward值大于x时，保存该回合的agent
x = 2500;

% 训练参数设置
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes, ...
    'MaxStepsPerEpisode',maxsteps, ...
    'ScoreAveragingWindowLength',m, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',n,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue',x);

% 是否训练的flag
doTraining = true;

if doTraining
    % 训练agent，训练结束后将结果保存在save.mat文件中
    trainingStats = train(agent,env,trainOpts);
    save('save.mat');
else
    % 加载agent
    load('save.mat');
end