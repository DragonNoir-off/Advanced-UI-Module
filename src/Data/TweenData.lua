return {
    -- t : tween_time, v : start_value, g : goal_value, d : tween_duration
    linear = function(t, v, g, d)
        return (g-v)*t/d + v
    end,
}