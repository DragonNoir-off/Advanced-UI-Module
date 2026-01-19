local module = {}

local active_task = {}

function module.UpdateTask(delta_time)
    for i,task in pairs(active_task) do
        local status = coroutine.status(task.func)
        if status == "suspended" then
            task.delay = task.delay - delta_time
            if task.delay <= 0 then
                print("resume")
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
        delay = 0,
        func = create_coroutine(func),
        callback = callback
    }
    table.insert(active_task, task)
    coroutine.resume(task.func)
end

function module.defer(func, callback)
    module.delay(0,func, callback)
end

function module.delay(delay, func, callback)
    local task = {
        delay = delay,
        func = create_coroutine(func),
        callback = callback
    }
    table.insert(active_task, task)
end

return module