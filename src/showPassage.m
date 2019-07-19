function h = showPassage(passage, h, n)
%
% showPassage  To show the passage matrix as an image.
%
% Author: Hephaest
% July 18, 2019

% mark:      visitor;       empty;        wall;     obstacle;
mark  = [          1;           0;          -1;          -2];
color = [0.0 0.0 1.0; 1.0 1.0 1.0; 0.5 0.5 0.5; 1.0 0.0 0.0];

rgb = mark2color(passage, mark, color);

if ishandle(h)
    set(h,'CData',rgb)
else
    figure('position',[20, 50, 200, 700]);
    h = imagesc(rgb); 
    hold on; axis image; set(gca, 'xtick', [], 'ytick', []);
    % Draw the grid.
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
