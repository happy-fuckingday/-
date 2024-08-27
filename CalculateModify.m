%% 用于计算公孙离无双皮肤抽奖期望
clear;clc;
%修改此处
numDraws = 10;% 抽了多少次
% 问题描述：998玉碟兑换皮肤
% 0.2% 无双券=499玉碟
% 0.2% 随机限定皮肤=288玉碟
% 0.5% 随机传说皮肤=120玉碟
% 13.5% 随机皮肤(伴生、勇者和史诗)=20、40和80玉碟
% 58.5% 玉碟(8-68个，统计数据获得详细分布)
% 15% 皮肤碎片=5玉碟
% 12.1% 心动夏日道具=5玉碟
% 累计抽取5、10、25，获取皮肤宝箱(以勇者品质计)
% 累计抽取40，获取玉碟288个

% 需要回答的问题：获取玉碟的数学期望；40抽以内获取皮肤的概率

load('Probably.mat')
Skin_Zhichu = [20,40,80];
Yudie_Zhichu = [8,18,28,38,48,58,68];

% 直出玉碟和皮肤的分布(数据来自Bilibili，数据样本较小，可能存在一定误差)
% 单抽期望
Temp = 0.2e-2*499 + 0.2e-2*288 + 0.5e-2*120 + 13.5e-2*sum(SkinPro.*Skin_Zhichu) + 58.5e-2*sum(Yudie_Zhichu.*YudiePro) + (15+12.1)*1e-2*5;
% 10抽获取期望
Get_10 = Temp*10 + 2*sum(SkinPro.*Skin_Zhichu);
% 20抽获取期望
Get_20 = Temp*20 + 2*sum(SkinPro.*Skin_Zhichu);
% 30抽获取期望
Get_30 = Temp*30 + 3*sum(SkinPro.*Skin_Zhichu);
% 30抽获取期望
Get_40 = Temp*40 + 2*sum(SkinPro.*Skin_Zhichu) + 288;
% 期望
Qiwang = [Get_10,Get_20,Get_30,Get_40];

% 计算10、20、30、40抽拿下的概率
% numDraws = 50;% 抽了多少次
numSimulations = 10000;% 模拟次数
Require = 998;%决定抽没抽到
% 蒙特卡洛模拟
materials = [499, 288, 120, 5];  % 每种情况获取的材料数量，除了直接出现玉碟的和低品质皮肤的
probabilities = [0.2, 0.2, 0.5, 15 + 12.1]*1e-2;  % 对应的概率
probabilities_Modify = cumsum(probabilities);% 累加
% 预分配结果数组
results = zeros(numSimulations, 1);
for sim = 1:numSimulations  
    totalMaterials = 0;
    for draw = 1:numDraws
        x = rand;y = rand;z = rand;
        if x < probabilities_Modify(end)% 非直接出现玉碟的情况
            materialsDrawn = materials(find(x <= probabilities_Modify, 1, 'first' ));
        else 
            if x < probabilities_Modify(end) + 58.5e-2% 直接出现玉碟的情况
                materialsDrawn = Yudie_Zhichu(find(y <= cumsum(YudiePro), 1, 'first' ));
            else% 直接出现低品质皮肤的情况
                materialsDrawn = Skin_Zhichu(find(z <= cumsum(SkinPro), 1, 'first' ));
            end
        end
        totalMaterials = totalMaterials + materialsDrawn;
    end
    ModifyParm = [5,10,25,40,45,50,65,80,85,90,105,120,125,130,145,160];%抽取若干次后还有保底领取的宝箱，认为都是勇者品质
    Get_YuDie_Single = [40,40,40,288,40,40,40,288,40,40,40,288,40,40,40,288];
    Get_YuDie = cumsum(Get_YuDie_Single);
    totalMaterials = totalMaterials + Get_YuDie(find(numDraws >= ModifyParm, 1, 'last'));
    % 记录是否达到或超过所需材料数量
    results(sim) = totalMaterials >= Require;
end
% 计算达到或超过所需材料数量的概率
probability = mean(results);
% Ht = find(results == 1);
% disp(~isempty(Ht));%有无抽到的特例
fprintf('抽取次数: %d\n', numDraws);
fprintf(['抽到的概率: %.3f','%%\n'], probability*100);