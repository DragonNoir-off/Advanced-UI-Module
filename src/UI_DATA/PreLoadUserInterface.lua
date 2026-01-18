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
        local image1 = UI.new({
            name = "image1",
            ui_type = "image",
            position = {100,100},
            attribut = {
                image = "Deepwoken_icon.png",
                color = Color.fromPalette("white"),
                size = {100,100}
            }
        })

        local zindex_1 = UI.new({
            name = "rect",
            parent = "workspace",
            ui_type = "rectangle",
            position = {600,100},
            zindex = 1,
            attribut = {
                mode = "fill",
                size = {75,75},
                color = Color.fromRGB(0,200,0)
            }
        })
        local zindex_1 = UI.new({
            name = "rect2",
            parent = "workspace",
            ui_type = "rectangle",
            position = {650,100},
            zindex = 2,
            attribut = {
                mode = "fill",
                size = {75,75},
                color = Color.fromRGB(200,0,0)
            }
        })
    end
}