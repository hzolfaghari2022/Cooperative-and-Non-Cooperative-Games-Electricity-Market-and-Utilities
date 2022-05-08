function ActionValues = Sarsa

global H states state_count Pss discount_factor learning_rate theta
global utility_per_cow payoff_per_cow
global Q epsilon

epsilon = 0.1;

run_count = 100;
episode_length = 100;

AR = zeros(run_count, episode_length);
initializeAgent();
for run=1:run_count
    s = randi(state_count);
    [action, a] = chooseAction(s);
    for t=1:episode_length
        state = states{s};
        [r, s_prime] = performAction(state, action);
        [action_prime, a_prime] = chooseAction(s_prime);
        Q{s}(a) = Q{s}(a) + ...
            learning_rate * ( r + discount_factor * Q{s_prime}(a_prime) ...
            - Q{s}(a) );
        s = s_prime; action = action_prime; a = a_prime;

        if(t==1)
            AR(run, t) = r;
        else
            AR(run, t) = ( AR(run, t-1)*(t-1) + r ) / t;
        end
        
        if(mod(t,100)==0)
            fprintf('.')
        end
    end
    fprintf('\n')        
end
y = AR(:, episode_length);
plot(y)
xlabel('Learning Episodes')
ylabel('Average Reward')

ActionValues = Q;

end

function initializeAgent( )

global H states state_count Pss discount_factor theta
global utility_per_cow payoff_per_cow
global Q

Q = cell(state_count, 1);
for s = 1:state_count
    state = states{s};
    [ ~, possible_action_count ] = PossibleActions( state );
    Q{s} = zeros(1, possible_action_count);
end

end

function [action, a] = chooseAction(s)
% a: index of action in PossibleActions(states{s})

global states
global Q epsilon

state = states{s};
[ A, possible_action_count ] = PossibleActions( state );
if(rand < epsilon)
    a = randi(possible_action_count);
else
    [~, a] = max(Q{s});
end
action = A{a};

end

function [r, s_prime] = performAction(state, action)

global H TransitionProbs OffspringProbs
global utility_per_cow payoff_per_cow

after_state = state - action;

% select which cow type to transition
i = randi(3);
cow_count = after_state(i);

n_transition = randi(cow_count+1) - 1;

% j: to cow type
if(i==1)
    j = 2;
elseif(i==2)
    j = 3;
else
    j = 2;
end

state1 = after_state;
if(rand < 1-TransitionProbs(i, i))
    % perform transition
    state1(i) = state1(i) - n_transition;
    state1(j) = state1(j) + n_transition;
end

% offspring
herd_size = sum(state1);
breeding_count = state1(2);

idx = RouletteWheel(OffspringProbs');
n_offspring = idx - 1;

% produce offspring
to_state = state1;
to_state(1) = to_state(1) + ...
    min(n_offspring * breeding_count, H - herd_size);

s_prime = FindStateIndex(to_state);

payoff = sum(action .* payoff_per_cow);
utility = sum(after_state .* utility_per_cow);
r = payoff + utility;

end
