function [ A, possible_action_count ] = PossibleActions( state )

young_count = state(1);
breeding_count = state(2);
old_count = state(3);
possible_action_count = (young_count+1)*(breeding_count+1)*(old_count+1);
A = cell(possible_action_count, 1); % possible actions for current state
counter = 0;
for a1 = 0:young_count
    for a2 = 0:breeding_count
        for a3 = 0:old_count
            action = [a1 a2 a3];
            counter = counter + 1;
            A{counter} = action;
        end
    end
end

end

