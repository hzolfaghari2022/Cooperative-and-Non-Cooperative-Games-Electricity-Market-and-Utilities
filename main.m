clc
clear
close all
warning off all

global H states state_count Pss discount_factor learning_rate theta
global utility_per_cow payoff_per_cow
global TransitionProbs OffspringProbs

%% constants

TransitionProbs = ...
    [0.9, 0.1, 0; ...
    0, 0.75, 0.25; ...
    0, 0.15, 0.85];
OffspringProbs = [0.05, 0.8, 0.15];

utility_per_cow = [0.3 0.4 0.2];
payoff_per_cow = [2 6 4];

discount_factor = 0.9;
learning_rate = 0.1;
theta = 0.01;  % policy evaluation threshold

H = 12; % maximum herd size

%% build states
states = cell(1, 0);
state_count = 0;
for i = 0:H
    for j = 0:H
        for k = 0:H
            if(i+j+k <= H)
                state_count = state_count + 1;
                states{state_count} = [i j k];
            end
        end
    end
end
Pss = FindStateTransitionProbabilities;

save Pss.mat H states state_count Pss

% main

load Pss.mat

% 1-a, 1-c-i
[greedy_policy, V] = PolicyIteration;
% 1-b
[greedy_policy, V] = ValueIteration;
% 2
Q = Sarsa;


%% 1-c
colors = hsv(3);
% explore the effect of discount factor
discount_factor = 0.9;
fprintf('discount factor: %f\n', discount_factor)
[greedy_policy, V] = PolicyIteration;
figure(2)
plot(V, 'Color', colors(1,:))
hold on
discount_factor = 0.5;
fprintf('discount factor: %f\n', discount_factor)
[greedy_policy, V] = PolicyIteration;
figure(3)
plot(V, 'Color', colors(2,:))
hold on
discount_factor = 0.3;
fprintf('discount factor: %f\n', discount_factor)
[greedy_policy, V] = PolicyIteration;
figure(4)
plot(V, 'Color', colors(3,:))
hold off
xlabel 'States'
ylabel 'State Values'
legend '\gamma=0.9' '\gamma=0.5' '\gamma=0.3'


% 1-c-ii
sample_states = {[4 7 1] [1 3 6] [9 2 1]};
for i = 1:3
    state = sample_states{i};
    s = FindStateIndex(state);
    action = greedy_policy{s};
    fprintf('State: '); disp(state);
    fprintf('Action: '); disp(action);
    fprintf('\n');
end


