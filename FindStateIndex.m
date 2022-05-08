function index = FindStateIndex(state)

global state_count
index = binary_search(state, 1, state_count); 

end

function R = binary_search(key, imin, imax)
global states

% test if array is empty
if (imax < imin)
    % set is empty, so return value showing not found
    R = 0;
else
    
    % calculate midpoint to cut set in half
    imid = round((imin+imax)/2);
    
    % three-way comparison
    switch compare_states(states{imid}, key)
        case 1
            R = binary_search(key, imin, imid-1);
        case -1
            R = binary_search(key, imid+1, imax);
        otherwise
            R = imid;
    end
end

end

% s1>s2 => 1
% s1=s2 => 0
% s1<s2 => -1
function c = compare_states(s1, s2)

c = 0;
if(s1(1) == s2(1))
    
    if(s1(2) == s2(2))
        
        if(s1(3) == s2(3))
            c = 0;
        elseif(s1(3) > s2(3))
            c = 1;
        else
            c = -1;
        end
        
    elseif(s1(2) > s2(2))
        c = 1;
    else
        c = -1;
    end
    
elseif(s1(1) > s2(1))
    c = 1;
else
    c = -1;
end

end


