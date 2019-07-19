function [passage, v, time] = createPassage(E,L)
%
% createPassage    Create the empty passage matrix(no people). 
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
