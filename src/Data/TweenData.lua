return {
    -- t : tween_time, v : start_value, g : goal_value, d : tween_duration
    linear = function(t, v, g, d)
        return ( g-v ) * ( t/d ) + v
    end,
    quad_In = function(t, v, g, d)
        t = t/d
        return ( g-v ) * math.pow(t,2) + v
    end,
    quad_Out = function(t, v, g, d)
        t = t/d
        return - ( g-v ) * ( t ) * ( t - 2 ) + v
    end,
    quad_InOut = function(t, v, g, d)
        t = t/(d/2)
        if ( t < 1 ) then return (( g-v )/2 ) * math.pow(t,2) + v end
        return (-(g-v)/2) * (( t-1 ) * ( t-3 ) - 1 ) + v
    end,
}