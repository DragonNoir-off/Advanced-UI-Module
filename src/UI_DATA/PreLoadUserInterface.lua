local UI = require("src.Modules.UI")
local Color = require("src.Modules.Color")

return {
    MainScene = function()
        local rectangle_1 = UI.new({
            name = "rectangle_1",
            ui_type = "rectangle",
            position = {10,10},
            attribut = {
                size = {100,75},
                color = Color.fromRGB(255,100,100)
            }
        })
        local rectangle_2 = UI.new({
            name = "rectangle_2",
            parent = rectangle_1,
            ui_type = "rectangle",
            position = {200,100},
            attribut = {
                mode = "line",
                size = {75,75},
                color = Color.fromRGB(0,200,0)
            }
        })
        local circle1 = UI.new({
            name = "circle1",
            ui_type = "circle",
            position = {100,300},
            attribut = {
                radius = 50,
                color = Color.fromRGB(0,255,255)
            }
        })
    end
}