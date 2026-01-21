local module = {}
module.__index = module

-- Data
local TweenData = require("src.Data.TweenData")

local active_tween = {}

function module.new_tween(tween_data)
    local self = setmetatable({},module)

    --[[
        1 - start data      : number
        2 - goal data       : number
        3 - update function : function
        4 - function param  : table
        5 - tween duration  : number
        6 - tween style     : string 
        7 - tween reverse   : boolean
        8 - repeat amount   : number ( -1 for infinity )
        9 - delay           : number ( delay before first activation and between each repeat )
        10 - delay reverse  : number ( delay before reversing the tween direction )
        11 - ownership      : any    ( something that can allow to identificate the tween to overwrite previous tween )
        12 - overwrite      : boolean ( if true it will overwrite any previous tween according to the ownership value )
        13 - destroy        : boolean ( destroy the tween after the it finish the animation )
    ]]

    -------------------- TRY TO FIND AN ALREADY EXISTING TWEEN TO PREVENT OVERWRITE PROBLEM
    if tween_data[11] ~= nil then
        for i,v in ipairs(active_tween) do
            if v.ownership ~= nil then
                if v.ownership == tween_data[11] then
                    if tween_data[12] == true then v:destroy() else return end
                    -- if overwrite is false then stop the creation of the tween
                    -- if overwrite is true the destroy() the tween
                end
             end
        end
    end

    -------------------- CREATION OF THE SELF TWEEN
        -- main data
    self.start_value = tween_data[1]
    self.target_value = tween_data[2]
    self.update_function = tween_data[3]
    self.update_function_argument = tween_data[4] or {}

        -- sub data
    self.tween_duration = tween_data[5]
    self.tween_style = tween_data[6] or "linear"
    self.tween_reverse = tween_data[7] or false
    self.tween_repeat = tween_data[8] or 1
    self.tween_delay = tween_data[9] or 0
    self.tween_reverse_delay = tween_data[10] or 0
    self.ownership = tween_data[11] or nil
    --tween_data[12] -> overwrite
    self.destroy_after_play = tween_data[13] == true
    
        -- external data
    self.repeated_amount = 0
    self.tick = 0
    self.reverse_status = true -- get inversed on the first call to update the tween
    self.previous_tween_status = "waiting"
    self.tween_status = "waiting"
        --[[ Possible status :
            - waiting   -> wait until he get call to start playing the tween ( delay + animation )
            - inactve   -> waiting to do the animation, incrementing the delay traker while this status is set
            - playing   -> playing the animation
            - pause     -> pause the animation
    ]]

    table.insert(active_tween, self)

    return self
end

function module:play()
    if self.tween_status == "pause" then
        self.tween_status = self.previous_tween_status
    elseif self.tween_status == "playing" or self.tween_status == "inactive" then
        self.previous_tween_status = self.tween_status
        self.tween_status = "pause"
    elseif self.tween_status == "waiting" then
        self.tween_status = "inactive"
    end
end

function module:replay()
    if self.tween_status ~= "waiting" then return end
    self.repeated_amount = 0
    self.tween_status = "inactive"
    self.tick = 0
    self:update(0)
    print("replay")
end

function module:cancel()
    self:destroy()
end

function module:pause()
    if self.tween_status ~= "playing" then return end
    self.tween_status = "pause"
end

function module:destroy()
    local position = nil
    for i,v in ipairs(active_tween) do
        if v == self then position = i break end
    end
    if position == nil then print("ERROR : request destroy tween isnt in the tween table") return end
    table.remove(active_tween, position)
end

function module:check_if_can_play()
    return ( self.repeated_amount < self.tween_repeat ) or ( self.tween_repeat == -1 )
end

function module:update(dt)
    if self.tween_status == "waiting" or self.tween_status == "pause" then
        return
    elseif self.tween_status == "playing" then
        self.tick = self.tick + dt
        local new_value
        if self.reverse_status == false then
            new_value = TweenData[self.tween_style](self.tick, self.target_value, self.start_value, self.tween_duration) -- reverse calculation
        else 
            new_value = TweenData[self.tween_style](self.tick, self.start_value, self.target_value, self.tween_duration) -- normal calculation
        end
        self.update_function(new_value,self.update_function_argument)
        if self.tick > self.tween_duration then -- stop the tween
            if self.tween_reverse == true then
                if self.reverse_status == false then
                    self.repeated_amount = self.repeated_amount + 1
                end
            else
                self.repeated_amount = self.repeated_amount + 1
            end
            self.tick = 0
            self.tween_status = "inactive"
        end
    elseif self.tween_status == "inactive" then
        if ( not self.reverse_status and self.tick >= self.tween_delay ) or ( self.reverse_status and self.tick > self.tween_reverse_delay ) then
            self.tick = 0
            if self:check_if_can_play() == true then
                self.tween_status = "playing"
                if self.tween_reverse == true then
                    self.reverse_status = not self.reverse_status
                end
                self:update(0) -- update the tween to start position
            else
                -- destroy the tween
                if self.destroy_after_play then
                    self:destroy()
                else
                    self.tween_status = "waiting"
                end
            end
        else
            -- update the wait status
            self.tick = self.tick + dt
        end
    end
end

function module.tween_update(dt)
    for i,tween in ipairs(active_tween) do
        tween:update(dt)
    end
end

return module