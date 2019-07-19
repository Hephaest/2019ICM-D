% main.m
%
% This main script is used to simulate the situation of the emergency 
% evacuation on each entrance.
%   
% Author: Hephaest
% July 18, 2019

clear; clc
sCount = 1000;      % The maximal iterations of simulation.
N = 10;             % The maximum of obstacles.
E = 6;              % The entrance width.
vMax = -3;          % Max upward running speed.
L = 60;             % The entrance length.
flag = 0;           % Check whether obstacle exists or not.
pop = 1000;         % The total number of visitors in the current floor. 

[passage, v, time] = createPassage(E,L);

g = showPassage(passage, NaN, 0.01);  % The graphic.

tCost = [];          % Total time of evacuation.
count = 0;           % The current number of people.
eCount = 1;          % The current number of people who is in the passage.
oCount = 0;          % The total number of people who have successfully evacuated.
mu = pop / 2;        % The mu value of normal distribution.

while eCount > 0
    % Produce new obstacle.
    [passage, flag] = newObstacle(N, passage, flag, sCount, count, L);
    
    % Produce new people.
    [passage, v] = newPeople(count, mu, pop, passage, v, vMax);
    
    % Update people behavior.
    [passage, v, time] = switchPos(passage, v, E, L, time); 
    [passage, v, time] = movement(passage, v, time, vmax, L);

    % Boundary condition.
    [passage, v, time, nOut, tout] = clearBoundary(passage, v, time);
    oCount = oCount + nOut;
    
    % Passage plot.
    g = showPassage(passage, g, 0);
    
    % Some people start moving.
    [row, col] = find(v == 0);
    for k = 1: length(row)
        i = row(k); j = col(k);
        v(i, j) = ceil(rand * vmax);
    end
    
    % Visitor calculation.
    tcost = [tcost; tout];
    count = length(find(passage(:,:) == 1));
    count = count + oCount;
    eCount = length(find(passage(:,:) == 1));
    
end

g = showPassage(passage, g, 0.01);
% Display the mean cost time.
xlabel(['mean cost time = ', num2str(mean(tcost))])
