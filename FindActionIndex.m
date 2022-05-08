function index = FindActionIndex(action)

global action_count
index = binary_search(action, 1, action_count); 

end

function R = binary_search(key, imin, imax)
global actions

% test if array is empty
if (imax < imin)
    % set is empty, so return value showing not found
    R = 0;
else
    
    % calculate midpoint to cut set in half
    imid = round((imin+imax)/2);
    
    % three-way comparison
    switch compare_actions(actions{imid}, key)
        case 1
            R = binary_search(key, imin, imid-1);
        case -1
            R = binary_search(key, imid+1, imax);
        otherwise
            R = imid;
    end
end

end

% a1>a2 => 1
% a1=a2 => 0
% a1<a2 => -1
function c = compare_actions(a1, a2)

c = 0;
if(a1(1) == a2(1))
    
    if(a1(2) == a2(2))
        
        if(a1(3) == a2(3))
            c = 0;
        elseif(a1(3) > a2(3))
            c = 1;
        else
            c = -1;
        end
        
    elseif(a1(2) > a2(2))
        c = 1;
    else
        c = -1;
    end
    
elseif(a1(1) > a2(1))
    c = 1;
else
    c = -1;
end

end


