local module = {}
module.__index = module

local function returnData(data, index, name) -- return data depend on "index" or "name" in the table "data"
    if data[index] ~= nil then return data[index] else return data[name] end
end

function module.new(ui_data)
    local self = setmetatable({}, module)
    
end

-- SET DATA TO OBJECT

return module