local module = {}
module.__index = module

-- [[ MODULES ]]
local Tween_Data = require("src.Data.TweenData")
local Format = require("src.Modules.Format")

local tween_table = {}

function module.create(data)
    if data == nil then data = {} end
    local self = setmetatable({}, module)

    local function return_default(data, default)
        if data == nil then return default else return data end
    end

    assert(type(data.start_data) == "number", "Start data must be provide to ensure tween use ( value :"..data.start_data..")")
    assert(type(data.end_data) == "number", "End data must be provide to ensure tween use ( value : "..data.end_data..")")
    assert(type(data.duration) == "number", "Provide duration must be a number ( value : "..data.duration..")")
    assert(type(data.update_function) == "function", "The function update need to be a functio ( type : "..type(data.update_function)..")")

    -- [[ OPTIONAL VALUE ]]
    self.ownership = return_default(data.ownership, "")
    self.overwrite = return_default(data.overwrite, false)
    self.style = return_default(data.tween_style, "linear")
    self.delete_after_complet = return_default(data.clear_after_complet, true)

    self.repeat_amount = return_default(data.repeat_amount, 1) -- -1 for infinite
    self.reverse = return_default(data.reverse, false)
    
    self.delay = return_default(data.delay, 0)
    self.reverse_delay = return_default(data.reverse_delay, 0)

    -- [[ REQUIRE VALUE ]]
    self.start_data = data.start_data
    self.end_data = data.end_data
    self.update_function = data.update_function
    self.duration = data.duration

    -- [[ OTHER VALUE ]]
    self.tween_status = "pause"
    self.previous_tween_status = "inactive"
    self.reverse_status = false
    self.timer = 0
    self.repeated_amount = 0

    -- overwrite check
    if self.overwrite == true then
        -- check if another tween already exist
        for i,v in ipairs(tween_table) do
            if v.ownership == self.ownership then table.remove(tween_table, i) end -- remove tween from table
        end
    end

    if self.reverse == true and self.repeat_amount ~= -1 then self.repeat_amount = self.repeat_amount * 2 end -- allow reverse count

    table.insert(tween_table, self)

    return self
end

-- CLASS FUNCTION

function module:update()
    local new_value
    if self.reverse_status == false then
        new_value = Tween_Data[self.style](self.timer, self.start_data, self.end_data, self.duration)
    else
        new_value = Tween_Data[self.style]( ( self.duration - self.timer ), self.start_data, self.end_data, self.duration)
    end
    if self.start_data <= self.end_data then
        new_value = Format.min_max(new_value, self.start_data, self.end_data)
    else
        new_value = Format.min_max(new_value, self.end_data, self.start_data)
    end
    
    self.update_function(new_value)
end

function module:play()
    if self.tween_status == "pause" then
        self.tween_status = self.previous_tween_status
        self.previous_tween_status = "pause"
    end
end

function module:pause()
    self.previous_tween_status = self.tween_status
    self.tween_status = "pause"
end

function module:cancel(position)
    local function destroy(position)
        table.remove(tween_table, position) -- remove tween from table
        self = nil -- clear the tween instance
    end

    if type(position) == "number" then
        destroy(position)
    else
        for i,v in ipairs(tween_table) do
            if v == self then
                destroy(i)
                return -- break the loop
            end
        end
    end
end

function module:replay()
    self.timer = 0
    self.tween_status = "pause"
    self.previous_tween_status = "inactive"
    self.repeated_amount = 0
    self.reverse_status = false
    self:play()
end

function module:can_play()
    return ( self.repeated_amount < self.repeat_amount ) or ( self.repeat_amount == -1 )
end

-- MODULE FUNCTION

function module.UpdateTween(dt)
    for i,tween in ipairs(tween_table) do

        if tween.tween_status == "inactive" then
            if not tween:can_play() then
                if tween.delete_after_complet then
                    tween:cancel(i) -- destroy the tween
                else
                    tween:pause()
                end
            else
                if tween.reverse == true then tween.reverse_status = ( tween.repeated_amount % 2 ) ~= 0 end
                if ( tween.reverse_status == false and tween.timer < tween.delay ) or ( tween.reverse_status == true and tween.timer < tween.reverse_delay ) then
                    -- need to wait
                    tween.timer = tween.timer + dt
                else
                    -- will play tween
                    tween.timer = 0
                    tween.tween_status = "playing"
                    tween:update()
                end
            end
        elseif tween.tween_status == "playing" then
            if ( tween.timer < tween.duration ) then
                -- still playing
                tween.timer = tween.timer + dt
                tween:update()
            else
                -- stop the tween
                tween.tween_status = "inactive"
                tween.repeated_amount = tween.repeated_amount + 1
                tween.timer = 0
            end
        end -- if tween.tween_status == "pause" then -> do nothing
    end
end

return module