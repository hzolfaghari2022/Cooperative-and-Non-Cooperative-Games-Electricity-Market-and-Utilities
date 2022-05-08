function [greedy_policy, V] = PolicyIteration

global H states state_count Pss discount_factor learning_rate theta
global utility_per_cow payoff_per_cow

%% Initialization
V = zeros(size(states));

% create an arbitrary greedy policy
greedy_policy = cell(size(states));
for s = 1:state_count
    state = states{s};
    nYoung = state(1);
    nBreeding = state(2);
    nOld = state(3);
    greedy_policy{s} = [randi(nYoung+1)-1 ...
        randi(nBreeding+1)-1 ...
        randi(nOld+1)-1];
end

colors = hsv(3);
color_counter = 0;

iteration = 0;
sweep = 0;
while(true)
    iteration = iteration + 1;
    fprintf('Iteration %d\n', iteration)
    
    %% Policy Evaluation
    fprintf('Evaluation: ')
    Delta = theta + 1;
    while(Delta > theta)
        sweep = sweep + 1;
        Delta = 0;
        for s = 1:state_count
            v = V(s);
            
            action = greedy_policy{s};
            payoff = sum(action .* payoff_per_cow);
            after_state = states{s} - action;
            utility = sum(after_state .* utility_per_cow);
            R = payoff + utility; % Reward R(s,a,s') (constant for s,a constant)
            
            % calculate Bellman equation for updating V(s)
            sa = FindStateIndex(after_state);
            V(s) = sum( Pss(sa, :) .* (R + discount_factor .* V) );
            
            Delta = max( Delta, abs(v - V(s)) );
        end
        
        if(sweep==1 || sweep==10)
            color_counter = color_counter + 1;
            plot(V, 'Color', colors(color_counter,:))
            hold on
        end
        
        fprintf('.')
    end
    fprintf('Done\n')

    
    %% Policy Improvement
    fprintf('Improvement: ')
    policy_stable = true;
    for s = 1:state_count
        b = greedy_policy{s};
        
        state = states{s};
        [A, Pssa, Rssa] = StateTransitions(state);
        
        % calculate argmax(Q(s,a))
        Q = Pssa .* ( Rssa + ...
            discount_factor .* repmat(V, size(A,1), 1) );
        Q = sum(Q, 2);
        [~, index] = max(Q);
        
        % improve policy
        greedy_policy{s} = A{index};
        
        if(b ~= greedy_policy{s})
            policy_stable = false;
        end
        
    end
    fprintf('Done\n')
    
    if(policy_stable)
        break % policy iteration
    end
end
fprintf('Final Sweep: %d\n', sweep)

% plot the final V
color_counter = color_counter + 1;
plot(V, 'Color', colors(color_counter,:))
hold off

xlabel 'States'
ylabel 'State Values'
legend 'Sweep 1' 'Sweep 10' 'Final'

end