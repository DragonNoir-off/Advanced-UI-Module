local module = {}
module.__index = module

local function returnData(data, index, name) -- return data depend on "index" or "name" in the table "data"
    if data[index] ~= nil then return data[index] else return data[name] end
end

function module.new(ui_data)
    local self = setmetatable({}, module)
    
    --[[ ui_data data info
    
    1 / name : string
    2 / zindex : number
    3 / size : {scale-x,offset-x,scale-y,offset-y}
    4 / parent : object
    5 / childs : {object}
    6 / self-visible : bool
    7 / child-visible : bool
    8 / attribut : {
        -- global
        1 / ui_type : string

        -- circle
        2 / color : {number,number,number,number} ( 0-1 )
        
        -- rectangle
        2 / color : {number,number,number,number} ( 0-1 )
        3 / corner_radius : {number,number,number,number} ( 0-1 )
    }

    ]]
end

-- SET DATA TO OBJECT

return module