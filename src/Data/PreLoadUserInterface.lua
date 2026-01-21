local UI = require("src.Modules.UI")
local Color = require("src.Modules.Color")
local Assets = require("src.Loader.AssetsLoader")

return {
    MainScene = function()
        local fire_slash = UI.new({
            name = "fire_slash",
            ui_type = "sprite-sheet",
            position = {10,10},
            attribut = {
                image = Assets.Get("Fire Effect and Bullet 16x16.png"),
                size = {64,64},
                sprite_size = {16,16},
                sprite_quad_id = 1, -- optinal
                quad = {
                    love.graphics.newQuad(464,32,16,16,576,208),
                    love.graphics.newQuad(480,48,16,16,576,208),
                    love.graphics.newQuad(496,48,16,16,576,208),
                    love.graphics.newQuad(480,0,16,16,576,208),
                    love.graphics.newQuad(480+(16*1),0,16,16,576,208),
                    love.graphics.newQuad(480+(16*2),0,16,16,576,208),
                    love.graphics.newQuad(480+(16*3),0,16,16,576,208),
                    love.graphics.newQuad(480+(16*4),0,16,16,576,208),
                    love.graphics.newQuad(480+(16*5),0,16,16,576,208),
                    love.graphics.newQuad(480+(16*1),16,16,16,576,208),
                    love.graphics.newQuad(480+(16*2),16,16,16,576,208),
                    love.graphics.newQuad(480+(16*3),16,16,16,576,208),
                    love.graphics.newQuad(480+(16*4),16,16,16,576,208),
                    love.graphics.newQuad(480+(16*5),16,16,16,576,208),
                    love.graphics.newQuad(544,48,16,16,576,208),
                    love.graphics.newQuad(544+16,48,16,16,576,208),
                    love.graphics.newQuad(464,32,16,16,576,208),
                }
            }
        })

        local fire_tornado = UI.new({
            name = "fire_tornado",
            ui_type = "sprite-sheet",
            position = {80,10},
            attribut = {
                image = Assets.Get("Fire Effect and Bullet 16x16.png"),
                size = {256,256},
                sprite_size = {16,16},
                sprite_quad_id = 1, -- optional
                quad = {
                    love.graphics.newQuad(304,0,16,16,576,208),
                    love.graphics.newQuad(304+16,0,16,16,576,208),
                    love.graphics.newQuad(304+32,0,16,16,576,208),
                    love.graphics.newQuad(304+48,0,16,16,576,208),
                }
            }
        })
        --[[
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
            position = {300,100},
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
            },
            zindex = 2,
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

        local image3 = UI.new({
            name = "image3",
            ui_type = "image",
            position = {220,220},
            anchor_point = {x=0.5,y=0.5},
            zindex = 2,
            attribut = {
                image = "Deepwoken_icon.png",
                color = Color.fromPalette("blue"),
                size = {100,100}
            }
        })
        local image10 = UI.new({
            name = "image_test",
            ui_type = "image",
            position = {220,220},
            anchor_point = {x=0,y=0},
            attribut = {
                image = "Deepwoken_icon.png",
                color = Color.fromPalette("white"),
                size = {100,100}
            }
        })

        local image11 = UI.new({
            name = "image11",
            ui_type = "image",
            position = {350,220},
            anchor_point = {x=0,y=0},
            attribut = {
                image = "Deepwoken_icon.png",
                color = Color.fromPalette("white"),
                size = {100,100}
            }
        })


        local image2 = UI.new({
            name = "image2",
            ui_type = "image",
            position = {700,200},
            attribut = {
                image = "lua_icon.png",
                color = Color.fromPalette("white"),
                size = {100,100}
            },
            zindex = 1
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
        local zindex_2 = UI.new({
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

        local text1 = UI.new({
            name = "text1",
            parent = "workspace",
            ui_type = "text",
            position = {400,20},
            zindex = 3,
            attribut = {
                text = "voila un text bien long"
            }
        })
        local text2 = UI.new({
            name = "text2",
            parent = "workspace",
            ui_type = "text",
            position = {400,40},
            zindex = 3,
            attribut = {
                text = "voila un text encore bien plus long",
                rotation = math.rad(10)
            }
        })
        ]]
    end
}