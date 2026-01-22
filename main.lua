--[[ SERVICES ]]
local utf8 = require("utf8")

--[[ MODULES ]]
local UI = require("src.Modules.UI")
local Assets_Image = require("src.Loader.AssetsLoader")
local task = require("src.Modules.Task")
local Tween = require("src.Modules.Tween")

--[[ DATA ]]
local PreLoadUserInterface = require("src.Data.PreLoadUserInterface")

--[[ CONSTANT ]]
local WINDOW_WIDTH = 960
local WINDOW_HEIGHT = 540
local SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions()

--[[ VARIABLES ]]

function love.load()
    -- GRAPHIC CONFIGURATION
    love.graphics.setDefaultFilter("nearest","nearest")

    -- LOAD ALL ASSETS
    Assets_Image.load_assets()

    -- LOAD WINDOW CONFIGURATION
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {resizable=true, fullscreen=false, fullscreentype = "desktop"})
    love.window.setPosition((SCREEN_WIDTH - WINDOW_WIDTH)/2,(SCREEN_HEIGHT - WINDOW_HEIGHT)/2,1) -- place the windows in the center of the screen
    love.window.setTitle("Advanced UI Module")
    love.window.setIcon(love.image.newImageData("assets/Images/fc441.png"))

    -- KEYBOARD CONFIGURATION
    love.keyboard.setKeyRepeat(true)

    -- UI CONFIGURATION
    PreLoadUserInterface.MainScene()

    --image1 = UI.returnObjectFromPath("workspace/fire_slash")

    --UI.debug__showAll()

    --[[
    local tween1 = Tween.create({
        start_data = 1,
        end_data = (#image1.attribut.quad),
        duration = 2,
        repeat_amount = -1,
        tween_style = "linear",
        delay = 1,
        update_function = function(value)
            image1.attribut.sprite_quad_id = math.floor(value)
        end
    }):play()
    ]]

    --[[
    local tween2 = Tween.create({
        start_data = 200,
        end_data = 600,
        duration = 2,
        tween_style = "quad_InOut",
        repeat_amount = -1,
        delay = 1,
        update_function = function(value)
            image1.position.x = value
        end
    }):play()]]

    weapon = UI.returnObjectFromPath("workspace/weapon")

    slash_tween = Tween.create({
        ownership = "tween_slash",
        start_data = 0,
        end_data = 110,
        duration = 0.4,
        tween_style = "quad_Out",
        update_function = function(value)
            weapon.attribut.rotation = math.rad(math.floor(value))
        end,
        clear_after_complet = false,
    })

    slash_tween2 = Tween.create({
        ownership = "tween_slash_reverse",
        start_data = 110,
        end_data = 0,
        duration = 1,
        tween_style = "linear",
        update_function = function(value)
            weapon.attribut.rotation = math.rad(math.floor(value))
        end,
        clear_after_complet = false,
    })

    
end

function love.update(dt)
    -- Module render update
    task.UpdateTask(dt)
    Tween.UpdateTween(dt)

    -- [[ TEST DIVERS ]]
    --image1:changeSize({image1.attribut.size.x + ( 100 * dt ),image1.attribut.size.y})
    --image1.attribut.rotation = image1.attribut.rotation + math.rad( dt * 60 )
    --image2.attribut.rotation = image2.attribut.rotation + math.rad( dt * 60 )
end

function love.keyreleased(key)
    if key == "escape" then love.event.quit() end
    if key == "z" then slash_tween:replay() end
    if key == "s" then  slash_tween2:replay() end
end

function love.draw()
    love.graphics.clear(0.2,0.2,0.2)
    UI.draw_ui()
end