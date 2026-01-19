local module = {}

function module.min_max(value, min, max)
    if value >= max then return max
    elseif value < min then return min
    else return value end
end

function module.digit(number, digit, floor_or_ceil)
    local counter = 0
    while number > ( 10 * math.pow(10,digit)) do
        number = number / 10
        counter = counter + 1
    end
    if floor_or_ceil == nil or floor_or_ceil == true then
        number = math.floor(number)
    else
        number = math.ceil(number)
    end
    return ( number )
end

return module