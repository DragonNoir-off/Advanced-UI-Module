
--[[ MODULES ]]
local UI = require("src.Modules.UI")

function love.load()
    local rectangle_ui = UI.new({"voila un nom"})
    local rectangle_ui_2 = UI.new({["name"]="voila un autre"})
end

function love.update(dt)
    print(dt)
end

function love.draw()
    UI.draw()
end