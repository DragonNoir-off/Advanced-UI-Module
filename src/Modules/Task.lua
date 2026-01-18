local module = {}

local active_task = {}

function module.UpdateTask(delta_time)
    for i,task in pairs(active_task) do
        local status = coroutine.status(task.func)
        if status == "suspended" then
            task.timer = task.timer - delta_time
            if task.timer <= 0 then
                coroutine.resume(task.func)
            end
        elseif status == "dead" then
            if type(task.callback) == "function" then
                task.callback()
            end
            table.remove(active_task, i)
            v = nil -- rasier for the garbadge collector
        end -- if status is "running" -> do nothing
    end
end

local function create_coroutine(func)
    return coroutine.create(function() func() end)
end

function module.spawn(func, callback)
    local task = {
        func = create_coroutine(func),
        callback = callback
    }
    table.insert(active_task, #active_task+1, task)
    coroutine.resume(active_task[#active_task].func)
end

function module.defer(func, callback)
    module.delay(0,func, callback)
end

function module.delay(delay, func, callback)
    local task = {
        delay = delay,
        func = func,
        callback = callback
    }
    table.insert(active_task, task)
end

return module