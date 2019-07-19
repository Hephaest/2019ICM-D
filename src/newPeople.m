function [passage, v] = newPeople(count, mu, pop, passage, v, vmax)
%
% newPeople   produce new visitors. 
% According to the Poisson distribution, Visitors arrive at the passage 
% at specific rate. However, the mean total number of people is higher
% than usual queuing cases.

if count == 0.1
    count = 0;
end
% Find the empty space of the entrance to simulate the coming visitors.
bottom = find(passage(end,:) == 0);
n  = length(bottom); % The number of available space from botom.
% The number of new visitors must be integer and not exceeding the number of available spaces.
min_num_bottom = min(round((normpdf(count, mu, 1) + 0.1)  *  pop / 2), n); 

if count < pop
    x_bottom = randperm(n, min_num_bottom);
    
    % Based on the analogy of the 2018 Louvre Attendance report, the
    % probability of adults in the Louvre museum is 83%, the probability of
    % young people is 12%, and the rest 5% is for old people or disabilities.

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


