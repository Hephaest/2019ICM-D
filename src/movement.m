function [passage, v, time] = movement(passage, v, time, vMax, L)
% 
% move_forward   people move forward governed by NS algorithm:
%
% 1. Acceleration. If the people have a chance to speed up without hitting 
% the limit speed vMax, vn = vn + 1. However, this condition is not
% suitable for the people whose velocity is 0 or near the entries.
%
% 2. Collision prevention. If the distance between the people and the people 
% ahead of him, dn is less than or equal to vn , then vn = dn - 1.
%
% 3. Conditional slowing. peoples run slow to avoid obstacles. 
% With some probability pbrake , vn = vn - 1. 
%
% 4. People movement. The peoples are usually moved by their velocities.
%

% Probability of acceleration.
probac = 0.6;
% Probability of deceleration.
pbrake = 0.1;

f = find(passage == 1 & v ~= 0);
    
% Random acceleration.
k = find(rand(size(f))<probac);
select = find(mod(f(k),ceil(4/L))~=0 & mod(f(k),ceil(4/L)+1)~=0 ...
         & mod(f(k),ceil(4/L)+2)~=0 & mod(f(k),ceil(4/L)+3)~=0);
v(k(select)) = max(v(k(select))-1, vMax);

% Collision prevention.
gap = getgap(passage, vMax); 
k = find(-v(f)>gap(f));
v(f(k)) = -gap(f(k));

% Random deceleration.
k = find( rand(size(f))<pbrake );
select = find(mod(f(k),ceil(4/L))~=0 & mod(f(k),ceil(4/L)+1)~=0 ...
         & mod(f(k),ceil(4/L)+2)~=0 & mod(f(k),ceil(4/L)+3)~=0);
v(k(select)) = min(v(k(select))+1, 0);

% People movement.
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
