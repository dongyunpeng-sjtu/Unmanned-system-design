% 执行该脚本来初始化训练环境
% 定义observation的范围
% TODO：根据自己的设计来定义observation的数量和取值范围
obsInfo = rlNumericSpec([9 1],...
    'LowerLimit',[-1 -1 -1 -1 -1 -1 -1 -1  ...
    -1]',...
    'UpperLimit',[ 1  1  1  1  1  1  1  1  ...
    1]');
obsInfo.Name = 'observations';
numObservations = obsInfo.Dimension(1);
% 定义action的范围
% TODO：根据自己的设计来定义action的数量和取值范围
actInfo = rlNumericSpec([3 1],...
    'LowerLimit',[0 -1 -1]',...
    'UpperLimit',[ 1 1 1]');
actInfo.Name = 'operation';
numActions = actInfo.Dimension(1);

% 读取路径下的slx文件中的模块来定义env
env = rlSimulinkEnv('rlflight','rlflight/Training/RL Agent',...
    obsInfo,actInfo,'UseFastRestart','off');

env.ResetFcn = @(in) (in);

% 智能体采样时间
Ts = 0.1;
% 模拟时间
Tf = 2000;

rng(0)

% 定义critic network的网络结构
cnet = [
    % 输入层
    featureInputLayer(numObservations,"Normalization","none","Name","observation")
    % 隐藏层
    fullyConnectedLayer(128,"Name","fc1")
    reluLayer("Name","relu1")
    fullyConnectedLayer(128,"Name","fc2")
    % 拼接层
    concatenationLayer(1,2,"Name","concat")
    % 激活函数层，使用ReLU激活函数
    reluLayer("Name","relu3")
    fullyConnectedLayer(256,"Name","fc5")
    reluLayer("Name","relu4")
    fullyConnectedLayer(256,"Name","fc6")
    reluLayer("Name","relu5")
    % 输出层
    fullyConnectedLayer(1,"Name","CriticOutput")];
actionPath = [
    featureInputLayer(numActions,"Normalization","none","Name","action")
    fullyConnectedLayer(128,"Name","fc3")
    reluLayer("Name","relu2")
    fullyConnectedLayer(128,"Name","fc4")];

% 连接critic network
% 创建网络
criticNetwork = layerGraph(cnet);
% 添加新的输入网络
criticNetwork = addLayers(criticNetwork, actionPath);
% 将 fc2 层与 concat 层的第二个输入（即动作输入）连接起来
% Concatenation层（简称Concat层）是一种特殊的层，用于将多个输入层的特征沿着某个维度进行拼接
criticNetwork = connectLayers(criticNetwork,"fc4","concat/in2");

plot(criticNetwork)

% 将criticNetwork转化为一个深度学习网络对象
criticdlnet = dlnetwork(criticNetwork,'Initialize',false);
% 创建了两个新的深度学习网络对象，并将它们的参数初始化为与criticdlnet相同
criticdlnet1 = initialize(criticdlnet);
criticdlnet2 = initialize(criticdlnet);

% 构建了两个Q值函数对象，这些Q值函数将用于计算Critic网络的输出，以及后续的训练过程
critic1 = rlQValueFunction(criticdlnet1,obsInfo,actInfo, ...
    "ObservationInputNames","observation");
critic2 = rlQValueFunction(criticdlnet2,obsInfo,actInfo, ...
    "ObservationInputNames","observation");
critic1.UseDevice = 'cpu';
critic2.UseDevice = 'cpu';

% 定义actor network的网络结构
% 定义特征输入层
anet = [
    featureInputLayer(numObservations,"Normalization","none","Name","observation")
    fullyConnectedLayer(256,"Name","fc1")
    reluLayer("Name","relu1")
    fullyConnectedLayer(256,"Name","fc2")
    reluLayer("Name","relu2")];
% 定义均值路径，其输出用于生成动作的均值
meanPath = [
    fullyConnectedLayer(128,"Name","meanFC")
    reluLayer("Name","relu3")
    fullyConnectedLayer(numActions,"Name","mean")];
% 定义标准差路径，其输出表示生成动作的标准差
stdPath = [
    fullyConnectedLayer(numActions,"Name","stdFC")
    reluLayer("Name","relu4")
    % 输出通过softplus激活层（softplusLayer）进行变换以确保输出是正的
    softplusLayer("Name","std")];

% 连接actor network

actorNetwork = layerGraph(anet);
actorNetwork = addLayers(actorNetwork,meanPath);
actorNetwork = addLayers(actorNetwork,stdPath);
actorNetwork = connectLayers(actorNetwork,"relu2","meanFC/in");
actorNetwork = connectLayers(actorNetwork,"relu2","stdFC/in");

% plot(actorNetwork)

% 创建一个actor network网络对象
actordlnet = dlnetwork(actorNetwork);
% 创建了一个高斯策略 actor
actor = rlContinuousGaussianActor(actordlnet, obsInfo, actInfo, ...
    "ObservationInputNames","observation", ...
    "ActionMeanOutputNames","mean", ...
    "ActionStandardDeviationOutputNames","std");
actor.UseDevice = 'cpu';

% NumWarmStartSteps是指在代理开始学习之前，它将执行多少步骤的随机动作
% 这些随机动作有助于代理对环境进行探索，并收集一些经验
% 一旦代理收集了足够的经验，它就可以开始使用学习策略进行训练
% 这个参数可以控制代理在学习之前进行多少次随机探索
% 默认情况下，NumWarmStartSteps的值为1000。
% DiscountFactor 未来奖励的折扣因子
% ExperienceBufferLength 经验回放容量
% TargetUpdateFrequency软更新步长
% TargetSmoothFactor软更新参数
agentOpts = rlSACAgentOptions( ...
    "SampleTime",Ts, ...
    "TargetSmoothFactor",0.005, ...    
    "ExperienceBufferLength",1e6, ...
    "MiniBatchSize",512, ...
    "NumWarmStartSteps",1000, ...
    "DiscountFactor",0.999,...
    "TargetUpdateFrequency",1);

% 设置熵权重
opt.EntropyWeightOptions.EntroWeight = 1;

agentOpts.ActorOptimizerOptions.Algorithm = "adam";
agentOpts.ActorOptimizerOptions.LearnRate = 1e-3;
agentOpts.ActorOptimizerOptions.GradientThreshold = 1;

for ct = 1:2
    agentOpts.CriticOptimizerOptions(ct).Algorithm = "adam";
    agentOpts.CriticOptimizerOptions(ct).LearnRate = 1e-3;
    agentOpts.CriticOptimizerOptions(ct).GradientThreshold = 1;
end

agent = rlSACAgent(actor,[critic1,critic2],agentOpts);
