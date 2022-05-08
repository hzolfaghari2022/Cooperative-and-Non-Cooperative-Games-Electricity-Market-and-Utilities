function [ A, Pssa, Rssa ] = StateTransitions( state )
% Returns possible actions in state and transition probabilities and 
% rewards for each possible action

global H states state_count Pss discount_factor theta
global utility_per_cow payoff_per_cow

young_count = state(1);
breeding_count = state(2);
old_count = state(3);
possible_action_count = (young_count+1)*(breeding_count+1)*(old_count+1);
A = cell(possible_action_count, 1); % possible actions for current state
% Pssa contains probabilities of following states (s') for every possible action
Pssa = zeros(possible_action_count, state_count);
% Rssa: Rewards for every possible action (independent of s')
Rssa = zeros(possible_action_count, 1);
counter = 0;
for a1 = 0:young_count
    for a2 = 0:breeding_count
        for a3 = 0:old_count
            action = [a1 a2 a3];
            counter = counter + 1;
            A{counter} = action;
            after_state = state - action;
            sa = FindStateIndex(after_state);
            Pssa(counter, :) = Pss(sa, :);
            
            payoff = sum(action .* payoff_per_cow);
            utility = sum(after_state .* utility_per_cow);
            Rssa(counter) = payoff + utility;
        end
    end
end

% Copy Rssa for each s'
Rssa = repmat(Rssa, 1, state_count);

end

