local module = {}

function module.min_max(value, min, max)
    if value >= max then return max
    elseif value < min then return min
    else return value end
end

return module