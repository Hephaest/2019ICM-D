function [passage, v, time, nOut, tout] = clearBoundary(passage, v, time)
%
% clear_entrance  remove the people of the exit space.
%

[L, W] = size(passage);
ind = find(passage == 1);
[row, col] = ind2sub([L,W], ind);

% Find out the running speeds of people.
% Clear the position and accumulation.

k = find((v(ind) + row <= 0) | (row < ceil( L / 4) & (col == 1 | col == W)));

nOut = length(k);       % Count the people who successfully exits.
tout = time(ind(k));    % Count the time that people successfully exits.
passage(ind(k)) = 0;   % Clear the color.
v(ind(k)) = 0;             % Remove velocity.