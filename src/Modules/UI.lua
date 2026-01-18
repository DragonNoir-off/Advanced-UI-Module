local module = {}
module.__index = module

-- Modules
local Color = require("src.Modules.Color")

local workspace = {}
function module.returnWorkspace() return workspace end -- debug function

function module.new(data)
    if data == nil then data = {} end
    local self = setmetatable({}, module)
    
    local function return_default(data, default)
        if data == nil then return default else return data end
    end

    self.name = return_default(data.name, "_")
    self.zindex = return_default(data.zindex, 1)
    self:changeParent(return_default(data.parent, "workspace"))
    self.ui_type = return_default(data.ui_type, "scene")
    self.visible = return_default(data.visible, true)
    self.child_visible = return_default(data.child_visible, true)
    
    -- Specific attributs
    
    local position = {x=0,y=0}
    if data.position ~= nil then
        if data.position[1] ~= nil then position.x = data.position[1] end
        if data.position[2] ~= nil then position.y = data.position[2] end
    end -- modification can be added later but right now it does the work
    self.position = position

    local data_attribut = return_default(data.attribut, {}) -- prevent nil table access ( error )
    self.attribut = {}
    local attribut = self.attribut
    if data.ui_type == "scene" then
        -- place holder

    elseif data.ui_type == "circle" then
        -- circle

        attribut.radius = return_default(data_attribut.radius, 0)
        attribut.color = return_default(data_attribut.color, Color.fromRGB(255,255,255))
        attribut.mode = return_default(data_attribut.mode, "fill")

    elseif data.ui_type == "rectangle" then
        -- rectangle

        attribut.size = {x=0,y=0}
        if data_attribut.size ~= nil then
            if data_attribut.size[1] ~= nil then attribut.size.x = data_attribut.size[1] end
            if data_attribut.size[2] ~= nil then attribut.size.y = data_attribut.size[2] end
        end -- modification can be added later but right now it does the work ( .scale / .offset || .x / .y )
        
        attribut.mode = return_default(data_attribut.mode, "fill")
        attribut.color = return_default(data_attribut.color, Color.fromRGB(255,255,255))

    elseif data.ui_type == "image" then
        -- image

    elseif data.ui_type == "sprite-sheet" then
        -- sprite-sheet

    end
    self.attribut = attribut

    -- Default attributs

    self.child = {}

    -- Privates functions

    self.returnChildPosition = function(child)
        for i,v in pairs(self.child) do
            if v == child then return i end
        end
    end

    return self
end

-- CLASS FUNCTION

function module:addChild(child)
    local IsChildValid = true

    if type(child) == "string" then
        child = module.returnObjectFromPath(child)
        if child == nil then
            print("[[ ERROR | UI.lua , module:addChild() ]] -- the path provide isnt a valide path")
            IsChildValid = false
        end
    elseif getmetatable(child) ~= module then
        print("[[ ERROR | UI.lua , module:addChild() ]] -- the child provide isnt from a UI class Object")
        IsChildValid = false
    end

    if IsChildValid then
        child:changeParent(self)
    end
end

function module:removeChild(child)
    local IsChildValid = true

    if type(child) == "string" then
        child = module.returnObjectFromPath(child)
        if child == nil then
            print("[[ ERROR | UI.lua , module:addChild() ]] -- the path provide isnt a valide path")
            IsChildValid = false
        end
    elseif getmetatable(child) ~= module then
        print("[[ ERROR | UI.lua , module:addChild() ]] -- the child provide isnt from a UI class Object")
        IsChildValid = false
    end

    if IsChildValid and child.parent == self then
        table.remove(self.child, self.returnChildPosition(child))
    end
end

function module:changeParent(new_parent)
    --print("change parent of ",self.name," to ",new_parent.name or new_parent)
    if type(new_parent) == "string" then
        if new_parent == "workspace" then
            self.parent = "workspace"
            table.insert(workspace, self)
        else
            new_parent = module.returnObjectFromPath(new_parent)
            if new_parent == nil then
                print("[[ ERROR | UI.lua , module:changeParent() ]] -- the provide path isnt a valid UI class Object")
            else
                table.insert(new_parent.child, self)
            end
        end
    elseif getmetatable(new_parent) == module then
        if self.parent ~= nil and getmetatable(self.parent) == module then
            table.remove(self.parent.child, self.parent.returnChildPosition(self))
        elseif self.parent ~= nil and not getmetatable(self.parent) == module then
            print("[[ WARN | UI.lua , module:changeParent() ]] -- the previous parent element isnt a UI class Object")
            print("[[ LOG ]] -> no change have been done to the previous parent")
        end
        self.parent = new_parent
        table.insert(new_parent.child, self)
    else
        print("[[ ERROR | UI.lua , module:changeParent() ]] -- the parent element have to be a UI class Object or a Path to a valide UI class Object")
        print("[[ LOG ]] -> type of the provide parent : "..type(new_parent))
    end
end

function module:returnPath()
    local path = ""
    local parent = self.parent

    -- loop until workspace to re-creat the path
    repeat
        path = parent.name.."/"..path
        parent = self.parent
    until parent == "workspace"

    return "workspace/"..path
end

function module:draw()
    print(self.name)
    local attribut = self.attribut
    if self.ui_type == "scene" then
        -- do nothing
    elseif self.ui_type == "circle" then
        local mode = attribut.mode
        local x = self.position.x
        local y = self.position.y
        local radius = attribut.radius
        local color = attribut.color

        love.graphics.setColor(unpack(color))
        love.graphics.circle(mode, x, y, radius)

    elseif self.ui_type == "rectangle" then
        local mode = attribut.mode
        local pos_x = self.position.x
        local pos_y = self.position.y
        local size_x = attribut.size.x
        local size_y = attribut.size.y
        local color = attribut.color

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(mode, pos_x, pos_y, size_x, size_y)
    end
end

-- MODULE FUNCTION
function module.draw_ui()
    
    local function loop_children(ui)
        ui:draw()
        for i,v in pairs(ui.child) do
            loop_children(v)
        end
    end

    print("-----------------")
    for i,v in pairs(workspace) do
        loop_children(v)
    end

end

function module.returnPathFromObject(self)
    return self:returnPath()
end

function module.returnObjectFromPath(path)
    if type(path) ~= "string" then print("[[ ERROR | UI.lua , module.returnObjectFromPath() ]] -- the path provide isnt a string") return nil end
    if string.sub(path, 1, 11) ~= "workspace" then print("[[ ERROR | UI.lua , module.returnObjectFromPath() ]] -- the path provide isnt starting in the workspace") return nil end
    
    -- remove workspace/ from string ( default required value in path )
    local object = workspace
    path = string.gsub(path, "workspace/", "")
    path = path.."/" -- require to detect the end of the path
    
    -- collect all "/" position for easier split
    local slash_table = {}
    for i=1, string.len(path), 1 do
        if string.sub(path,i,i) == "/" then table.insert(slash_table, i) end
    end

    for i,v in pairs(slash_table) do
        --print(i,v)
    end

    return object
end

return module