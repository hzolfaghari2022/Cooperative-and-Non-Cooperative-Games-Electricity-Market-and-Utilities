function Pss = FindStateTransitionProbabilities

global H states state_count
global TransitionProbs OffspringProbs

% state transition probabilities
Pss = zeros(state_count, state_count);

for s = 1:state_count
    from_state = states{s};
    
    
    % transition
    for i = 1:3 % i: from cow type
        p_which_cow_type = 1/3;
        
        total_from = from_state(i);
        for n_transition = 0:total_from % number of cows to convert
            p_transition = factorial(total_from)/ ...
                ( factorial(n_transition)*factorial(total_from - n_transition) ) * ...
                TransitionProbs(i, i)^n_transition * ...
                (1-TransitionProbs(i, i))^(total_from - n_transition);
            
            % j: to cow type
            if(i==1)
                j = 2;
            elseif(i==2)
                j = 3;
            else
                j = 2;
            end
            
            % perform transition
            state1 = from_state;
            state1(i) = state1(i) - n_transition;
            state1(j) = state1(j) + n_transition;
            
            
            % offspring
            herd_size = sum(state1);
            breeding_count = state1(2);
            for n_offspring = 0:2
                p_offspring = OffspringProbs(n_offspring+1);
                
                % produce offspring (we suppose each cow produces
                % n_offspring childs)
                to_state = state1;
                to_state(1) = to_state(1) + ...
                    min(n_offspring * breeding_count, H - herd_size);
            
                
                % add the probability
                from_index = s;
                to_index = FindStateIndex(to_state);
                Pss(from_index, to_index) = Pss(from_index, to_index) + ...
                    (p_which_cow_type * p_transition * p_offspring);
                
            end
            
        end
    end
    
end

end