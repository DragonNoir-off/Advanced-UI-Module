local module = {}
module.__index = module

-- Modules
local Color = require("src.Modules.Color")
local Assets = require("src.Loader.AssetsLoader")

local workspace = {}

function module.new(data)
    if data == nil then data = {} end
    local self = setmetatable({}, module)
    
    local function return_default(data, default)
        if data == nil then return default else return data end
    end

    self.name = return_default(data.name, "_")
    self.zindex = return_default(data.zindex, 1)
    self.parent = return_default(data.parent, "workspace")
    self.ui_type = return_default(data.ui_type, "scene")
    self.visible = return_default(data.visible, true)
    self.child_visible = return_default(data.child_visible, true)

    -- Commun Attribut Function
    
    -- set size of the element base on provide data
    function self.SetSize(_size, data)
        if data ~= nil then
            if data[1] ~= nil then -- if value X exist
                _size.x = data[1] -- set to value X
                if data[2] ~= nil then -- if value Y exist
                    _size.y = data[2] -- set to value Y
                else
                    _size.y = data[1] -- set to value X ( Y == nil )
                end
            end
        end
        return _size
    end

    function self.CalculateAnchorPoint(anchor_point, size_x, size_y)
        -- calculate anchor point relative to the element size
        anchor_point = return_default(anchor_point, {x=0,y=0})
        local new_anchor_point = {
            x = size_x * anchor_point.x,
            y = size_y * anchor_point.y
        }
        return new_anchor_point
    end

    -- Specific attributs
    
    -- set the position of the element
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
        attribut.color = return_default(data_attribut.color, Color.fromPalette("white"))
        attribut.mode = return_default(data_attribut.mode, "fill")

    elseif data.ui_type == "rectangle" then
        -- rectangle

        attribut.size = self.SetSize({x=0,y=0},data_attribut.size)
        -- modification can be added later but right now it does the work ( .scale / .offset || .x / .y )
        
        attribut.mode = return_default(data_attribut.mode, "fill")
        attribut.color = return_default(data_attribut.color, Color.fromPalette("white"))
        
        self.pre_render_anchor_point = data.anchor_point
        self.anchor_point = self.CalculateAnchorPoint(data.anchor_point, attribut.size.x, attribut.size.y)

    elseif data.ui_type == "image" then
        -- image

        attribut.size = self.SetSize({x=0,y=0},data_attribut.size)

        attribut.color = return_default(data_attribut.color, Color.fromPalette("white"))
        attribut.rotation = return_default(data_attribut.rotation, 0)
        attribut.image = return_default(data_attribut.image, Assets.Get("lua_icon.png"))

        self.pre_render_anchor_point = data.anchor_point
        self.anchor_point = self.CalculateAnchorPoint(data.anchor_point, attribut.image:getWidth(), attribut.image:getHeight())

    elseif data.ui_type == "text" then
        attribut.text = return_default(data_attribut.text, "")
        attribut.rotation = return_default(data_attribut.rotation, 0)
        
        attribut.size = self.SetSize({x=1,y=1},data_attribut.size)

    elseif data.ui_type == "sprite-sheet" then

        attribut.size = self.SetSize({x=0,y=0},data_attribut.size)

        attribut.color = return_default(data_attribut.color, Color.fromPalette("white"))
        attribut.rotation = return_default(data_attribut.rotation, 0)
        attribut.image = return_default(data_attribut.image, Assets.Get("assets/Fire Effect and Bullet 16x16.png"))

        attribut.sprite_size = self.SetSize({x=0,y=0},data_attribut.sprite_size)

        self.pre_render_anchor_point = data.anchor_point
        self.anchor_point = self.CalculateAnchorPoint(data.anchor_point, attribut.image:getWidth(), attribut.image:getHeight())

        attribut.sprite_quad_id = return_default(data_attribut.sprite_quad_id,1)
        attribut.quad = data_attribut.quad
    end
    self.attribut = attribut

    -- Child and Parent structure

    self:changeParent(self.parent)
    self.child = {}

    -- Privates functions

    function self.returnChildPosition(child)
        if type(child) == "string" then
            for i,v in pairs(self.child) do
                if v.name == child then return i end
            end
        else
            for i,v in pairs(self.child) do
                if v == child then return i end
            end
        end
    end

    return self
end

-- CLASS FUNCTION

function module:changeSize(new_size)
    self.attribut.size = self.SetSize(self.attribut.size, new_size)
    self:changeAnchorPoint(self.pre_render_anchor_point)
end

function module:changeAnchorPoint(new_anchor_point)
    local ui_type = self.ui_type
    if ui_type == "image" then
        self.anchor_point = self.CalculateAnchorPoint(new_anchor_point, self.attribut.image:getWidth(), self.attribut.image:getHeight())
    elseif ui_type == "rectangle" then
        self.anchor_point = self.CalculateAnchorPoint(new_anchor_point, self.attribut.size.x, self.attribut.size.y)
    end
end

function module:changeImage(new_image)
    if self.ui_type ~= "image" then return end
    if type(new_image) == "string" then
        local image = Assets.Get(new_image)
        if image ~= nil then self.attribut.image = image end
    else

    end
