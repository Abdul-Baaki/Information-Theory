% Blahut Algorithm for a Binary Symetric channel e1=e2=0.5

p0 = 0.6; % prior probability of input symbol 0
p1 = 0.4; % prior probability of input symbol 1
e1 = 0.5; % channel error probability
e2 =0.5;
max_iter = 1000; % maximum number of iterations

 %Capacity function that takes in inputs,...
 % probabilies of error, channel error, and number maximum number of iterations
[Capacity, p] = blahut_arimoto_bsc(p0, p1, e1,e2, max_iter); 

function [Capacity, p] = blahut_arimoto_bsc(p0, p1, e1,e2, max_iter)

% Initialization
N = length(p0);
p = ones(1,N)/N;

for i=1:max_iter
    % Update channel output distribution
    q = [1-e1 e1; e2 1-e2]; 
    r = [p0.*q(:,1) p1.*q(:,2)]; 
    s = sum(r,2);
    t = r./s;


    % Update input distribution
    p_new = zeros(1,N);
    for j=1:N
        p_new(j) = prod((q(:,1).^t(j,1)).*(q(:,2).^t(j,2)))^(1/N);
    end
    % Check for convergence and normalizing the probabilties...
    %to obtain a new distribution
    if norm(p_new-p)<1e-6 
        p = p_new;
        break;
    end
    p = p_new; Optimal %probability distribution
end

% Compute capacity
Capacity= sum(p0.*log2(p0./(p*q(:,1))) + p1.*log2(p1./(p*q(:,2))))


end
