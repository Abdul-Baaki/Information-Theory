% Blahut-Arimoto Algorithm for Binary Symmetric Channel
% Inputs: p0 = prior probability of input symbol 0
%         p1 = prior probability of input symbol 1
%         e = channel error probability
%         max_iter = maximum number of iterations
% Output: c = capacity of the channel
%         p = optimal input probability distribution

function [c, p] = blahut_arimoto_bsc(p0, p1, e, max_iter)

% Initialization
N = length(p0);
p = ones(1,N)/N;
for i=1:max_iter
    % Update channel output distribution
    q = [1-e e; e 1-e];
    r = [p0.*q(:,1) p1.*q(:,2)];
    s = sum(r,2);
    t = r./s;
    % Update input distribution
    p_new = zeros(1,N);
    for j=1:N
        p_new(j) = prod((q(:,1).^t(j,1)).*(q(:,2).^t(j,2)))^(1/N);
    end
    % Check for convergence
    if norm(p_new-p)<1e-6
        p = p_new;
        break;
    end
    p = p_new;
end

% Compute capacity
c = sum(p0.*log2(p0./(p*q(:,1))) + p1.*log2(p1./(p*q(:,2))))

end
