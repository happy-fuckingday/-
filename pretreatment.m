%% 计算直接抽出玉蝶和不同品质的皮肤概率
clear;clc;
filename = 'PreTreament.xls';
T = readmatrix(filename);
T(isnan(T)) = 0;

Yudie = T(:,2:8);
Skin = T(:,9:11);% 传说和限定概率已公布，仅关注伴生、勇者和史诗

% global YudiePro SkinPro
YudiePro = sum(Yudie,1)/sum(Yudie,'all');
SkinPro = sum(Skin,1)/sum(Skin,'all');

save('Probably.mat',"SkinPro","YudiePro");

