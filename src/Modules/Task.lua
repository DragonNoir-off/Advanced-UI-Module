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
            table.remove(active_task, i)
        end -- if status is "running" -> do nothing
    end
end

local function create_coroutine(func)
    return coroutine.create(function() func() end)
end

function module.spawn(func)
    coroutine.resume(create_coroutine(func))
end

function module.defer(func)
    module.delay(0,func)
end

function module.delay(delay, func)
    local task = {
        delay = delay,
        func = func
    }
    table.insert(active_task, task)
end

return module