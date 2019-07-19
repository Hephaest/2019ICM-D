function [passage, flag] = newObstacle(N, passage, flag, scount, i, L)
%
% newObstacle   Produce new obstacle. 
% 
% Obstacles are distributed randomly on the passageway. 
% Suppose obstacles could be removed or changed in a period of time.
%
% Author: Hephaest
% July 18, 2019

if mod(i, scount/10) == 0       % Obstacles will be changed. 
    cnt = find(passage == -2);  % In every scount/10 time.
    passage(cnt) = 0;
    flag = 0;
end

if flag == 0
    [x, y] = find(passage(ceil( L / 3) : end - 2, :) == 0);
    x = x + ceil(L / 3) - 1;
    [row, col] = size([x, y])
    obstacle = [x, y];
    rand_num = ceil(rand * N);          % The number of obstacles is random.
    select = randperm(row, rand_num);   % The positions of obstacles are random.
    obs = obstacle(select, :);
    [r, l] = size(obstacle(select, :));    
    for i = 1:r
            passage(obs(i, 1), obs(i, 2)) = -2;
    end
    flag = 1;
end

end
