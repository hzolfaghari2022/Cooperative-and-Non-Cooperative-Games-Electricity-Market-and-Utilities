function [greedy_policy, V] = ValueIteration

global H states state_count Pss discount_factor theta
global utility_per_cow payoff_per_cow

%% Initialization
V = zeros(size(states));

colors = hsv(3);
color_counter = 0;

%% Value Iteration
fprintf('Value Iteration: ')
sweep = 0;
Delta = theta + 1;
while(Delta > theta)
    sweep = sweep + 1;
    Delta = 0;
    
    for s = 1:state_count
        v = V(s);
        
        state = states{s};
        [A, Pssa, Rssa] = StateTransitions(state);
        
        % calculate max(Q(s,a))
        Q = Pssa .* ( Rssa + ...
            discount_factor .* repmat(V, size(A,1), 1) );
        Q = sum(Q, 2);
        V(s) = max(Q);
        
        Delta = max( Delta, abs(v - V(s)) );
    end
    
    if(sweep==1 || sweep==10 || Delta <= theta)
        color_counter = color_counter + 1;
        plot(V, 'Color', colors(color_counter,:))
        hold on
    end
    
    fprintf('.')
end
fprintf('Done\n')

fprintf('Final Sweep: %d\n', sweep)


hold off
xlabel 'States'
ylabel 'State Values'
legend 'Sweep 1' 'Sweep 10' 'Final'


% find the greedy policy according to V(s)
greedy_policy = cell(size(states));
for s = 1:state_count
    state = states{s};
    [A, Pssa, Rssa] = StateTransitions(state);
    
    % calculate argmax(Q(s,a))
    Q = Pssa .* ( Rssa + ...
        discount_factor .* repmat(V, size(A,1), 1) );
    Q = sum(Q, 2);
    [~, index] = max(Q);
    
    greedy_policy{s} = A{index};
end

end