end

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
    
    local function get_zindex_position(childs)
        for i,child in ipairs(childs) do
            if child.zindex > self.zindex then
                return i
            end
        end
        return (#childs)+1
    end

    if type(new_parent) == "string" then
        if new_parent == "workspace" then
            self.parent = "workspace"
            table.insert(workspace, get_zindex_position(workspace), self)
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

        table.insert(new_parent.child, get_zindex_position(new_parent.child), self)
    else
        print("[[ ERROR | UI.lua , module:changeParent() ]] -- the parent element have to be a UI class Object or a Path to a valide UI class Object")
        print("[[ LOG ]] -> type of the provide parent : "..type(new_parent))
    end
end

function module:returnPath()
    local path = self.name
    local parent = self.parent

    if parent == "workspace" then return "workspace/"..path end

    -- loop until workspace to re-creat the path
    repeat
        path = parent.name.."/"..path
        parent = parent.parent
    until parent == "workspace"

    return "workspace/"..path
end

function module:draw()
    local attribut = self.attribut
    local ui_type = self.ui_type

    local function get_position() return self.position.x, self.position.y end
    local function get_rotation() return attribut.rotation end
    local function get_color() return attribut.color end
    local function get_size() return attribut.size.x, attribut.size.y end
    local function get_anchor_offset() return self.anchor_point.x, self.anchor_point.y end

    if ui_type == "scene" then
        -- do nothing
    elseif self.ui_type == "circle" then
        local mode = attribut.mode
        local x, y = get_position()
        local radius = attribut.radius
        local color = get_color()

        love.graphics.setColor(unpack(color))
        love.graphics.circle(mode, x, y, radius)

    elseif ui_type == "rectangle" then
        local mode = attribut.mode
        local pos_x, pos_y = get_position()
        local size_x, size_y = get_size()
        local color = get_color()
        local anchor_offset_x, anchor_offset_y = get_anchor_offset()

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(mode, pos_x, pos_y, size_x, size_y, anchor_offset_x, anchor_offset_y)

    elseif ui_type == "image" then
        local pos_x, pos_y = get_position()
        local image = attribut.image
        local size_x, size_y = get_size()
        local rotation = get_rotation()
        local color = get_color()
        local anchor_offset_x, anchor_offset_y = get_anchor_offset()

        local ratio_x = ( size_x / image:getWidth() )
        local ratio_y = ( size_y / image:getHeight() )

        love.graphics.setColor(unpack(color))
        love.graphics.draw(image, pos_x, pos_y, rotation, ratio_x, ratio_y, anchor_offset_x, anchor_offset_y)

    elseif ui_type == "text" then
        local text = attribut.text
        local pos_x, pos_y = get_position()
        local rotation = get_rotation()
        local font_size_x, font_size_y = get_size()

        love.graphics.print(text, pos_x, pos_y, rotation, font_size_x, font_size_y)

    elseif ui_type == "sprite-sheet" then
        local image = attribut.image
        local size_x, size_y = get_size()
        local sprite_size_x, sprite_size_y = attribut.sprite_size.x, attribut.sprite_size.y
        local pos_x, pos_y = get_position()
        local rotation = get_rotation()
        local color = get_color()
        local anchor_offset_x, anchor_offset_y = get_anchor_offset()
        local quad = attribut.quad[attribut.sprite_quad_id]

        if quad == nil then
            print("[[ ERROR | UI.lua , module:draw() ]] -- the provide quad doesnt exist")
            print("[[ LOG ]] -> sprite position : "..attribut.sprite_quad_id.." , sprite name : "..self.name)
            return
        end -- dont draw if quad doesnt exist

        local ratio_x = ( size_x / sprite_size_x )
        local ratio_y = ( size_y / sprite_size_y)
        
        love.graphics.setColor(unpack(color))
        love.graphics.draw(image, quad, pos_x, pos_y, rotation, ratio_x, ratio_y, anchor_offset_x, anchor_offset_y)
        
    end
end

-- MODULE FUNCTION
function module.returnChildPosition(self, child)
    if self == workspace then
        if type(child) == "string" then
            for i,v in pairs(workspace) do
                if v.name == child then return i end
            end
        else
            for i,v in pairs(workspace) do
                if v == child then return i end
            end
        end
    else
        return self.returnChildPosition(child)
    end
end

function module.draw_ui()
    
    local function loop_children(ui)
        if ui.visible then ui:draw() end
        for i,v in ipairs(ui.child) do
            if ui.child_visible then loop_children(v) end
        end
    end

    for i,v in pairs(workspace) do
        loop_children(v)
    end

end

function module.returnPathFromObject(self)
    return self:returnPath()
end

function module.returnObjectFromPath(path)
    if type(path) ~= "string" then print("[[ ERROR | UI.lua , module.returnObjectFromPath() ]] -- the path provide isnt a string") return nil end
    if string.sub(path, 1, 9) ~= "workspace" then print("[[ ERROR | UI.lua , module.returnObjectFromPath() ]] -- the path provide isnt starting in the workspace") return nil end
    
    -- remove workspace/ from string ( default required value in path )
    local object = workspace
    path = string.gsub(path, "workspace/", "")
    path = path.."/" -- require to detect the end of the path

    -- collect all "/" position for easier split
    local slash_table = {}
    for i=1, string.len(path), 1 do
        if string.sub(path,i,i) == "/" then table.insert(slash_table, i) end
    end

    local PathIsValide = true
    for i,v in pairs(slash_table) do
        local next_object = object[module.returnChildPosition(workspace, string.sub(path,(slash_table[i-1] or 0)+1,v-1))]
        if next_object ~= nil and PathIsValide then
            object = next_object
        else
            PathIsValide = false -- stop the for loop and return the lastest object
        end
    end

    return object, PathIsValide
end

--  DEBUG FUNCTION

-- return entire workpace in table type
function module.debug__returnWorkspace() return workspace end

-- print in terminal the entire workspace architecture
function module.debug__showAll()
    local function indent_string(str, number_indent)
        for i=1, number_indent, 1 do
            str = "\t"..str
        end
        return str
    end

    local function loop_instance(childs, depths)
        for i,v in ipairs(childs) do
            print(v:returnPath()) --"depths:"..depths, "childs:"..(#v.child),
            loop_instance(v.child, depths+1)
        end
    end

    loop_instance(workspace, 0)
end

return module