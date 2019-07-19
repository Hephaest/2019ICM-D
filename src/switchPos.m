function [passage, v, time] = switchPos(passage, v, E, L, time)
%
% switchPos  Human respondence simulations.
%  
% The visitors will try to avoid the obstacles. Visitors randomly chooses 
% right or left direction. If that intended direction is blocked, visitor
% will stop running for seconds to find another way if both directions 
% are unavailable. 
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
        
        % First corner.
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
        % Move left or right.
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
% move visitor from (i,j) to (i+di,j+dj).
passage(i+di,j+dj) =         1;          passage(i,j) = 0;
v(i+di,j+dj)       =    v(i,j);          v(i,j)       = 0;
time(i+di,j+dj)    = time(i,j);          time(i,j)    = 0;
