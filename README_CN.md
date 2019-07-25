目录
=================
   * [效果演示图](#效果演示图)
   * [自适应元胞自动机](#自适应元胞自动机)
   * [感谢](#感谢)
   * [问题回顾](#问题回顾)
      * [词汇表](#词汇表)
   * [基本猜想](#基本猜想)
   * [函数实现](#函数实现)
      * [画布绘制](#画布绘制)
      * [游客移动](#游客移动)
      * [画布刷新](#画布刷新)
   * [反方向逃离](#反方向逃离)
   
# 效果演示图
<p align="center"><img src ="images/passage.gif"></p>

# 自适应元胞自动机
[![LICENSE](https://img.shields.io/cocoapods/l/AFNetworking.svg)](https://github.com/Hephaest/2019ICM-D/blob/master/LICENSE)
[![Matlab](https://img.shields.io/badge/MATLAB-R2018b-orange.svg)](https://www.oracle.com/technetwork/java/javase/8u202-relnotes-5209339.html)
[![Dependencies](https://img.shields.io/badge/Dependencies-up%20to%20date-green.svg)](https://github.com/Hephaest/2019ICM-D/tree/master/src)

[English](README.md) | 中文

最后一次更新于 `2019/07/18`

本模型只是 2019 ICM D 问题的解决方案中的其中一步 - 一种用于监控游客逃离行为以防践踏事件的自适应的元胞自动机模型。
# 感谢
这个模型是是受中科院博士周吕文老师所写的 2005 MCM B 问题的解决方案的启发。

我的代码在他的基础上做了大改动以满足本题的要求。

可通过右边的链接查看他写的 2005 MCM B 问题的解决方案: https://github.com/MCMICM/2005MCM-B.

我的模型关注于游客之间的交互行为以及制定逃生时对突发情况的应急措施。

# 问题回顾  
(下文翻译根据谷歌翻译稍作调整)

法国越来越多的恐怖袭击事件要求审查许多热门目的地的紧急疏散计划。 您的 ICM 团队正在帮助设计法国巴黎卢浮宫的疏散计划。一般而言，疏散的目标是让所有居住者尽可能快速安全地离开建筑物。在通知所需的疏散后，安排个人出口并通过最佳出口以尽快排空建筑物。

卢浮宫是世界上规模最大，访问量最大的艺术博物馆之一，2017 年接待游客超过 810 万。博物馆内的宾客人数在一天到一年不同，这对规划博物馆内的常规活动提出了挑战。游客的多样性 - 各国游客，旅游团和残疾游客 - 使紧急情况下的疏散变得更具挑战性。

卢浮宫有五层，其中两层是地下的。
<p align="center"><img src ="images/2019_ICM_Problem_D.jpg"></p>

位于这五个楼层的 380,000 个展品占地约 72,735 平方米，建筑翼长达 480 米或 5 个街区。金字塔入口是博物馆的主要和最常用的公共入口。 然而，还有三个其他入口通常为拥有博物馆会员资格的团体和个人预留：Passage Richelieu 入口，Carrousel du Louvre 入口和 Portes Des Lions 入口。

只有*应急人员*和博物馆官员知道实际可用出口点的总数(服务门，员工入口，贵宾入口，紧急出口和君主制建造的旧秘密入口等)。虽然公众对这些出口点的认识可以为疏散计划提供额外的力量，但与四个主要入口处的安保水平相比，由于这些出口处的安全姿势较低或有限，它们的使用同时会引起安全问题。因此，在创建模型时，您的团队应该仔细考虑何时以及如何使用其他出口。

您的主管希望您的ICM团队开发紧急疏散模型，允许博物馆领导者探索一系列选项，以便从博物馆撤离访客，同时还允许应急人员尽快进入建筑物。重要的是找出可能限制出口移动的潜在*瓶颈*。博物馆应急规划人员对适应性模型特别感兴趣，该模型可用于解决广泛的考虑因素和各种类型的潜在威胁。每种威胁都有可能改变或消除可能在单一优化路线中必不可少的安全路段。一旦开发完成，验证您的模型并讨论卢浮宫如何实施它。

根据您的工作成果，提出有关卢浮宫应急管理的政策和程序建议。包括您的团队认为对访客安全所必需的任何适用的人群管理和控制程序。另外，讨论如何为其他大型拥挤结构调整和实施模型。

## 词汇表
- **瓶颈** – 人员移动急剧减慢甚至停止的地方。
- **应急人员** – 在紧急情况下提供帮助的人，如警卫，消防员，医务人员，救护人员，医生和警察。

# 基本猜想
- **队列由先进先出(FIFO)队列规则组织**。此队列规则表示处于等待队列中的第一个访客将是第一个离开入口的访客。
- **队列长度相对不变**。任何个人都遵循一般原则前进，如果访客和访客面前的人具有相同的跑步速度，则不会试图超越前面的个人。
- **每个访客都朝着一个方向奔跑**。游客从内到外跑，不再返回建筑物内部。
- **每层不同年龄分布的概率是相同的**。根据过去 4 年的 the Louvre Attendance and Frequentation 报告, 假设正常成年人的比例为 79 ％，幼儿的比例为 12 ％，而行走不便的人比例(老人，盲人，有些人视力受损，一些患有腿部残疾的人等)占 9 ％。
- 据统计，假设正常成人的步行速度为 0.75 m/s，且跑步速度不超过 3 m/s，儿童的运动速度仅为正常成人的 70 ％，且运动速度不方便人只占正常成年人的 70 ％。
- 根据统计，假设 Portes Des Lions 入口的通量为 6 人/秒，Passage Richelieu 入口的通量为 6 人/秒，Carrousel du Louvre 入口的通量为 6 人/秒，并且通量为金字塔入口是 14 人/秒。
# 函数实现
本模型只是解决方案其中一步的原因是因为模型只关注瓶颈口(普通的出口逃离通道和4个入口通道)，游客多样性和心理学上行为的交互过程但未考虑跨层和特殊通道的问题。

根据任务要求，模型应遵循以下假设：
- 在单位时间内到达每个出口(B1)的访客数量大致服从正态分布。
- 游客奔向最近的出口。如果访客的当前速度大于前方访客的速度或他或她前方的障碍物，访客将尝试向左或向右转以避免碰撞。此外，游客还可以加速(但不能超过最大速度)或减速运行速度并因某些原因停止。
- 障碍物随机出现，包括火焰，破碎的展品，游客留下的东西。但是，在一段时间内，这些障碍将被消除，但会出现新的障碍。
- 根据从众心理，当游客离开出口时，他们将走超过半数人选择的路径。

整个功能实现分为 3 个部分: `画布绘制`, `游客移动`, `画布刷新`.
## 画布绘制
画布上呈现 4 个主要的对象, 包括 `墙壁`, `通道`, `障碍物` 和 `游客`。每个对象都由对应的颜色进行表示, 它们的外观已经通过下方的代码实现了:
```MATLAB
function h = showPassage(passage, h, n)
%
% showPassage  将通道矩阵显示为图像。
%
% Author: Hephaest
% July 18, 2019

% 标记:          游客;      可走通道;        墙壁;        障碍物;
mark  = [          1;           0;          -1;          -2];
color = [0.0 0.0 1.0; 1.0 1.0 1.0; 0.5 0.5 0.5; 1.0 0.0 0.0];

rgb = mark2color(passage, mark, color);

if ishandle(h)
    set(h,'CData',rgb)
else
    figure('position',[20, 50, 200, 700]);
    h = imagesc(rgb); 
    hold on; axis image; set(gca, 'xtick', [], 'ytick', []);
    % 绘制网格。
    [L, W] = size(passage);
    plot([0:W;0:W] + 0.5, [0;L] + 0.5, 'k', [0;W] + 0.5, [0:L;0:L] + 0.5,'k')
end
pause(n)

% -------------------------------------------------------------------------

function rgb = mark2color(mat, mark, color)
[R, G, B] = deal(zeros(size(mat)));
for i = 1:length(mark)
    R(mat==mark(i)) = color(i,1);
    G(mat==mark(i)) = color(i,2);
    B(mat==mark(i)) = color(i,3);
end
rgb = cat(3, R, G, B);
```
首先，我们需要设定界限。 虽然墙壁在画布上的位置永远是固定的的，但出入口的墙壁形状是不同的。

代码如下所示:
```MATLAB
function [passage, v, time] = createPassage(E,L)
%
% createPassage    创建空的通道矩阵。 
%
% Author: Hephaest
% July 18, 2019

booth_row = ceil( L / 4);
W = E * 3;
[passage, v, time] = deal(zeros(L, W));
passage(booth_row : ceil(L * 2 / 3), :) = -1;

for row = ceil(L * 2 / 3) : L
    for col = 1 : L - row
        if col > W
            break;
        end
        passage(row, col) = -1;
    end
end

passage(ceil(L * 2 / 3) : end, 2 * E : end) = -1;

for row = ceil(L*2/3) : L
    passage(row, 2 * E : W - L + row) = 0;
end

passage(booth_row : end, E + 1 : 2 * E) = 0;
passage(booth_row, E + 1 : 2 * E) = 0;
```
其次，我们还需要创造可能在不同时间出现在各地的障碍。

代码如下所示:
```MATLAB
function [passage, flag] = newObstacle(N, passage, flag, scount, i, L)
%
% newObstacle   创造新的障碍物。 
% 
% 障碍物在通道上随机分布。 
% 假设这些障碍物会随着时间消失并在不同的地方出现。
%
% Author: Hephaest
% July 18, 2019

if mod(i, scount/10) == 0       % 障碍物也会改变位置。 
    cnt = find(passage == -2);  % 每 scount/10 时间内。
    passage(cnt) = 0;
    flag = 0;
end

if flag == 0
    [x, y] = find(passage(ceil( L / 3) : end - 2, :) == 0);
    x = x + ceil(L / 3) - 1;
    [row, col] = size([x, y])
    obstacle = [x, y];
    rand_num = ceil(rand * N);          % 随机生成的障碍物总数。
    select = randperm(row, rand_num);   % 随机生成障碍物的位置。
    obs = obstacle(select, :);
    [r, l] = size(obstacle(select, :));    
    for i = 1:r
            passage(obs(i, 1), obs(i, 2)) = -2;
    end
    flag = 1;
end

end
```
第三步，抵达人数应遵循正态分布。但是，由于最大入口的限制，如果到达人数超过最大入口数，则到达人数等于最大入口数。

代码如下所示:
```MATLAB
function [passage, v] = newPeople(count, mu, pop, passage, v, vmax)
%
% newPeople   创造新到达的游客。
%
% Author: Hephaest
% July 18, 2019

if count == 0.1
    count = 0;
end
% 找到通道的空白空间来模拟即将到来的游客。
bottom = find(passage(end,:) == 0);
n  = length(bottom); % The number of available space from botom.
% 新访问者的数量必须是整数且不超过可用空间的数量。
min_num_bottom = min(round((normpdf(count, mu, 1) + 0.1)  *  pop / 2), n); 

if count < pop
    x_bottom = randperm(n, min_num_bottom);
    
    % 根据 2018 Louvre Attendance 报告, 成年人在卢浮宫的概率是 83 %, 年轻人的概率是 12 %,
    % 剩下的 5 % 是老人和残疾人的总概率。

    proNormal = 0.83;
    proYoung = 0.12;
    proDisable = 0.05;

    rand_num = rand;

    if rand_num >= proNormal + proYoung
        v(end, bottom(x_bottom)) = vmax + 2;
    elseif rand_num >= proNormal
        v(end, bottom(x_bottom)) = vmax + 1;
    else
        v(end, bottom(x_bottom)) = vmax;
    end
    passage(end, bottom(x_bottom)) = 1;
end
```
## 游客移动
根据上述假设，访客的移动可以分解为两个动作：切换位置并向前移动。 至于切换，访问者需要检查是否有移动空间，否则停在原地等待下一次机会。 在前进方面，我们唯一无法确保的是访客的运行速度。 但是，我们可以使用数学方法来进行一些合理的假设。

因此，更改方向的代码如下所示:
```MATLAB
function [passage, v, time] = switchPos(passage, v, E, L, time)
%
% switchPos  对人类反应的模拟。
%  
% 游客会尽可能避免碰撞到障碍物。因此遇到障碍物时他们会向左或向右躲避。
% 如果游客要打算移动的方向也被其他人或墙阻挡了，游客会待在原地等待时机。
%
% Author: Hephaest
% July 18, 2019

booth_row = ceil(L/4 );
[row, col] = find(passage==1);

for k = 1 : length(row)
    i = row(k); j = col(k);
    dj = randsample([-1,1], 1);
    flag = 0;
    if v(i,j) == 0
        continue;
    end
    
    if i >= booth_row
        
        % 下方入口。
        for distance = 1 : -v(i,j)
            if passage(i - distance, j) ~=0
                if  j <= 3 * E / 2 && passage(i, j + 1) == 0 && passage(i + v(i,j), j + 1) == 0
                    [passage, v, time] = move(passage, v, time, i, j, 0, 1);
                elseif j <= 3 * E / 2 && passage(i, j - v(i,j)) == 0 && passage(i + v(i,j), j - v(i,j)) == 0
                    [passage, v, time] = move(passage, v, time, i, j, 0, - v(i,j));
                elseif j > 3 * E / 2 && passage(i, j - 1) == 0 && passage(i + v(i,j), j - 1) == 0
                    [passage, v, time] = move(passage, v, time, i, j, 0, -1);
                elseif j > 3 * E / 2 && passage(i, j + v(i,j)) == 0 && passage(i + v(i,j), j + v(i,j)) == 0
                     [passage, v, time] = move(passage, v, time, i, j, 0, v(i,j));
                else
                    v(i,j)= 0;
                end
                flag = 1;
                break;
            end
        end
        
        if flag == 0 && passage(i-1,j) ~= 0 && passage(i, j - 1) ~= 0 && passage(i, j + 1) ~= 0
            v(i,j)=0;
            continue;
        end
    else
        
        [newRow, newCol] = find(passage==1);
        % 向左或向右移动。
        leftCount = find(newCol <= 3 * E /2 & newRow <booth_row);
        rightCount = find(newCol > 3 * E /2 & newRow <booth_row);
        if i < booth_row && i > 0 && j < 3 * E && j > 0
            if length(leftCount) > length(rightCount)
                if passage(i, j - 1)==0
                    [passage, v, time] = move(passage, v, time, i, j, 0, -1);
                end
            elseif length(leftCount) < length(rightCount)
                if passage(i, j + 1)==0
                    [passage, v, time] = move(passage, v, time, i, j, 0, 1);
                end
            else
                if passage(i,j+dj)==0
                    [passage, v, time] = move(passage, v, time, i, j, 0, +dj);
                elseif passage(i,j-dj)==0 
                    [passage, v, time] = move(passage, v, time, i, j, 0, -dj);
                end
            end
        end
        
    end
    
end
%---------------------------------------------------------------------
function [passage, v, time] = move(passage, v, time, i, j, di, dj)
% 游客从 (i,j) 移动到 (i+di,j+dj)。
passage(i+di,j+dj) =         1;          passage(i,j) = 0;
v(i+di,j+dj)       =    v(i,j);          v(i,j)       = 0;
time(i+di,j+dj)    = time(i,j);          time(i,j)    = 0;
```
因此，向前移动的代码如下所示:
```MATLAB
function [passage, v, time] = movement(passage, v, time, vMax, L)
% 
% move_forward   游客向前移动由NS算法管理：
%
% 1. 加速。 如果人们有机会在没有达到极限速度 vMax 的情况下加速，则 vn = vn + 1。
% 但是，这种情况不适合速度为0的人。
%
% 2. 防止碰撞。 如果人与他前面的人之间的距离，dn 小于或等于 vn，那么 vn = dn - 1。
%
% 3. 条件减速。游客跑得很慢以避开障碍。
% 根据 pbrake 的概率, vn = vn - 1. 
%
% 4. 游客向前移动。游客通常会按照他们的惯性移动。
%
% Author: Hephaest
% July 18, 2019

% 加速的概率。
probac = 0.6;
% 减速的概率。
pbrake = 0.1;

f = find(passage == 1 & v ~= 0);
    
% 随机加速。
k = find(rand(size(f))<probac);
select = find(mod(f(k),ceil(4/L))~=0 & mod(f(k),ceil(4/L)+1)~=0 ...
         & mod(f(k),ceil(4/L)+2)~=0 & mod(f(k),ceil(4/L)+3)~=0);
v(k(select)) = max(v(k(select))-1, vMax);

% 防止碰撞。
gap = getgap(passage, vMax); 
k = find(-v(f)>gap(f));
v(f(k)) = -gap(f(k));

% 随机减速。
k = find( rand(size(f))<pbrake );
select = find(mod(f(k),ceil(4/L))~=0 & mod(f(k),ceil(4/L)+1)~=0 ...
         & mod(f(k),ceil(4/L)+2)~=0 & mod(f(k),ceil(4/L)+3)~=0);
v(k(select)) = min(v(k(select))+1, 0);

% 游客移动。
passage(f) = 0;              passage(f + v(f)) = 1;
time(f+v(f)) = time(f) + 1;  time(passage~=1) = 0;
v(f+v(f)) = v(f);            v(passage~=1)=0;

% -------------------------------------------------------------------------

function gap = getgap(passage, vMax)
gap = zeros(size(passage));
[row, col] = find(passage == 1);
for k = 1 : length(row)
    i = row(k); j = col(k);
    d = passage(1 : i - 1, j);
    gap(i, j) = min(find([d ~= 0; zeros(-vMax, 1); 1])) - 1;
end
gap(1,:) = 0;
```
## 画布刷新
最后，我们需要刷新画布，这需要我们“清除”成功逃离当前入口的访客。 此外，如果最后一个成功逃脱，那么我们需要计算平均逃离时间。

以下代码旨在“清除”通过逃离成功的游客并重置游客的属性：
```MATLAB
function [passage, v, time, nOut, tout] = clearBoundary(passage, v, time)
%
% clear_entrance  从画布移除已逃离的游客。
%
% Author: Hephaest
% July 18, 2019

[L, W] = size(passage);
ind = find(passage == 1);
[row, col] = ind2sub([L,W], ind);

% 找出游客的跑步速度。
% 清楚该游客的位置并做累加。

k = find((v(ind) + row <= 0) | (row < ceil( L / 4) & (col == 1 | col == W)));

nOut = length(k);       % 统计成功逃离的人数。
tout = time(ind(k));    % 计算逃离成功的人的总耗时。
passage(ind(k)) = 0;    % 清楚颜色表示。
v(ind(k)) = 0;          % 清楚速度。
```
然后我们可以运行主函数来刷新画布：
```MATLAB
% main.m
%
% 这个主脚本用于模拟每个出口的逃离情况。
%   
% Author: Hephaest
% July 18, 2019

clear; clc
sCount = 1000;     % 最大的模拟次数。
N = 10;            % 障碍物总数。
E = 6;             % 出口的宽度。
vMax = -3;         % 最大的跑步速度。
L = 60;            % 出口的长度。
flag = 0;          % 检查障碍物存在与否。
pop = 1000;        % 滞留在该层的总人数。

[passage, v, time] = createPassage(E,L);

g = showPassage(passage, NaN, 0.01);  % 图像。

tCost = [];        % 逃离总时间。
count = 0;         % 当前人数。
eCount = 1;        % 当前通道的总人数。
oCount = 0;        % 已逃出的总人数。
mu = pop / 2;      % 正太分布的 mu 值。

while eCount > 0
    % 生成新的障碍物。
    [passage, flag] = newObstacle(N, passage, flag, sCount, count, L);
    
    % 生成新的游客。
    [passage, v] = newPeople(count, mu, pop, passage, v, vMax);
    
    % 更新游客行为。
    [passage, v, time] = switchPos(passage, v, E, L, time); 
    [passage, v, time] = movement(passage, v, time, vmax, L);

    % 检查边界。
    [passage, v, time, nOut, tout] = clearBoundary(passage, v, time);
    oCount = oCount + nOut;
    
    % 绘制画布。
    g = showPassage(passage, g, 0);
    
    % 停止的游客打算开始继续移动。
    [row, col] = find(v == 0);
    for k = 1: length(row)
        i = row(k); j = col(k);
        v(i, j) = ceil(rand * vmax);
    end
    
    % 计算当前游客总数。
    tcost = [tcost; tout];
    count = length(find(passage(:,:) == 1));
    count = count + oCount;
    eCount = length(find(passage(:,:) == 1));
    
end

g = showPassage(passage, g, 0.01);
% 现实平均逃离耗时。
xlabel(['mean cost time = ', num2str(mean(tcost))])
```
# 反方向逃离
顺便说一句，[效果演示图](#效果演示图)仅显示单向疏散（从下到上）。 实际上，也应用了双向疏散（从上到下）。 由于相关代码与上面的代码非常相似，我只在这里展示最终结果。

<p align="center"><img src ="images/B1.png" width = "200px"></p>
