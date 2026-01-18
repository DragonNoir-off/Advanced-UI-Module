local module = {}

function module.min_max(value, min, max)
    if value >= max then return max
    elseif value < min then return min
    else return value end
end

function module.map(value, min, max, new_min, new_max)
    return 0
end

return module